import 'package:equatable/equatable.dart';

class MoodLog extends Equatable {
  final String? id;
  final String userId;
  final String mood;
  final DateTime date;
  final String? note;

  const MoodLog({
    this.id,
    required this.userId,
    required this.mood,
    required this.date,
    this.note,
  });

  factory MoodLog.fromMap(Map<String, dynamic> map, String id) {
    return MoodLog(
      id: id,
      userId: map['user_id'] as String? ?? '',
      mood: map['mood'] as String? ?? 'Happy',
      date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
      note: map['note'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'mood': mood,
      'date': date.toIso8601String(),
      'note': note,
    };
  }

  @override
  List<Object?> get props => [id, userId, mood, date, note];
}

class WaterLog extends Equatable {
  final String? id;
  final String userId;
  final DateTime date;
  final int glasses;
  final int goal;

  const WaterLog({
    this.id,
    required this.userId,
    required this.date,
    required this.glasses,
    this.goal = 8,
  });

  double get progress => glasses / goal;

  @override
  List<Object?> get props => [id, userId, date, glasses, goal];
}

class ExerciseLog extends Equatable {
  final String? id;
  final String userId;
  final DateTime date;
  final String type;
  final int durationMinutes;
  final int caloriesBurned;

  const ExerciseLog({
    this.id,
    required this.userId,
    required this.date,
    required this.type,
    required this.durationMinutes,
    this.caloriesBurned = 0,
  });

  @override
  List<Object?> get props => [id, userId, date, type, durationMinutes];
}

class SleepLog extends Equatable {
  final String? id;
  final String userId;
  final DateTime date;
  final int hours;
  final int quality; // 1-5

  const SleepLog({
    this.id,
    required this.userId,
    required this.date,
    required this.hours,
    this.quality = 3,
  });

  @override
  List<Object?> get props => [id, userId, date, hours, quality];
}

class MedicationReminder extends Equatable {
  final String? id;
  final String userId;
  final String name;
  final String dosage;
  final List<String> times;
  final bool isActive;

  const MedicationReminder({
    this.id,
    required this.userId,
    required this.name,
    required this.dosage,
    this.times = const [],
    this.isActive = true,
  });

  @override
  List<Object?> get props => [id, userId, name, dosage, times, isActive];
}

class SymptomLog extends Equatable {
  final String? id;
  final String userId;
  final String symptom;
  final int severity; // 1-10
  final DateTime date;
  final String? note;

  const SymptomLog({
    this.id,
    required this.userId,
    required this.symptom,
    required this.severity,
    required this.date,
    this.note,
  });

  @override
  List<Object?> get props => [id, userId, symptom, severity, date, note];
}

// === CONTRACEPTION TRACKING ===

class ContraceptionLog extends Equatable {
  final String? id;
  final String userId;
  final DateTime date;
  final String method; // condom, pill, injection, iud, implant, none
  final bool wasProtected;
  final bool tookMorningAfter;
  final String? notes;

  const ContraceptionLog({
    this.id,
    required this.userId,
    required this.date,
    required this.method,
    required this.wasProtected,
    this.tookMorningAfter = false,
    this.notes,
  });

