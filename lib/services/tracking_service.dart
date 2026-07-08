import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cycle_model.dart';
import '../models/cycle_history.dart';
import '../models/tracker_model.dart';

class TrackingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String _userPath(String userId) => 'users/$userId';

  // ==================== CYCLE ====================

  Future<void> saveCycleSettings(String userId, {DateTime? lastPeriod, int? cycleLength, int? periodLength}) async {
    final data = <String, dynamic>{};
    if (lastPeriod != null) data['lastPeriodDate'] = lastPeriod.toIso8601String();
    if (cycleLength != null) data['cycleLength'] = cycleLength;
    if (periodLength != null) data['periodLength'] = periodLength;
    await _db.collection('${_userPath(userId)}/tracking').doc('cycle').set(data, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getCycleSettings(String userId) async {
    final doc = await _db.collection('${_userPath(userId)}/tracking').doc('cycle').get();
    return doc.exists ? doc.data() : null;
  }

  Future<void> saveCycleLog(String userId, CycleLog log) async {
    final dateKey = '${log.date.year}-${log.date.month.toString().padLeft(2, '0')}-${log.date.day.toString().padLeft(2, '0')}';
    await _db.collection('${_userPath(userId)}/cycle_logs').doc(dateKey).set(log.toMap(), SetOptions(merge: true));
  }

  Future<List<CycleLog>> getCycleLogs(String userId, {int limit = 365}) async {
    final snap = await _db.collection('${_userPath(userId)}/cycle_logs').orderBy('date', descending: true).limit(limit).get();
    return snap.docs.map((d) => CycleLog.fromMap(d.data(), d.id)).toList();
  }

  // ==================== MOOD ====================

  Future<void> saveMood(String userId, MoodLog log) async {
    final dateKey = '${log.date.year}-${log.date.month.toString().padLeft(2, '0')}-${log.date.day.toString().padLeft(2, '0')}';
    await _db.collection('${_userPath(userId)}/mood_logs').doc(dateKey).set(log.toMap(), SetOptions(merge: true));
  }

  Future<List<MoodLog>> getMoodLogs(String userId, {int limit = 90}) async {
    final snap = await _db.collection('${_userPath(userId)}/mood_logs').orderBy('date', descending: true).limit(limit).get();
    return snap.docs.map((d) => MoodLog.fromMap(d.data(), d.id)).toList();
  }

  // ==================== WATER ====================

  Future<void> saveWater(String userId, WaterLog log) async {
    final dateKey = '${log.date.year}-${log.date.month.toString().padLeft(2, '0')}-${log.date.day.toString().padLeft(2, '0')}';
    await _db.collection('${_userPath(userId)}/water_logs').doc(dateKey).set({
      'user_id': userId,
      'date': log.date.toIso8601String(),
      'glasses': log.glasses,
      'goal': log.goal,
    }, SetOptions(merge: true));
  }

  Future<WaterLog?> getWaterToday(String userId) async {
    final now = DateTime.now();
    final dateKey = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final doc = await _db.collection('${_userPath(userId)}/water_logs').doc(dateKey).get();
    if (!doc.exists) return null;
    final data = doc.data()!;
    return WaterLog(
      userId: userId,
      date: DateTime.tryParse(data['date'] ?? '') ?? now,
      glasses: data['glasses'] ?? 0,
      goal: data['goal'] ?? 8,
    );
  }

  // ==================== EXERCISE ====================

  Future<void> saveExercise(String userId, ExerciseLog log) async {
    final dateKey = '${log.date.year}-${log.date.month.toString().padLeft(2, '0')}-${log.date.day.toString().padLeft(2, '0')}';
    await _db.collection('${_userPath(userId)}/exercise_logs').doc(dateKey).set({
      'user_id': userId,
      'date': log.date.toIso8601String(),
      'type': log.type,
      'duration_minutes': log.durationMinutes,
      'calories_burned': log.caloriesBurned,
    }, SetOptions(merge: true));
  }

  Future<ExerciseLog?> getExerciseToday(String userId) async {
    final now = DateTime.now();
    final dateKey = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final doc = await _db.collection('${_userPath(userId)}/exercise_logs').doc(dateKey).get();
    if (!doc.exists) return null;
    final data = doc.data()!;
    return ExerciseLog(
      userId: userId,
      date: DateTime.tryParse(data['date'] ?? '') ?? now,
      type: data['type'] ?? 'general',
      durationMinutes: data['duration_minutes'] ?? 0,
      caloriesBurned: data['calories_burned'] ?? 0,
    );
  }

  // ==================== SLEEP ====================

  Future<void> saveSleep(String userId, SleepLog log) async {
    final dateKey = '${log.date.year}-${log.date.month.toString().padLeft(2, '0')}-${log.date.day.toString().padLeft(2, '0')}';
    await _db.collection('${_userPath(userId)}/sleep_logs').doc(dateKey).set({
      'user_id': userId,
      'date': log.date.toIso8601String(),
      'hours': log.hours,
      'quality': log.quality,
    }, SetOptions(merge: true));
  }

  Future<SleepLog?> getSleepToday(String userId) async {
    final now = DateTime.now();
    final dateKey = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final doc = await _db.collection('${_userPath(userId)}/sleep_logs').doc(dateKey).get();
    if (!doc.exists) return null;
    final data = doc.data()!;
    return SleepLog(
      userId: userId,
      date: DateTime.tryParse(data['date'] ?? '') ?? now,
      hours: data['hours'] ?? 0,
      quality: data['quality'] ?? 3,
    );
  }

  // ==================== SYMPTOMS ====================

  Future<void> saveSymptoms(String userId, List<SymptomLog> symptoms, DateTime date) async {
    final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final batch = _db.batch();
    final ref = _db.collection('${_userPath(userId)}/symptom_logs').doc(dateKey);
    batch.set(ref, {
      'user_id': userId,
      'date': date.toIso8601String(),
      'symptoms': symptoms.map((s) => {'symptom': s.symptom, 'severity': s.severity}).toList(),
    }, SetOptions(merge: true));
    await batch.commit();
  }

  Future<List<SymptomLog>> getSymptomsForDate(String userId, DateTime date) async {
    final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final doc = await _db.collection('${_userPath(userId)}/symptom_logs').doc(dateKey).get();
    if (!doc.exists) return [];
    final data = doc.data()!;
    final list = (data['symptoms'] as List<dynamic>?) ?? [];
    return list.map((s) => SymptomLog(
      userId: userId,
      symptom: s['symptom'] ?? '',
      severity: s['severity'] ?? 5,
      date: date,
    )).toList();
  }

  // ==================== CONTRACEPTION ====================

  Future<void> saveContraceptionLog(String userId, ContraceptionLog log) async {
    final dateKey = '${log.date.year}-${log.date.month.toString().padLeft(2, '0')}-${log.date.day.toString().padLeft(2, '0')}';
    await _db.collection('${_userPath(userId)}/contraception_logs').doc(dateKey).set(log.toMap(), SetOptions(merge: true));
  }

  Future<List<ContraceptionLog>> getContraceptionLogs(String userId, {int limit = 365}) async {
    final snap = await _db.collection('${_userPath(userId)}/contraception_logs').orderBy('date', descending: true).limit(limit).get();
    return snap.docs.map((d) => ContraceptionLog.fromMap(d.data(), d.id)).toList();
  }

  // ==================== BODY METRICS ====================

  Future<void> saveTemperature(String userId, TemperatureLog log) async {
    final dateKey = '${log.date.year}-${log.date.month.toString().padLeft(2, '0')}-${log.date.day.toString().padLeft(2, '0')}';
    await _db.collection('${_userPath(userId)}/temperature_logs').doc(dateKey).set(log.toMap(), SetOptions(merge: true));
  }

  Future<List<TemperatureLog>> getTemperatures(String userId, {int limit = 90}) async {
    final snap = await _db.collection('${_userPath(userId)}/temperature_logs').orderBy('date', descending: true).limit(limit).get();
    return snap.docs.map((d) => TemperatureLog.fromMap(d.data(), d.id)).toList();
  }

  Future<void> saveWeight(String userId, WeightLog log) async {
    final dateKey = '${log.date.year}-${log.date.month.toString().padLeft(2, '0')}-${log.date.day.toString().padLeft(2, '0')}';
    await _db.collection('${_userPath(userId)}/weight_logs').doc(dateKey).set(log.toMap(), SetOptions(merge: true));
  }

  Future<List<WeightLog>> getWeights(String userId, {int limit = 90}) async {
    final snap = await _db.collection('${_userPath(userId)}/weight_logs').orderBy('date', descending: true).limit(limit).get();
    return snap.docs.map((d) => WeightLog.fromMap(d.data(), d.id)).toList();
  }

  Future<void> saveBloodPressure(String userId, BloodPressureLog log) async {
    final dateKey = '${log.date.year}-${log.date.month.toString().padLeft(2, '0')}-${log.date.day.toString().padLeft(2, '0')}';
    await _db.collection('${_userPath(userId)}/bp_logs').doc(dateKey).set(log.toMap(), SetOptions(merge: true));
  }

  Future<List<BloodPressureLog>> getBloodPressures(String userId, {int limit = 90}) async {
    final snap = await _db.collection('${_userPath(userId)}/bp_logs').orderBy('date', descending: true).limit(limit).get();
    return snap.docs.map((d) => BloodPressureLog.fromMap(d.data(), d.id)).toList();
  }

  Future<void> saveFlow(String userId, FlowLog log) async {
    final dateKey = '${log.date.year}-${log.date.month.toString().padLeft(2, '0')}-${log.date.day.toString().padLeft(2, '0')}';
    await _db.collection('${_userPath(userId)}/flow_logs').doc(dateKey).set(log.toMap(), SetOptions(merge: true));
  }

  Future<List<FlowLog>> getFlowLogs(String userId, {int limit = 90}) async {
    final snap = await _db.collection('${_userPath(userId)}/flow_logs').orderBy('date', descending: true).limit(limit).get();
    return snap.docs.map((d) => FlowLog.fromMap(d.data(), d.id)).toList();
  }

  // ==================== CYCLE HISTORY ====================

  Future<void> saveCycleHistory(String userId, CycleHistory entry) async {
    final ref = _db.collection('${_userPath(userId)}/cycle_history').doc();
    await ref.set(entry.toMap());
  }

  Future<List<CycleHistory>> getCycleHistory(String userId, {int limit = 12}) async {
    final snap = await _db.collection('${_userPath(userId)}/cycle_history').orderBy('period_start', descending: true).limit(limit).get();
    return snap.docs.map((d) => CycleHistory.fromMap(d.data(), d.id)).toList();
  }

  Future<void> savePeriodStart(String userId, DateTime date) async {
    final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    await _db.collection('${_userPath(userId)}/period_starts').doc(dateKey).set({
      'date': date.toIso8601String(),
      'created_at': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
  }

  Future<List<DateTime>> getPeriodStarts(String userId, {int limit = 24}) async {
    final snap = await _db.collection('${_userPath(userId)}/period_starts').orderBy('date', descending: true).limit(limit).get();
    return snap.docs.map((d) => DateTime.tryParse(d.data()['date'] as String? ?? '') ?? DateTime.now()).toList();
  }

  // ==================== DISCHARGE ====================

  Future<void> saveDischarge(String userId, DischargeLog log) async {
    final dateKey = '${log.date.year}-${log.date.month.toString().padLeft(2, '0')}-${log.date.day.toString().padLeft(2, '0')}';
    await _db.collection('${_userPath(userId)}/discharge_logs').doc(dateKey).set(log.toMap(), SetOptions(merge: true));
  }

  Future<List<DischargeLog>> getDischargeLogs(String userId, {int limit = 90}) async {
    final snap = await _db.collection('${_userPath(userId)}/discharge_logs').orderBy('date', descending: true).limit(limit).get();
    return snap.docs.map((d) => DischargeLog.fromMap(d.data(), d.id)).toList();
  }

  // ==================== MYCOSIS ====================

  Future<void> saveMycosis(String userId, MycosisLog log) async {
    final dateKey = '${log.date.year}-${log.date.month.toString().padLeft(2, '0')}-${log.date.day.toString().padLeft(2, '0')}';
    await _db.collection('${_userPath(userId)}/mycosis_logs').doc(dateKey).set(log.toMap(), SetOptions(merge: true));
  }

  Future<List<MycosisLog>> getMycosisLogs(String userId, {int limit = 90}) async {
    final snap = await _db.collection('${_userPath(userId)}/mycosis_logs').orderBy('date', descending: true).limit(limit).get();
    return snap.docs.map((d) => MycosisLog.fromMap(d.data(), d.id)).toList();
  }

  // ==================== MEDICAL PROFILE ====================

  Future<void> saveMedicalProfile(String userId, MedicalProfile profile) async {
    await _db.collection('${_userPath(userId)}/tracking').doc('medical_profile').set({
      'blood_type': profile.bloodType,
      'allergies': profile.allergies,
      'conditions': profile.conditions,
      'medications': profile.medications,
      'emergency_contact': profile.emergencyContact,
      'emergency_phone': profile.emergencyPhone,
      'last_checkup': profile.lastCheckup?.toIso8601String(),
      'notes': profile.notes,
    }, SetOptions(merge: true));
  }

  Future<MedicalProfile?> getMedicalProfile(String userId) async {
    final doc = await _db.collection('${_userPath(userId)}/tracking').doc('medical_profile').get();
    if (!doc.exists) return null;
    final data = doc.data()!;
    return MedicalProfile(
      userId: userId,
      bloodType: data['blood_type'],
      allergies: List<String>.from(data['allergies'] ?? []),
      conditions: List<String>.from(data['conditions'] ?? []),
      medications: List<String>.from(data['medications'] ?? []),
      emergencyContact: data['emergency_contact'],
      emergencyPhone: data['emergency_phone'],
      lastCheckup: data['last_checkup'] != null ? DateTime.tryParse(data['last_checkup']) : null,
      notes: data['notes'],
    );
  }
}
