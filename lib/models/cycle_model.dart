class CycleModel {
  int day;
  DateTime startDate;
  int cycleLength;
  int periodLength;
  List<String> symptoms;
  String notes;
  List<SexLog> sexLogs;
  List<DateTime> periodDates;
  List<int> pastCycleLengths;

  CycleModel({
    this.day = 1,
    DateTime? startDate,
    this.cycleLength = 28,
    this.periodLength = 5,
    this.symptoms = const [],
    this.notes = '',
    this.sexLogs = const [],
    this.periodDates = const [],
    this.pastCycleLengths = const [],
  }) : startDate = startDate ?? DateTime.now();

  /// Ovulation occurs ~14 days before next period (luteal phase is fixed at 14 days)
  int get ovulationDay => (cycleLength - 14).clamp(1, cycleLength);

  /// Fertile window: 5 days before ovulation + ovulation day
  int get fertileStart => (ovulationDay - 5).clamp(1, cycleLength);
  int get fertileEnd => ovulationDay;
  bool get isInFertileWindow => day >= fertileStart && day <= fertileEnd;

  /// Safe days: after fertile window ends until next period (except period days)
  bool get isSafeDay => !isInFertileWindow && !isPeriodDay;

  bool get isPeriodDay => day <= periodLength;

  int get phase {
    if (isPeriodDay) return 0;
    if (day < fertileStart) return 1;
    if (isInFertileWindow) return 2;
    return 3;
  }

  String get phaseName {
    switch (phase) {
      case 0: return 'Menstruasyon';
      case 1: return 'Follikilè';
      case 2: return 'Ovilasyon';
      case 3: return 'Luteal';
      default: return 'Enkoni';
    }
  }

  String get phaseEmoji {
    switch (phase) {
      case 0: return '🩸';
      case 1: return '🌱';
      case 2: return '🥚';
      case 3: return '🌙';
      default: return '❓';
    }
  }

  bool get isFertile => isInFertileWindow;

  /// Predict next period start date
  DateTime get nextPeriodDate => startDate.add(Duration(days: cycleLength));
  int get daysUntilNextPeriod => DateTime.now().isAfter(nextPeriodDate)
      ? 0
      : nextPeriodDate.difference(DateTime.now()).inDays;

  /// Probability of pregnancy if unprotected sex today (0-100)
  int get pregnancyRisk {
    if (isPeriodDay) return 2;
    if (day >= ovulationDay - 2 && day <= ovulationDay) return 30;
    if (isInFertileWindow) return 15;
    if (day > ovulationDay && day <= ovulationDay + 2) return 8;
    return 1;
  }

  String get riskLabel {
    final r = pregnancyRisk;
    if (r >= 20) return 'WO';
    if (r >= 10) return 'Mwayen';
    if (r >= 3) return 'Ba';
    return 'Trè ba';
  }

  /// Predicted ovulation date this cycle
  DateTime get ovulationDate => startDate.add(Duration(days: ovulationDay - 1));

  /// Average cycle from history
  int get averageCycleLength {
    if (pastCycleLengths.isEmpty) return cycleLength;
    final avg = pastCycleLengths.reduce((a, b) => a + b) ~/ pastCycleLengths.length;
    return avg.clamp(21, 45);
  }

  CycleModel copyWith({
    int? day,
    DateTime? startDate,
    int? cycleLength,
    int? periodLength,
    List<String>? symptoms,
    String? notes,
    List<SexLog>? sexLogs,
    List<DateTime>? periodDates,
    List<int>? pastCycleLengths,
  }) {
    return CycleModel(
      day: day ?? this.day,
      startDate: startDate ?? this.startDate,
      cycleLength: cycleLength ?? this.cycleLength,
      periodLength: periodLength ?? this.periodLength,
      symptoms: symptoms ?? this.symptoms,
      notes: notes ?? this.notes,
      sexLogs: sexLogs ?? this.sexLogs,
      periodDates: periodDates ?? this.periodDates,
      pastCycleLengths: pastCycleLengths ?? this.pastCycleLengths,
    );
  }

  Map<String, dynamic> toJson() => {
    'day': day,
    'startDate': startDate.toIso8601String(),
    'cycleLength': cycleLength,
    'periodLength': periodLength,
    'symptoms': symptoms,
    'notes': notes,
    'sexLogs': sexLogs.map((s) => s.toJson()).toList(),
    'periodDates': periodDates.map((d) => d.toIso8601String()).toList(),
    'pastCycleLengths': pastCycleLengths,
  };

  factory CycleModel.fromJson(Map<String, dynamic> json) {
    return CycleModel(
      day: json['day'] as int? ?? 1,
      startDate: DateTime.tryParse(json['startDate'] as String? ?? '') ?? DateTime.now(),
      cycleLength: json['cycleLength'] as int? ?? 28,
      periodLength: json['periodLength'] as int? ?? 5,
      symptoms: List<String>.from(json['symptoms'] as List? ?? []),
      notes: json['notes'] as String? ?? '',
      sexLogs: (json['sexLogs'] as List? ?? []).map((s) => SexLog.fromJson(s)).toList(),
      periodDates: (json['periodDates'] as List? ?? []).map((d) => DateTime.parse(d as String)).toList(),
      pastCycleLengths: List<int>.from(json['pastCycleLengths'] as List? ?? []),
    );
  }
}

class SexLog {
  final DateTime date;
  final bool usedProtection;
  final String notes;

  SexLog({
    required this.date,
    this.usedProtection = true,
    this.notes = '',
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'usedProtection': usedProtection,
    'notes': notes,
  };

  factory SexLog.fromJson(Map<String, dynamic> json) => SexLog(
    date: DateTime.parse(json['date'] as String),
    usedProtection: json['usedProtection'] as bool? ?? true,
    notes: json['notes'] as String? ?? '',
  );
}
