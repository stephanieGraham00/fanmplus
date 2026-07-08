import 'package:equatable/equatable.dart';

class CycleLog extends Equatable {
  final String? id;
  final String userId;
  final DateTime date;
  final String? flow;
  final List<String> symptoms;
  final String? notes;
  final DateTime? createdAt;

  const CycleLog({
    this.id,
    required this.userId,
    required this.date,
    this.flow,
    this.symptoms = const [],
    this.notes,
    this.createdAt,
  });

  factory CycleLog.fromMap(Map<String, dynamic> map, String id) {
    return CycleLog(
      id: id,
      userId: map['user_id'] as String? ?? '',
      date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
      flow: map['flow'] as String?,
      symptoms: (map['symptoms'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      notes: map['notes'] as String?,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'date': date.toIso8601String(),
      'flow': flow,
      'symptoms': symptoms,
      'notes': notes,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  CycleLog copyWith({
    String? id,
    String? userId,
    DateTime? date,
    String? flow,
    List<String>? symptoms,
    String? notes,
    DateTime? createdAt,
  }) {
    return CycleLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      flow: flow ?? this.flow,
      symptoms: symptoms ?? this.symptoms,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, userId, date, flow, symptoms, notes];
}

class CyclePrediction extends Equatable {
  final int cycleDay;
  final DateTime nextPeriod;
  final DateTime nextOvulation;
  final String fertileWindow;
  final String cyclePhase;
  final double pregnancyChance;
  final int daysUntilNextPeriod;

  const CyclePrediction({
    required this.cycleDay,
    required this.nextPeriod,
    required this.nextOvulation,
    required this.fertileWindow,
    required this.cyclePhase,
    required this.pregnancyChance,
    required this.daysUntilNextPeriod,
  });

  @override
  List<Object?> get props => [
    cycleDay, nextPeriod, nextOvulation, fertileWindow,
    cyclePhase, pregnancyChance, daysUntilNextPeriod,
  ];
}
