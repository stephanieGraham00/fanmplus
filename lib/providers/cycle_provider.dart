import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cycle_model.dart';
import '../models/cycle_history.dart';
import '../models/tracker_model.dart';
import '../utils/helpers.dart';
import '../services/tracking_service.dart';

final trackingServiceProvider = Provider<TrackingService>((ref) => TrackingService());

class CycleState {
  final DateTime? lastPeriodDate;
  final int cycleLength;
  final int periodLength;
  final CyclePrediction? prediction;
  final List<CycleLog> logs;
  final List<CycleHistory> cycleHistory;
  final List<DateTime> periodStarts;
  final int adaptiveCycleLength;
  final bool isLoading;

  const CycleState({
    this.lastPeriodDate,
    this.cycleLength = 28,
    this.periodLength = 5,
    this.prediction,
    this.logs = const [],
    this.cycleHistory = const [],
    this.periodStarts = const [],
    this.adaptiveCycleLength = 28,
    this.isLoading = false,
  });

  CycleState copyWith({
    DateTime? lastPeriodDate,
    int? cycleLength,
    int? periodLength,
    CyclePrediction? prediction,
    List<CycleLog>? logs,
    List<CycleHistory>? cycleHistory,
    List<DateTime>? periodStarts,
    int? adaptiveCycleLength,
    bool? isLoading,
  }) {
    return CycleState(
      lastPeriodDate: lastPeriodDate ?? this.lastPeriodDate,
      cycleLength: cycleLength ?? this.cycleLength,
      periodLength: periodLength ?? this.periodLength,
      prediction: prediction ?? this.prediction,
      logs: logs ?? this.logs,
      cycleHistory: cycleHistory ?? this.cycleHistory,
      periodStarts: periodStarts ?? this.periodStarts,
      adaptiveCycleLength: adaptiveCycleLength ?? this.adaptiveCycleLength,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CycleNotifier extends StateNotifier<CycleState> {
  final TrackingService _tracking;
  CycleNotifier(this._tracking) : super(const CycleState()) {
    _loadFromFirestore();
  }

  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  Future<void> _loadFromFirestore() async {
    final uid = _userId;
    if (uid == null) return;
    state = state.copyWith(isLoading: true);

    try {
      final settings = await _tracking.getCycleSettings(uid);
      final logs = await _tracking.getCycleLogs(uid);
      final periodStarts = await _tracking.getPeriodStarts(uid);
      final flowLogs = await _tracking.getFlowLogs(uid);

      DateTime? lastPeriod;
      int cycleLen = 28;
      int periodLen = 5;

      if (settings != null) {
        if (settings['lastPeriodDate'] != null) {
          lastPeriod = DateTime.tryParse(settings['lastPeriodDate']);
        }
        cycleLen = settings['cycleLength'] ?? 28;
        periodLen = settings['periodLength'] ?? 5;
      }

      // Detect period starts from flow logs if not already stored
      final allFlowDates = flowLogs.map((f) => DateTime(f.date.year, f.date.month, f.date.day)).toList();
      final detectedStarts = CycleCalculator.detectPeriodStarts(allFlowDates);

      // Merge stored period starts with detected ones
      final allStarts = <DateTime>{...periodStarts, ...detectedStarts};
      final mergedStarts = allStarts.toList()..sort();

      // Use last period start as lastPeriodDate if available and current one is null
      if (lastPeriod == null && mergedStarts.isNotEmpty) {
        lastPeriod = mergedStarts.last;
      }

      // Compute adaptive cycle length
      final adaptiveLen = CycleCalculator.computeAdaptiveCycleLength(mergedStarts);
      final effectiveCycleLen = adaptiveLen ?? cycleLen;
      final usedPeriodStarts = mergedStarts;

      state = state.copyWith(
        lastPeriodDate: lastPeriod,
        cycleLength: cycleLen,
        periodLength: periodLen,
        logs: logs,
        periodStarts: usedPeriodStarts,
        adaptiveCycleLength: effectiveCycleLen,
        isLoading: false,
      );
      _updatePrediction();

      // Save detected period starts to Firestore
      for (final start in detectedStarts) {
        if (!periodStarts.contains(start)) {
          _tracking.savePeriodStart(uid, start);
        }
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void setLastPeriod(DateTime date) {
    state = state.copyWith(lastPeriodDate: date);
    _updatePrediction();
    _saveToFirestore();
    _savePeriodStart(date);
  }

  void setCycleLength(int length) {
    state = state.copyWith(cycleLength: length);
    _updatePrediction();
    _saveToFirestore();
  }

  void setPeriodLength(int length) {
    state = state.copyWith(periodLength: length);
    _saveToFirestore();
  }

  /// Called when user logs flow for a day. Detects if this starts a new period.
  Future<void> onFlowLogged(FlowLog log) async {
    final uid = _userId;
    if (uid == null) return;

    // Get recent flow dates to check if this is a new period start
    final existingStarts = state.periodStarts;
    final allFlowDates = [...existingStarts];

    final isNewStart = CycleCalculator.isNewPeriodStart(log.date, allFlowDates);

    if (isNewStart) {
      // This flow marks a new period start
      state = state.copyWith(lastPeriodDate: log.date);
      final updatedStarts = [...state.periodStarts, log.date]..sort();
      state = state.copyWith(periodStarts: updatedStarts);

      final adaptiveLen = CycleCalculator.computeAdaptiveCycleLength(updatedStarts);
      if (adaptiveLen != null) {
        state = state.copyWith(adaptiveCycleLength: adaptiveLen);
      }

      _updatePrediction();
      _saveToFirestore();
      _savePeriodStart(log.date);
    }
  }

  void _savePeriodStart(DateTime date) {
    final uid = _userId;
    if (uid == null) return;
    _tracking.savePeriodStart(uid, date);
  }

  void _updatePrediction() {
    if (state.lastPeriodDate == null) return;

    final effectiveLength = state.adaptiveCycleLength;

    final prediction = CyclePrediction(
      cycleDay: CycleCalculator.calculateCycleDay(state.lastPeriodDate!, effectiveLength),
      nextPeriod: CycleCalculator.predictNextPeriod(state.lastPeriodDate!, effectiveLength),
      nextOvulation: CycleCalculator.predictOvulation(state.lastPeriodDate!, effectiveLength),
      fertileWindow: CycleCalculator.getFertileWindow(state.lastPeriodDate!, effectiveLength),
      cyclePhase: CycleCalculator.getCyclePhase(state.lastPeriodDate!, effectiveLength),
      pregnancyChance: CycleCalculator.getPregnancyChance(state.lastPeriodDate!, effectiveLength),
      daysUntilNextPeriod: CycleCalculator.daysUntilNextPeriod(state.lastPeriodDate!, effectiveLength),
    );
    state = state.copyWith(prediction: prediction);
  }

  void addLog(CycleLog log) {
    state = state.copyWith(logs: [log, ...state.logs]);
    _tracking.saveCycleLog(_userId ?? '', log);
  }

  void _saveToFirestore() {
    final uid = _userId;
    if (uid == null) return;
    _tracking.saveCycleSettings(uid,
      lastPeriod: state.lastPeriodDate,
      cycleLength: state.cycleLength,
      periodLength: state.periodLength,
    );
  }

  /// Manually set period start (for calendar quick-log)
  Future<void> logPeriodStart(DateTime date) async {
    final uid = _userId;
    if (uid == null) return;

    state = state.copyWith(lastPeriodDate: date);
    final updatedStarts = [...state.periodStarts, date]..sort();
    state = state.copyWith(periodStarts: updatedStarts);

    final adaptiveLen = CycleCalculator.computeAdaptiveCycleLength(updatedStarts);
    if (adaptiveLen != null) {
      state = state.copyWith(adaptiveCycleLength: adaptiveLen);
    }

    _updatePrediction();
    _saveToFirestore();
    _savePeriodStart(date);
  }
}

final cycleProvider = StateNotifierProvider<CycleNotifier, CycleState>((ref) {
  return CycleNotifier(ref.read(trackingServiceProvider));
});
