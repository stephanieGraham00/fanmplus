import 'dart:math';
import 'package:intl/intl.dart';

/// Ported & adapted from the Fanm+ AI (Riverpod/Firebase) version.
/// Works with local period-start dates (List<DateTime>).
class CycleCalculator {
  /// Compute adaptive cycle length from period start dates.
  /// Weighted average of last N cycles (more recent = higher weight).
  /// Returns null if fewer than 2 starts.
  static int? computeAdaptiveCycleLength(List<DateTime> periodStarts) {
    if (periodStarts.length < 2) return null;
    final sorted = List<DateTime>.from(periodStarts)..sort();
    final lengths = <int>[];
    for (int i = 1; i < sorted.length; i++) {
      lengths.add(sorted[i].difference(sorted[i - 1]).inDays.abs());
    }
    if (lengths.isEmpty) return null;
    final recent = lengths.reversed.take(6).toList();
    double totalWeight = 0, weightedSum = 0;
    for (int i = 0; i < recent.length; i++) {
      final weight = (recent.length - i).toDouble();
      weightedSum += recent[i] * weight;
      totalWeight += weight;
    }
    final avg = (weightedSum / totalWeight).round();
    return avg.clamp(21, 45);
  }

  /// Detect period-start dates from a list of flow dates.
  /// Groups consecutive flow days (gap <= 5 days = same period).
  static List<DateTime> detectPeriodStarts(List<DateTime> flowDates) {
    if (flowDates.isEmpty) return [];
    final sorted = List<DateTime>.from(flowDates)..sort();
    final starts = <DateTime>[sorted.first];
    for (int i = 1; i < sorted.length; i++) {
      if (sorted[i].difference(sorted[i - 1]).inDays > 5) starts.add(sorted[i]);
    }
    return starts;
  }

  /// Human-readable adaptive info: "29j · 4 sik"
  static String adaptiveInfo(List<DateTime> periodStarts) {
    if (periodStarts.length < 2) return '';
    final avg = computeAdaptiveCycleLength(periodStarts);
    if (avg == null) return '';
    final count = min(periodStarts.length - 1, 6);
    return '$avgj · $count sik';
  }

  static String formatDate(DateTime d) => DateFormat('dd MMM yyyy', 'fr').format(d);
}
