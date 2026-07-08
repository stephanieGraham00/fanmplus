import 'dart:math';
import 'package:intl/intl.dart';
import '../models/cycle_history.dart';

class CycleCalculator {
  // Calculate which day of the cycle the user is on (1-indexed)
  static int calculateCycleDay(DateTime lastPeriod, int cycleLength) {
    final today = DateTime.now();
    final daysSince = DateTime(today.year, today.month, today.day)
        .difference(DateTime(lastPeriod.year, lastPeriod.month, lastPeriod.day))
        .inDays;
    if (daysSince < 0) return 1;
    return (daysSince % cycleLength) + 1;
  }

  // Predict exact next period date
  static DateTime predictNextPeriod(DateTime lastPeriod, int cycleLength) {
    final today = DateTime.now();
    final lastPeriodDate = DateTime(lastPeriod.year, lastPeriod.month, lastPeriod.day);
    final daysSinceLast = DateTime(today.year, today.month, today.day)
        .difference(lastPeriodDate)
        .inDays;

    // Calculate how many full cycles have passed
    final cyclesPassed = daysSinceLast ~/ cycleLength;
    final daysIntoCurrentCycle = daysSinceLast % cycleLength;

    // Next period = lastPeriod + (cyclesPassed + 1) * cycleLength
    DateTime nextPeriod = lastPeriodDate.add(Duration(days: (cyclesPassed + 1) * cycleLength));

    // If we're already past the expected date, add one more cycle
    if (nextPeriod.isBefore(today) || nextPeriod.isAtSameMomentAs(today)) {
      nextPeriod = nextPeriod.add(Duration(days: cycleLength));
    }

    return nextPeriod;
  }

  // Predict exact ovulation date (14 days before next period)
  static DateTime predictOvulation(DateTime lastPeriod, int cycleLength) {
    final nextPeriod = predictNextPeriod(lastPeriod, cycleLength);
    return nextPeriod.subtract(const Duration(days: 14));
  }

  // Get fertile window (5 days before ovulation + ovulation day + 1 day after)
  static String getFertileWindow(DateTime lastPeriod, int cycleLength) {
    final ovulation = predictOvulation(lastPeriod, cycleLength);
    final fertileStart = ovulation.subtract(const Duration(days: 5));
    final fertileEnd = ovulation.add(const Duration(days: 1));
    return '${DateFormat('dd MMM').format(fertileStart)} - ${DateFormat('dd MMM').format(fertileEnd)}';
  }

  // Get fertile window dates
  static DateTimeRange getFertileWindowDates(DateTime lastPeriod, int cycleLength) {
    final ovulation = predictOvulation(lastPeriod, cycleLength);
    return DateTimeRange(
      start: ovulation.subtract(const Duration(days: 5)),
      end: ovulation.add(const Duration(days: 1)),
    );
  }

  // Calculate pregnancy chance based on cycle day
  static double getPregnancyChance(DateTime lastPeriod, int cycleLength) {
    final cycleDay = calculateCycleDay(lastPeriod, cycleLength);
    final ovDay = cycleLength - 14;

    // Day of ovulation = highest chance
    if (cycleDay == ovDay) return 0.95;
    // 2 days before ovulation = very high
    if (cycleDay == ovDay - 1 || cycleDay == ovDay - 2) return 0.85;
    // 3-5 days before ovulation = high
    if (cycleDay >= ovDay - 5 && cycleDay <= ovDay - 3) return 0.65;
    // 1 day after ovulation = moderate
    if (cycleDay == ovDay + 1) return 0.50;
    // During period = very low
    if (cycleDay <= 5) return 0.02;
    // Late luteal phase = very low
    if (cycleDay > cycleLength - 3) return 0.02;
    // Other days = low
    return 0.10;
  }

  // Get detailed cycle phase with description
  static CyclePhaseInfo getCyclePhase(DateTime lastPeriod, int cycleLength) {
    final cycleDay = calculateCycleDay(lastPeriod, cycleLength);
    final ovDay = cycleLength - 14;

    if (cycleDay <= 5) {
      return CyclePhaseInfo(
        name: 'Peryòd',
        description: 'Bag san ap soti. Matris la ap debake.',
        color: 'period',
        dayInPhase: cycleDay,
        totalDays: 5,
      );
    } else if (cycleDay >= 6 && cycleDay <= ovDay - 6) {
      return CyclePhaseInfo(
        name: 'Faz Folikilè',
        description: 'Kò ap prepare pou ovilasyon. Yon ovè ap grandi.',
        color: 'fertile',
        dayInPhase: cycleDay - 5,
        totalDays: ovDay - 11,
      );
    } else if (cycleDay >= ovDay - 5 && cycleDay <= ovDay - 1) {
      return CyclePhaseInfo(
        name: 'Fenèt Fetil',
        description: 'Ou kapab gwosès. Chans yo wo!',
        color: 'fertile',
        dayInPhase: cycleDay - (ovDay - 6),
        totalDays: 5,
      );
    } else if (cycleDay == ovDay) {
      return CyclePhaseInfo(
        name: 'Ovilasyon',
        description: 'Yon ovè soti nan ovar yo. Chans pi wo pou gwosès.',
        color: 'ovulation',
        dayInPhase: 1,
        totalDays: 1,
      );
    } else if (cycleDay == ovDay + 1) {
      return CyclePhaseInfo(
        name: 'Apre Ovilasyon',
        description: 'Ovè a ap desann. Chans genyen ankò.',
        color: 'fertile',
        dayInPhase: 1,
        totalDays: 1,
      );
    } else {
      final daysInLuteal = cycleDay - ovDay - 1;
      final totalLuteal = cycleLength - ovDay - 1;
      return CyclePhaseInfo(
        name: 'Faz Luteal',
        description: 'Kò ap tann. Si pa gen fekondasyon, peryòd ap vini.',
        color: 'luteal',
        dayInPhase: daysInLuteal,
        totalDays: totalLuteal,
      );
    }
  }

