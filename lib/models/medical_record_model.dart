class MedicalRecordModel {
  final String id;
  final String fullName;
  final String age;
  final String bloodType;
  final String allergies;
  final String medications;
  final String medicalHistory;
  final String emergencyContact;
  final String emergencyPhone;
  final String notes;
  final DateTime createdAt;

  MedicalRecordModel({
    required this.id,
    this.fullName = '',
    this.age = '',
    this.bloodType = '',
    this.allergies = '',
    this.medications = '',
    this.medicalHistory = '',
    this.emergencyContact = '',
    this.emergencyPhone = '',
    this.notes = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'age': age,
    'bloodType': bloodType,
    'allergies': allergies,
    'medications': medications,
    'medicalHistory': medicalHistory,
    'emergencyContact': emergencyContact,
    'emergencyPhone': emergencyPhone,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
  };

  factory MedicalRecordModel.fromJson(Map<String, dynamic> json) => MedicalRecordModel(
    id: json['id'] as String,
    fullName: json['fullName'] as String? ?? '',
    age: json['age'] as String? ?? '',
    bloodType: json['bloodType'] as String? ?? '',
    allergies: json['allergies'] as String? ?? '',
    medications: json['medications'] as String? ?? '',
    medicalHistory: json['medicalHistory'] as String? ?? '',
    emergencyContact: json['emergencyContact'] as String? ?? '',
    emergencyPhone: json['emergencyPhone'] as String? ?? '',
    notes: json['notes'] as String? ?? '',
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}
