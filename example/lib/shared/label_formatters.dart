import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

// The app owns its date-formatting dependency and locale data initialization.
String intlWeekLabelFormatter(DateTime date, Locale locale) =>
    DateFormat('ccccc', locale.toString()).format(date);

String intlMonthLabelFormatter(
  DateTime date,
  Locale locale, {
  required bool showYear,
}) => DateFormat(showYear ? 'yMMM' : 'MMM', locale.toString()).format(date);
