import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/tracker_model.dart';
import '../services/tracking_service.dart';

class BodyMetricsState {
  final List<TemperatureLog> temperatures;
  final List<WeightLog> weights;
  final List<BloodPressureLog> bloodPressures;
  final List<FlowLog> flowLogs;
  final List<DischargeLog> dischargeLogs;
  final List<MycosisLog> mycosisLogs;
  final bool isLoading;

  const BodyMetricsState({
    this.temperatures = const [],
    this.weights = const [],
    this.bloodPressures = const [],
    this.flowLogs = const [],
    this.dischargeLogs = const [],
    this.mycosisLogs = const [],
    this.isLoading = false,
  });

  BodyMetricsState copyWith({
    List<TemperatureLog>? temperatures,
    List<WeightLog>? weights,
    List<BloodPressureLog>? bloodPressures,
    List<FlowLog>? flowLogs,
    List<DischargeLog>? dischargeLogs,
    List<MycosisLog>? mycosisLogs,
    bool? isLoading,
  }) {
    return BodyMetricsState(
      temperatures: temperatures ?? this.temperatures,
      weights: weights ?? this.weights,
      bloodPressures: bloodPressures ?? this.bloodPressures,
      flowLogs: flowLogs ?? this.flowLogs,
      dischargeLogs: dischargeLogs ?? this.dischargeLogs,
      mycosisLogs: mycosisLogs ?? this.mycosisLogs,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  double? get latestTemperature => temperatures.isEmpty ? null : temperatures.first.temperature;
  double? get latestWeight => weights.isEmpty ? null : weights.first.weight;
  BloodPressureLog? get latestBloodPressure => bloodPressures.isEmpty ? null : bloodPressures.first;
  FlowLog? get latestFlow => flowLogs.isEmpty ? null : flowLogs.first;
}

class BodyMetricsNotifier extends StateNotifier<BodyMetricsState> {
  final TrackingService _tracking;
  BodyMetricsNotifier(this._tracking) : super(const BodyMetricsState()) {
    _loadFromFirestore();
  }

  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  Future<void> _loadFromFirestore() async {
    final uid = _userId;
    if (uid == null) return;
    state = state.copyWith(isLoading: true);

    try {
      final temps = await _tracking.getTemperatures(uid);
      final weights = await _tracking.getWeights(uid);
      final bps = await _tracking.getBloodPressures(uid);
      final flows = await _tracking.getFlowLogs(uid);
      final discharges = await _tracking.getDischargeLogs(uid);
      final mycoses = await _tracking.getMycosisLogs(uid);

      state = state.copyWith(
        temperatures: temps,
        weights: weights,
        bloodPressures: bps,
        flowLogs: flows,
        dischargeLogs: discharges,
        mycosisLogs: mycoses,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void addTemperature(TemperatureLog log) {
    state = state.copyWith(temperatures: [log, ...state.temperatures]);
    final uid = _userId;
    if (uid != null) _tracking.saveTemperature(uid, log);
  }

  void addWeight(WeightLog log) {
    state = state.copyWith(weights: [log, ...state.weights]);
    final uid = _userId;
    if (uid != null) _tracking.saveWeight(uid, log);
  }

  void addBloodPressure(BloodPressureLog log) {
    state = state.copyWith(bloodPressures: [log, ...state.bloodPressures]);
    final uid = _userId;
    if (uid != null) _tracking.saveBloodPressure(uid, log);
  }

  void addFlow(FlowLog log) {
    state = state.copyWith(flowLogs: [log, ...state.flowLogs]);
    final uid = _userId;
    if (uid != null) _tracking.saveFlow(uid, log);
  }

  void addDischarge(DischargeLog log) {
    state = state.copyWith(dischargeLogs: [log, ...state.dischargeLogs]);
    final uid = _userId;
    if (uid != null) _tracking.saveDischarge(uid, log);
  }

  void addMycosis(MycosisLog log) {
    state = state.copyWith(mycosisLogs: [log, ...state.mycosisLogs]);
    final uid = _userId;
    if (uid != null) _tracking.saveMycosis(uid, log);
  }

  List<TemperatureLog> getTemperaturesForMonth(DateTime month) {
    return state.temperatures.where((t) =>
      t.date.year == month.year && t.date.month == month.month
    ).toList();
  }

  List<WeightLog> getWeightsForMonth(DateTime month) {
    return state.weights.where((w) =>
      w.date.year == month.year && w.date.month == month.month
    ).toList();
  }

  List<FlowLog> getFlowForMonth(DateTime month) {
    return state.flowLogs.where((f) =>
      f.date.year == month.year && f.date.month == month.month
    ).toList();
  }

  List<DischargeLog> getDischargeForMonth(DateTime month) {
    return state.dischargeLogs.where((d) =>
      d.date.year == month.year && d.date.month == month.month
    ).toList();
  }

  List<MycosisLog> getMycosisForMonth(DateTime month) {
    return state.mycosisLogs.where((m) =>
      m.date.year == month.year && m.date.month == month.month
    ).toList();
  }

  double getAverageTemperatureForMonth(DateTime month) {
    final logs = getTemperaturesForMonth(month);
    if (logs.isEmpty) return 36.5;
    return logs.map((t) => t.temperature).reduce((a, b) => a + b) / logs.length;
  }

  double getAverageWeightForMonth(DateTime month) {
    final logs = getWeightsForMonth(month);
    if (logs.isEmpty) return 60.0;
    return logs.map((w) => w.weight).reduce((a, b) => a + b) / logs.length;
  }
}

final bodyMetricsProvider = StateNotifierProvider<BodyMetricsNotifier, BodyMetricsState>((ref) {
  return BodyMetricsNotifier(ref.read(trackingServiceProvider));
});
