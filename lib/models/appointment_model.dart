class AppointmentModel {
  final String id;
  final String doctorId;
  final String doctorName;
  final String doctorSpecialty;
  final DateTime date;
  final String notes;
  final String status;

  AppointmentModel({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.date,
    this.notes = '',
    this.status = 'konfime',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'doctorId': doctorId,
    'doctorName': doctorName,
    'doctorSpecialty': doctorSpecialty,
    'date': date.toIso8601String(),
    'notes': notes,
    'status': status,
  };

  factory AppointmentModel.fromJson(Map<String, dynamic> json) => AppointmentModel(
    id: json['id'] as String,
    doctorId: json['doctorId'] as String,
    doctorName: json['doctorName'] as String,
    doctorSpecialty: json['doctorSpecialty'] as String,
    date: DateTime.parse(json['date'] as String),
    notes: json['notes'] as String? ?? '',
    status: json['status'] as String? ?? 'konfime',
  );
}