  // Check if period is late
  static PeriodDelayInfo getPeriodDelayInfo(DateTime lastPeriod, int cycleLength) {
    final nextPeriod = predictNextPeriod(lastPeriod, cycleLength);
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final nextPeriodOnly = DateTime(nextPeriod.year, nextPeriod.month, nextPeriod.day);

    final daysLate = todayOnly.difference(nextPeriodOnly).inDays;

    if (daysLate <= 0) {
      return PeriodDelayInfo(
        isLate: false,
        daysLate: 0,
        message: 'Peryòd ou a an tan. Pwochen: ${DateFormat('dd MMM').format(nextPeriod)}',
        severity: DelaySeverity.none,
      );
    } else if (daysLate == 1) {
      return PeriodDelayInfo(
        isLate: true,
        daysLate: 1,
        message: 'Peryòd ou a 1 jou reta. Pa enkyete, sa rive!',
        severity: DelaySeverity.mild,
      );
    } else if (daysLate <= 3) {
      return PeriodDelayInfo(
        isLate: true,
        daysLate: daysLate,
        message: 'Peryòd ou a $daysLate jou reta. Stress oswa chanjman ka koze sa.',
        severity: DelaySeverity.moderate,
      );
    } else if (daysLate <= 7) {
      return PeriodDelayInfo(
        isLate: true,
        daysLate: daysLate,
        message: 'Peryòd ou a $daysLate jou reta. Si ou gen sispèk gwosès, fè yon tès.',
        severity: DelaySeverity.high,
      );
    } else {
      return PeriodDelayInfo(
        isLate: true,
        daysLate: daysLate,
        message: 'Peryòd ou a $daysLate jou reta. Al wè yon doktè pou tcheke.',
        severity: DelaySeverity.critical,
      );
    }
  }

  // Days until next period (can be negative if late)
  static int daysUntilNextPeriod(DateTime lastPeriod, int cycleLength) {
    final next = predictNextPeriod(lastPeriod, cycleLength);
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final nextOnly = DateTime(next.year, next.month, next.day);
    return nextOnly.difference(todayOnly).inDays;
  }

  /// Compute adaptive cycle length from an array of period start dates.
  /// Uses weighted average of last N cycles (more recent = higher weight).
  /// Returns null if fewer than 2 period starts are provided.
  static int? computeAdaptiveCycleLength(List<DateTime> periodStarts) {
    if (periodStarts.length < 2) return null;

    // Sort ascending (oldest first)
    final sorted = List<DateTime>.from(periodStarts)..sort();

    // Calculate cycle lengths between consecutive starts
    final lengths = <int>[];
    for (int i = 1; i < sorted.length; i++) {
      lengths.add(sorted[i].difference(sorted[i - 1]).inDays.abs());
    }

    if (lengths.isEmpty) return null;

    // Use last 6 cycles max
    final recent = lengths.reversed.take(6).toList();

    // Weighted average: most recent cycles get higher weight
    double totalWeight = 0;
    double weightedSum = 0;
    for (int i = 0; i < recent.length; i++) {
      final weight = (recent.length - i).toDouble(); // latest = highest weight
      weightedSum += recent[i] * weight;
      totalWeight += weight;
    }

    final avg = (weightedSum / totalWeight).round();
    return avg.clamp(21, 45);
  }

  /// Check if a flow log on [date] represents a new period start,
  /// given the set of dates that already have flow logs in recent days.
  /// Returns true if there's no flow in previous 5 days.
  static bool isNewPeriodStart(DateTime date, List<DateTime> recentFlowDates) {
    if (recentFlowDates.isEmpty) return true;
    for (final d in recentFlowDates) {
      final diff = date.difference(d).inDays.abs();
      if (diff <= 5) return false;
    }
    return true;
  }

  /// Detect period start dates from a list of flow log dates.
  /// Groups consecutive flow days and returns the first date of each group.
  static List<DateTime> detectPeriodStarts(List<DateTime> flowDates) {
    if (flowDates.isEmpty) return [];

    final sorted = List<DateTime>.from(flowDates)..sort();
    final starts = <DateTime>[sorted.first];

    for (int i = 1; i < sorted.length; i++) {
      final gap = sorted[i].difference(sorted[i - 1]).inDays;
      if (gap > 5) starts.add(sorted[i]);
    }

    return starts;
  }

