import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/tracker_model.dart';
import '../services/tracking_service.dart';

class TrackerState {
  final String currentMood;
  final int waterGlasses;
  final int waterGoal;
  final int exerciseMinutes;
  final int sleepHours;
  final int sleepQuality;
  final List<SymptomLog> todaySymptoms;
  final List<MoodLog> moodHistory;
  final List<WaterLog> waterHistory;
  final bool isLoading;

  const TrackerState({
    this.currentMood = '',
    this.waterGlasses = 0,
    this.waterGoal = 8,
    this.exerciseMinutes = 0,
    this.sleepHours = 0,
    this.sleepQuality = 3,
    this.todaySymptoms = const [],
    this.moodHistory = const [],
    this.waterHistory = const [],
    this.isLoading = false,
  });

  double get waterProgress => waterGlasses / waterGoal;

  TrackerState copyWith({
    String? currentMood,
    int? waterGlasses,
    int? waterGoal,
    int? exerciseMinutes,
    int? sleepHours,
    int? sleepQuality,
    List<SymptomLog>? todaySymptoms,
    List<MoodLog>? moodHistory,
    List<WaterLog>? waterHistory,
    bool? isLoading,
  }) {
    return TrackerState(
      currentMood: currentMood ?? this.currentMood,
      waterGlasses: waterGlasses ?? this.waterGlasses,
      waterGoal: waterGoal ?? this.waterGoal,
      exerciseMinutes: exerciseMinutes ?? this.exerciseMinutes,
      sleepHours: sleepHours ?? this.sleepHours,
      sleepQuality: sleepQuality ?? this.sleepQuality,
      todaySymptoms: todaySymptoms ?? this.todaySymptoms,
      moodHistory: moodHistory ?? this.moodHistory,
      waterHistory: waterHistory ?? this.waterHistory,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class TrackerNotifier extends StateNotifier<TrackerState> {
  final TrackingService _tracking;
  TrackerNotifier(this._tracking) : super(const TrackerState()) {
    _loadFromFirestore();
  }

  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  Future<void> _loadFromFirestore() async {
    final uid = _userId;
    if (uid == null) return;
    state = state.copyWith(isLoading: true);

    try {
      final water = await _tracking.getWaterToday(uid);
      final exercise = await _tracking.getExerciseToday(uid);
      final sleep = await _tracking.getSleepToday(uid);
      final symptoms = await _tracking.getSymptomsForDate(uid, DateTime.now());
      final moodHistory = await _tracking.getMoodLogs(uid, limit: 30);

      state = state.copyWith(
        waterGlasses: water?.glasses ?? 0,
        waterGoal: water?.goal ?? 8,
        exerciseMinutes: exercise?.durationMinutes ?? 0,
        sleepHours: sleep?.hours ?? 0,
        sleepQuality: sleep?.quality ?? 3,
        todaySymptoms: symptoms,
        moodHistory: moodHistory,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void setMood(String mood) {
    state = state.copyWith(currentMood: mood);
    final uid = _userId;
    if (uid == null) return;
    final log = MoodLog(userId: uid, mood: mood, date: DateTime.now());
    _tracking.saveMood(uid, log);
  }

  void addWater() {
    final newCount = state.waterGlasses + 1;
    state = state.copyWith(waterGlasses: newCount);
    _saveWater();
  }

  void removeWater() {
    if (state.waterGlasses > 0) {
      state = state.copyWith(waterGlasses: state.waterGlasses - 1);
      _saveWater();
    }
  }

  void _saveWater() {
    final uid = _userId;
    if (uid == null) return;
    _tracking.saveWater(uid, WaterLog(
      userId: uid,
      date: DateTime.now(),
      glasses: state.waterGlasses,
      goal: state.waterGoal,
    ));
  }

  void setWaterGoal(int goal) {
    state = state.copyWith(waterGoal: goal);
    _saveWater();
  }

  void setExercise(int minutes) {
    state = state.copyWith(exerciseMinutes: state.exerciseMinutes + minutes);
    final uid = _userId;
    if (uid == null) return;
    _tracking.saveExercise(uid, ExerciseLog(
      userId: uid,
      date: DateTime.now(),
      type: 'general',
      durationMinutes: state.exerciseMinutes,
    ));
  }

  void setSleep(int hours, int quality) {
    state = state.copyWith(sleepHours: hours, sleepQuality: quality);
    final uid = _userId;
    if (uid == null) return;
    _tracking.saveSleep(uid, SleepLog(
      userId: uid,
      date: DateTime.now(),
      hours: hours,
      quality: quality,
    ));
  }

  void addSymptom(SymptomLog symptom) {
    state = state.copyWith(
      todaySymptoms: [...state.todaySymptoms, symptom],
    );
    final uid = _userId;
    if (uid == null) return;
    _tracking.saveSymptoms(uid, state.todaySymptoms, DateTime.now());
  }

  void removeSymptom(int index) {
    final updated = [...state.todaySymptoms];
    updated.removeAt(index);
    state = state.copyWith(todaySymptoms: updated);
    final uid = _userId;
    if (uid == null) return;
    _tracking.saveSymptoms(uid, state.todaySymptoms, DateTime.now());
  }

  void resetDaily() {
    state = const TrackerState();
  }

  void addMoodLog(MoodLog log) {
    state = state.copyWith(
      moodHistory: [log, ...state.moodHistory],
    );
  }
}

final trackerProvider = StateNotifierProvider<TrackerNotifier, TrackerState>((ref) {
  return TrackerNotifier(ref.read(trackingServiceProvider));
});
