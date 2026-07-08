import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? bio;
  final String? avatar;
  final String role;

  // Sik
  final int cycleLength;
  final int periodLength;
  final DateTime? lastPeriodDate;
  final bool isPremium;
  final DateTime? createdAt;

  // Done medikal
  final int? age;
  final double? weight;
  final double? height;
  final bool? hasChildren;
  final int? childrenCount;
  final bool? hasTestedHiv;
  final bool? isPregnant;
  final DateTime? dueDate;
  final bool? hasHiv;
  final bool? hasExperiencedAbuse;
  final List<String> medicalConditions;
  final List<String> allergies;
  final List<String> medications;
  final String? emergencyContact;
  final String? emergencyPhone;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.bio,
    this.avatar,
    this.role = 'user',
    this.cycleLength = 28,
    this.periodLength = 5,
    this.lastPeriodDate,
    this.isPremium = false,
    this.createdAt,
    this.age,
    this.weight,
    this.height,
    this.hasChildren,
    this.childrenCount,
    this.hasTestedHiv,
    this.isPregnant,
    this.dueDate,
    this.hasHiv,
    this.hasExperiencedAbuse,
    this.medicalConditions = const [],
    this.allergies = const [],
    this.medications = const [],
    this.emergencyContact,
    this.emergencyPhone,
  });

  bool get hasCompletedQuestionnaire =>
      age != null && lastPeriodDate != null;

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      bio: map['bio'] as String?,
      avatar: map['avatar'] as String?,
      role: map['role'] as String? ?? 'user',
      cycleLength: map['cycle_length'] as int? ?? 28,
      periodLength: map['period_length'] as int? ?? 5,
      lastPeriodDate: map['last_period_date'] != null
          ? DateTime.tryParse(map['last_period_date'] as String)
          : null,
      isPremium: map['is_premium'] as bool? ?? false,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'] as String)
          : null,
      age: map['age'] as int?,
      weight: (map['weight'] as num?)?.toDouble(),
      height: (map['height'] as num?)?.toDouble(),
      hasChildren: map['has_children'] as bool?,
      childrenCount: map['children_count'] as int?,
      hasTestedHiv: map['has_tested_hiv'] as bool?,
      isPregnant: map['is_pregnant'] as bool?,
      dueDate: map['due_date'] != null
          ? DateTime.tryParse(map['due_date'] as String)
          : null,
      hasHiv: map['has_hiv'] as bool?,
      hasExperiencedAbuse: map['has_experienced_abuse'] as bool?,
      medicalConditions: (map['medical_conditions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      allergies: (map['allergies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      medications: (map['medications'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      emergencyContact: map['emergency_contact'] as String?,
      emergencyPhone: map['emergency_phone'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'bio': bio,
      'avatar': avatar,
      'role': role,
      'cycle_length': cycleLength,
      'period_length': periodLength,
      'last_period_date': lastPeriodDate?.toIso8601String(),
      'is_premium': isPremium,
      'created_at': createdAt?.toIso8601String(),
      'age': age,
      'weight': weight,
      'height': height,
      'has_children': hasChildren,
      'children_count': childrenCount,
      'has_tested_hiv': hasTestedHiv,
      'is_pregnant': isPregnant,
      'due_date': dueDate?.toIso8601String(),
      'has_hiv': hasHiv,
      'has_experienced_abuse': hasExperiencedAbuse,
      'medical_conditions': medicalConditions,
      'allergies': allergies,
      'medications': medications,
      'emergency_contact': emergencyContact,
      'emergency_phone': emergencyPhone,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? bio,
    String? avatar,
    String? role,
    int? cycleLength,
    int? periodLength,
    DateTime? lastPeriodDate,
    bool? isPremium,
    DateTime? createdAt,
    int? age,
    double? weight,
    double? height,
    bool? hasChildren,
    int? childrenCount,
    bool? hasTestedHiv,
    bool? isPregnant,
    DateTime? dueDate,
    bool? hasHiv,
    bool? hasExperiencedAbuse,
    List<String>? medicalConditions,
    List<String>? allergies,
    List<String>? medications,
    String? emergencyContact,
    String? emergencyPhone,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      cycleLength: cycleLength ?? this.cycleLength,
      periodLength: periodLength ?? this.periodLength,
      lastPeriodDate: lastPeriodDate ?? this.lastPeriodDate,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt ?? this.createdAt,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      hasChildren: hasChildren ?? this.hasChildren,
      childrenCount: childrenCount ?? this.childrenCount,
      hasTestedHiv: hasTestedHiv ?? this.hasTestedHiv,
      isPregnant: isPregnant ?? this.isPregnant,
      dueDate: dueDate ?? this.dueDate,
      hasHiv: hasHiv ?? this.hasHiv,
      hasExperiencedAbuse: hasExperiencedAbuse ?? this.hasExperiencedAbuse,
      medicalConditions: medicalConditions ?? this.medicalConditions,
      allergies: allergies ?? this.allergies,
      medications: medications ?? this.medications,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
    );
  }

  @override
  List<Object?> get props => [
    id, name, email, bio, avatar, role,
    cycleLength, periodLength, lastPeriodDate, isPremium, createdAt,
    age, weight, height, hasChildren, childrenCount,
    hasTestedHiv, isPregnant, dueDate, hasHiv, hasExperiencedAbuse,
    medicalConditions, allergies, medications, emergencyContact, emergencyPhone,
  ];
}
