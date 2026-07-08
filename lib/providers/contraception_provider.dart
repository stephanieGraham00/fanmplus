import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/tracker_model.dart';
import '../services/tracking_service.dart';

class ContraceptionState {
  final List<ContraceptionLog> logs;
  final String currentMethod;
  final bool lastWasProtected;
  final bool lastMorningAfter;
  final bool isLoading;

  const ContraceptionState({
    this.logs = const [],
    this.currentMethod = 'none',
    this.lastWasProtected = false,
    this.lastMorningAfter = false,
    this.isLoading = false,
  });

  ContraceptionState copyWith({
    List<ContraceptionLog>? logs,
    String? currentMethod,
    bool? lastWasProtected,
    bool? lastMorningAfter,
    bool? isLoading,
  }) {
    return ContraceptionState(
      logs: logs ?? this.logs,
      currentMethod: currentMethod ?? this.currentMethod,
      lastWasProtected: lastWasProtected ?? this.lastWasProtected,
      lastMorningAfter: lastMorningAfter ?? this.lastMorningAfter,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  int get totalProtected => logs.where((l) => l.wasProtected).length;
  int get totalUnprotected => logs.where((l) => !l.wasProtected).length;
  int get morningAfterCount => logs.where((l) => l.tookMorningAfter).length;
  double get protectionRate => logs.isEmpty ? 0 : totalProtected / logs.length;
}

class ContraceptionNotifier extends StateNotifier<ContraceptionState> {
  final TrackingService _tracking;
  ContraceptionNotifier(this._tracking) : super(const ContraceptionState()) {
    _loadFromFirestore();
  }

  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  Future<void> _loadFromFirestore() async {
    final uid = _userId;
    if (uid == null) return;
    state = state.copyWith(isLoading: true);

    try {
      final logs = await _tracking.getContraceptionLogs(uid);
      state = state.copyWith(logs: logs, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void addLog(ContraceptionLog log) {
    state = state.copyWith(
      logs: [log, ...state.logs],
      currentMethod: log.method,
      lastWasProtected: log.wasProtected,
      lastMorningAfter: log.tookMorningAfter,
    );
    final uid = _userId;
    if (uid != null) _tracking.saveContraceptionLog(uid, log);
  }

  void setMethod(String method) {
    state = state.copyWith(currentMethod: method);
  }

  void removeLog(int index) {
    final updated = [...state.logs];
    updated.removeAt(index);
    state = state.copyWith(logs: updated);
  }

  List<ContraceptionLog> getLogsForMonth(DateTime month) {
    return state.logs.where((l) =>
      l.date.year == month.year && l.date.month == month.month
    ).toList();
  }

  Map<String, int> getMethodStats() {
    final stats = <String, int>{};
    for (final log in state.logs) {
      stats[log.method] = (stats[log.method] ?? 0) + 1;
    }
    return stats;
  }
}

final contraceptionProvider = StateNotifierProvider<ContraceptionNotifier, ContraceptionState>((ref) {
  return ContraceptionNotifier(ref.read(trackingServiceProvider));
});