  factory ContraceptionLog.fromMap(Map<String, dynamic> map, String id) {
    return ContraceptionLog(
      id: id,
      userId: map['user_id'] as String? ?? '',
      date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
      method: map['method'] as String? ?? 'none',
      wasProtected: map['was_protected'] as bool? ?? false,
      tookMorningAfter: map['took_morning_after'] as bool? ?? false,
      notes: map['notes'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'date': date.toIso8601String(),
      'method': method,
      'was_protected': wasProtected,
      'took_morning_after': tookMorningAfter,
      'notes': notes,
    };
  }

  ContraceptionLog copyWith({
    String? id,
    String? userId,
    DateTime? date,
    String? method,
    bool? wasProtected,
    bool? tookMorningAfter,
    String? notes,
  }) {
    return ContraceptionLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      method: method ?? this.method,
      wasProtected: wasProtected ?? this.wasProtected,
      tookMorningAfter: tookMorningAfter ?? this.tookMorningAfter,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [id, userId, date, method, wasProtected, tookMorningAfter, notes];
}

// === FLOW INTENSITY ===

class FlowLog extends Equatable {
  final String? id;
  final String userId;
  final DateTime date;
  final String intensity; // spotting, light, medium, heavy
  final String? notes;

  const FlowLog({
    this.id,
    required this.userId,
    required this.date,
    required this.intensity,
    this.notes,
  });

  factory FlowLog.fromMap(Map<String, dynamic> map, String id) {
    return FlowLog(
      id: id,
      userId: map['user_id'] as String? ?? '',
      date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
      intensity: map['intensity'] as String? ?? 'medium',
      notes: map['notes'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'date': date.toIso8601String(),
      'intensity': intensity,
      'notes': notes,
    };
  }

  @override
  List<Object?> get props => [id, userId, date, intensity, notes];
}

// === BODY TEMPERATURE ===

class TemperatureLog extends Equatable {
  final String? id;
  final String userId;
  final DateTime date;
  final double temperature;
  final String? notes;

  const TemperatureLog({
    this.id,
    required this.userId,
    required this.date,
    required this.temperature,
    this.notes,
  });

  factory TemperatureLog.fromMap(Map<String, dynamic> map, String id) {
    return TemperatureLog(
      id: id,
      userId: map['user_id'] as String? ?? '',
      date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
      temperature: (map['temperature'] as num?)?.toDouble() ?? 36.5,
      notes: map['notes'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'date': date.toIso8601String(),
      'temperature': temperature,
      'notes': notes,
    };
  }

  @override
  List<Object?> get props => [id, userId, date, temperature, notes];
}

// === WEIGHT ===

class WeightLog extends Equatable {
  final String? id;
  final String userId;
  final DateTime date;
  final double weight; // in kg
  final String? notes;

  const WeightLog({
    this.id,
    required this.userId,
    required this.date,
    required this.weight,
    this.notes,
  });

  factory WeightLog.fromMap(Map<String, dynamic> map, String id) {
    return WeightLog(
      id: id,
      userId: map['user_id'] as String? ?? '',
      date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
      weight: (map['weight'] as num?)?.toDouble() ?? 60.0,
      notes: map['notes'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'date': date.toIso8601String(),
      'weight': weight,
      'notes': notes,
    };
  }

  @override
  List<Object?> get props => [id, userId, date, weight, notes];
}

// === BLOOD PRESSURE ===

class BloodPressureLog extends Equatable {
  final String? id;
  final String userId;
  final DateTime date;
  final int systolic;
  final int diastolic;
  final String? notes;

  const BloodPressureLog({
    this.id,
    required this.userId,
    required this.date,
    required this.systolic,
    required this.diastolic,
    this.notes,
  });

  factory BloodPressureLog.fromMap(Map<String, dynamic> map, String id) {
    return BloodPressureLog(
      id: id,
      userId: map['user_id'] as String? ?? '',
      date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
      systolic: map['systolic'] as int? ?? 120,
      diastolic: map['diastolic'] as int? ?? 80,
      notes: map['notes'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'date': date.toIso8601String(),
      'systolic': systolic,
      'diastolic': diastolic,
      'notes': notes,
    };
  }

  @override
  List<Object?> get props => [id, userId, date, systolic, diastolic, notes];
}

// === DISCHARGE / CERVICAL MUCUS ===

class DischargeLog extends Equatable {
  final String? id;
  final String userId;
  final DateTime date;
  final String type; // creamy, eggWhite, watery, sticky, normal
  final String? color; // clear, white, yellow, green, brown
  final String? notes;

  const DischargeLog({
    this.id,
    required this.userId,
    required this.date,
    required this.type,
    this.color,
    this.notes,
  });

  factory DischargeLog.fromMap(Map<String, dynamic> map, String id) {
    return DischargeLog(
      id: id,
      userId: map['user_id'] as String? ?? '',
      date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
      type: map['type'] as String? ?? 'normal',
      color: map['color'] as String?,
      notes: map['notes'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'date': date.toIso8601String(),
      'type': type,
      'color': color,
      'notes': notes,
    };
  }

  DischargeLog copyWith({
    String? id,
    String? userId,
    DateTime? date,
    String? type,
    String? color,
    String? notes,
  }) {
    return DischargeLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      type: type ?? this.type,
      color: color ?? this.color,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [id, userId, date, type, color, notes];
}

// === MYCOSIS / THRUSH ===

class MycosisLog extends Equatable {
  final String? id;
  final String userId;
  final DateTime date;
  final bool hasMycosis;
  final List<String> symptoms; // itching, burning, redness, swelling, pain
  final String? notes;

  const MycosisLog({
    this.id,
    required this.userId,
    required this.date,
    required this.hasMycosis,
    this.symptoms = const [],
    this.notes,
  });

  factory MycosisLog.fromMap(Map<String, dynamic> map, String id) {
    return MycosisLog(
      id: id,
      userId: map['user_id'] as String? ?? '',
      date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
      hasMycosis: map['has_mycosis'] as bool? ?? false,
      symptoms: (map['symptoms'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      notes: map['notes'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'date': date.toIso8601String(),
      'has_mycosis': hasMycosis,
      'symptoms': symptoms,
      'notes': notes,
    };
  }

  MycosisLog copyWith({
    String? id,
    String? userId,
    DateTime? date,
    bool? hasMycosis,
    List<String>? symptoms,
    String? notes,
  }) {
    return MycosisLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      hasMycosis: hasMycosis ?? this.hasMycosis,
      symptoms: symptoms ?? this.symptoms,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [id, userId, date, hasMycosis, symptoms, notes];
}

// === MEDICAL PROFILE ===

class MedicalProfile extends Equatable {
  final String userId;
  final String? bloodType;
  final List<String> allergies;
  final List<String> conditions;
  final List<String> medications;
  final String? emergencyContact;
  final String? emergencyPhone;
  final DateTime? lastCheckup;
  final String? notes;

  const MedicalProfile({
    required this.userId,
    this.bloodType,
    this.allergies = const [],
    this.conditions = const [],
    this.medications = const [],
    this.emergencyContact,
    this.emergencyPhone,
    this.lastCheckup,
    this.notes,
  });

  MedicalProfile copyWith({
    String? bloodType,
    List<String>? allergies,
    List<String>? conditions,
    List<String>? medications,
    String? emergencyContact,
    String? emergencyPhone,
    DateTime? lastCheckup,
    String? notes,
  }) {
    return MedicalProfile(
      userId: userId,
      bloodType: bloodType ?? this.bloodType,
      allergies: allergies ?? this.allergies,
      conditions: conditions ?? this.conditions,
      medications: medications ?? this.medications,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      lastCheckup: lastCheckup ?? this.lastCheckup,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [userId, bloodType, allergies, conditions, medications, emergencyContact, emergencyPhone, lastCheckup, notes];
}
