import 'package:equatable/equatable.dart';

class CycleHistory extends Equatable {
  final String? id;
  final DateTime periodStart;
  final DateTime? periodEnd;
  final int cycleLength;
  final int periodLength;
  final List<String> symptoms;
  final double? avgFlowIntensity;
  final String? notes;

  const CycleHistory({
    this.id,
    required this.periodStart,
    this.periodEnd,
    required this.cycleLength,
    required this.periodLength,
    this.symptoms = const [],
    this.avgFlowIntensity,
    this.notes,
  });

  factory CycleHistory.fromMap(Map<String, dynamic> map, String id) {
    return CycleHistory(
      id: id,
      periodStart: DateTime.tryParse(map['period_start'] as String? ?? '') ?? DateTime.now(),
      periodEnd: map['period_end'] != null ? DateTime.tryParse(map['period_end'] as String) : null,
      cycleLength: map['cycle_length'] as int? ?? 28,
      periodLength: map['period_length'] as int? ?? 5,
      symptoms: (map['symptoms'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      avgFlowIntensity: (map['avg_flow_intensity'] as num?)?.toDouble(),
      notes: map['notes'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'period_start': periodStart.toIso8601String(),
      'period_end': periodEnd?.toIso8601String(),
      'cycle_length': cycleLength,
      'period_length': periodLength,
      'symptoms': symptoms,
      'avg_flow_intensity': avgFlowIntensity,
      'notes': notes,
    };
  }

  @override
  List<Object?> get props => [id, periodStart, periodEnd, cycleLength, periodLength, symptoms, avgFlowIntensity, notes];
}