  /// Compute cycle history entries from flow log dates and period start dates.
  static List<CycleHistory> buildCycleHistory(List<DateTime> periodStarts, Set<DateTime> allFlowDates) {
    if (periodStarts.length < 2) return [];

    final sorted = List<DateTime>.from(periodStarts)..sort();
    final history = <CycleHistory>[];

    for (int i = 1; i < sorted.length; i++) {
      final start = sorted[i - 1];
      final nextStart = sorted[i];
      final cycleLen = nextStart.difference(start).inDays;

      // Count period days (consecutive flow from start)
      int periodLen = 0;
      var check = start;
      while (allFlowDates.contains(DateTime(check.year, check.month, check.day))) {
        periodLen++;
        check = check.add(const Duration(days: 1));
      }

      history.add(CycleHistory(
        periodStart: start,
        periodEnd: start.add(Duration(days: periodLen - 1)),
        cycleLength: cycleLen,
        periodLength: periodLen.clamp(1, 10),
      ));
    }

    return history;
  }

  /// Get adaptive cycle length as a string (e.g., "29 days · based on 4 cycles")
  static String getAdaptiveCycleInfo(List<DateTime> periodStarts) {
    if (periodStarts.length < 2) return '';
    final avg = computeAdaptiveCycleLength(periodStarts);
    if (avg == null) return '';
    final count = min(periodStarts.length - 1, 6);
    return '$avg days · $count cycles';
  }

  // Get calendar data for a month (period days, ovulation, fertile)
  static Map<DateTime, String> getMonthData(DateTime month, DateTime lastPeriod, int cycleLength) {
    final data = <DateTime, String>{};
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);

    // Find the cycle that starts in or before this month
    final lastPeriodDate = DateTime(lastPeriod.year, lastPeriod.month, lastPeriod.day);
    final daysSinceLast = DateTime(firstDay.year, firstDay.month, firstDay.day)
        .difference(lastPeriodDate)
        .inDays;
    final cyclesBefore = (daysSinceLast / cycleLength).floor();

    // Check 3 cycles (previous, current, next)
    for (int c = cyclesBefore - 1; c <= cyclesBefore + 2; c++) {
      final cycleStart = lastPeriodDate.add(Duration(days: c * cycleLength));
      final ovDay = cycleLength - 14;

      // Period days (day 1-5)
      for (int d = 0; d < 5; d++) {
        final date = cycleStart.add(Duration(days: d));
        if (date.isAfter(firstDay.subtract(const Duration(days: 1))) &&
            date.isBefore(lastDay.add(const Duration(days: 1)))) {
          data[DateTime(date.year, date.month, date.day)] = 'period';
        }
      }

      // Fertile window (ovDay-5 to ovDay+1)
      for (int d = ovDay - 5; d <= ovDay + 1; d++) {
        final date = cycleStart.add(Duration(days: d));
        if (date.isAfter(firstDay.subtract(const Duration(days: 1))) &&
            date.isBefore(lastDay.add(const Duration(days: 1)))) {
          final key = DateTime(date.year, date.month, date.day);
          if (d == ovDay) {
            data[key] = 'ovulation';
          } else {
            data[key] = 'fertile';
          }
        }
      }
    }

    return data;
  }
}

class CyclePhaseInfo {
  final String name;
  final String description;
  final String color;
  final int dayInPhase;
  final int totalDays;

  const CyclePhaseInfo({
    required this.name,
    required this.description,
    required this.color,
    required this.dayInPhase,
    required this.totalDays,
  });
}

class PeriodDelayInfo {
  final bool isLate;
  final int daysLate;
  final String message;
  final DelaySeverity severity;

  const PeriodDelayInfo({
    required this.isLate,
    required this.daysLate,
    required this.message,
    required this.severity,
  });
}

enum DelaySeverity { none, mild, moderate, high, critical }

class DateHelper {
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  static String formatMonthYear(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }

  static List<DateTime> getDaysInMonth(DateTime month) {
    final days = <DateTime>[];
    final first = DateTime(month.year, month.month, 1);
    final last = DateTime(month.year, month.month + 1, 0);
    for (int d = 1; d <= last.day; d++) {
      days.add(DateTime(month.year, month.month, d));
    }
    return days;
  }

  static String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 365) return '${diff.inDays ~/ 365}y';
    if (diff.inDays > 30) return '${diff.inDays ~/ 30}mo';
    if (diff.inDays > 0) return '${diff.inDays}d';
    if (diff.inHours > 0) return '${diff.inHours}h';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m';
    return 'Now';
  }
}

class NotificationHelper {
  static String getMotivationalQuote() {
    final quotes = [
      'You are stronger than you know. ♥',
      'Every woman has the power to change the world.',
      'Your body, your rules.',
      'You are not alone.',
      'Knowledge is power.',
      'You deserve love and respect.',
      'Every day is a new beginning.',
      'Strong, beautiful, unstoppable!',
    ];
    return quotes[Random().nextInt(quotes.length)];
  }
}
