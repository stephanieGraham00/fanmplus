import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isBetween(DateTime start, DateTime end) {
    return isAfter(start) && isBefore(end.add(const Duration(days: 1)));
  }

  String format({String pattern = 'MMM dd, yyyy'}) {
    return DateFormat(pattern).format(this);
  }

  String get timeAgo {
    final diff = DateTime.now().difference(this);
    if (diff.inDays > 365) return '${diff.inDays ~/ 365}y';
    if (diff.inDays > 30) return '${diff.inDays ~/ 30}mo';
    if (diff.inDays > 0) return '${diff.inDays}d';
    if (diff.inHours > 0) return '${diff.inHours}h';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m';
    return 'Just now';
  }
}

extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  double get width => mediaQuery.size.width;
  double get height => mediaQuery.size.height;
  bool get isMobile => width < 600;
  bool get isTablet => width >= 600 && width < 1200;
  bool get isDesktop => width >= 1200;
}

extension StringExtension on String {
  String get capitalize => '${this[0].toUpperCase()}${substring(1)}';
  String get toTitleCase => split(' ').map((w) => w.capitalize).join(' ');
}
