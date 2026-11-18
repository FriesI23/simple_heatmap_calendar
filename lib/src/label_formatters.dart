import 'package:flutter/widgets.dart';

/// Formats a weekday label using the calendar's effective [Locale].
///
/// The date represents a weekday, not a date from the displayed range. Its UTC
/// mode follows the calendar. Use [DateTime.weekday] to identify the weekday.
typedef WeekLabelFormatter = String Function(DateTime date, Locale locale);

/// Formats a month label using the calendar's effective [Locale].
///
/// [showYear] is true for January when showing the year is enabled.
typedef MonthLabelFormatter = String Function(
  DateTime date,
  Locale locale, {
  required bool showYear,
});

/// Formats weekdays as English initials, independently of [locale].
///
/// Supply a custom [WeekLabelFormatter] for localized labels.
String defaultWeekLabelFormatter(DateTime date, Locale locale) {
  const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  return labels[date.weekday - 1];
}

/// Formats abbreviated English months, independently of [locale].
///
/// Appends the year when [showYear] is true. Supply a custom
/// [MonthLabelFormatter] for localized labels.
String defaultMonthLabelFormatter(
  DateTime date,
  Locale locale, {
  required bool showYear,
}) {
  const labels = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final month = labels[date.month - 1];
  return showYear ? '$month ${date.year}' : month;
}
