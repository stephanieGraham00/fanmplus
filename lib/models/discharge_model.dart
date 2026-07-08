class DischargeLog {
  final String id;
  final DateTime date;
  final String type; // normal, creamy, eggWhite, watery, sticky
  final String? color; // clear, white, yellow, green, brown
  final String notes;

  DischargeLog({
    required this.id,
    required this.date,
    required this.type,
    this.color,
    this.notes = '',
  });

  factory DischargeLog.fromJson(Map<String, dynamic> json) => DischargeLog(
    id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
    date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
    type: json['type'] as String? ?? 'normal',
    color: json['color'] as String?,
    notes: json['notes'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'type': type,
    'color': color,
    'notes': notes,
  };
}

class MycosisLog {
  final String id;
  final DateTime date;
  final bool hasMycosis;
  final List<String> symptoms; // itching, burning, redness, swelling, pain
  final String notes;

  MycosisLog({
    required this.id,
    required this.date,
    required this.hasMycosis,
    this.symptoms = const [],
    this.notes = '',
  });

  factory MycosisLog.fromJson(Map<String, dynamic> json) => MycosisLog(
    id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
    date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
    hasMycosis: json['hasMycosis'] as bool? ?? false,
    symptoms: List<String>.from(json['symptoms'] as List? ?? []),
    notes: json['notes'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'hasMycosis': hasMycosis,
    'symptoms': symptoms,
    'notes': notes,
  };
}
