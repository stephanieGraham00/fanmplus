class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  final String phone;
  final String email;
  final String address;
  final String notes;
  final DateTime createdAt;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    this.phone = '',
    this.email = '',
    this.address = '',
    this.notes = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'specialty': specialty,
    'phone': phone,
    'email': email,
    'address': address,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
  };

  factory DoctorModel.fromJson(Map<String, dynamic> json) => DoctorModel(
    id: json['id'] as String,
    name: json['name'] as String,
    specialty: json['specialty'] as String,
    phone: json['phone'] as String? ?? '',
    email: json['email'] as String? ?? '',
    address: json['address'] as String? ?? '',
    notes: json['notes'] as String? ?? '',
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}
