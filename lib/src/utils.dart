import 'dart:math' as math;

extension DateArithmetic on DateTime {
  /// Subtract the given number of days from this date, maintaining the time.
  /// This avoids issues with daylight saving time.
  DateTime subtractDays(int days) {
    if (isUtc) {
      return subtract(Duration(days: days));
    } else {
      return DateTime(year, month, day - days, hour, minute, second,
          millisecond, microsecond);
    }
  }

  /// Add the given number of days to this date, maintaining the time. This
  /// avoids issues with daylight saving time.
  DateTime addDays(int days) {
    if (isUtc) {
      return add(Duration(days: days));
    } else {
      return DateTime(year, month, day + days, hour, minute, second,
          millisecond, microsecond);
    }
  }

  /// Returns the difference in days between this date and the given date,
  /// rounding to the nearest day in order to account for DST.
  int differenceInDays(DateTime other) {
    // Doing this.difference(other).inDays doesn't work because it only counts
    // full days, but when DST starts, the day will only be 23 hours long.
    return (difference(other).inHours / 24).round();
  }
}

class HeatmapCalendarLocationCalclator {
  static final _protoSunday = DateTime(2023, 3, 5);
  static final _protoSundayUTC = DateTime.utc(2023, 3, 5);

  final DateTime startDate;
  final DateTime endedDate;
  final int firstDay;
  final bool withUTC;
  final Map<DateTime, int> _columnCache = {};
  final Map<DateTime, int> _rowCache = {};

  HeatmapCalendarLocationCalclator({
    required this.startDate,
    required this.endedDate,
    required this.firstDay,
    required this.withUTC,
  })  : assert(firstDay > 0 && firstDay <= 7),
        assert(startDate.isUtc == endedDate.isUtc),
        assert(startDate.isUtc == withUTC);

  int get offsetRowWithStartDate => getOffsetRow(startDate);

  int get offsetRowWithEndDate => getOffsetRow(endedDate);

  int get offsetColumnWithEndDate => getOffsetColumn(endedDate);

  int getOffsetRow(DateTime date) {
    if (_rowCache.containsKey(date)) return _rowCache[date]!;
    final offset = (date.weekday + 7 - firstDay) % 7;
    _rowCache[date] = offset;
    return offset;
  }

  int getOffsetColumn(DateTime date, {int? offsetRow}) {
    if (_columnCache.containsKey(date)) return _columnCache[date]!;
    final dateF = date.subtractDays(offsetRow ?? getOffsetRow(date));
    final startDateF = startDate.subtractDays(offsetRowWithStartDate);
    final offsetWeek = dateF.differenceInDays(startDateF) ~/ 7;
    _columnCache[date] = offsetWeek;
    return offsetWeek;
  }

  int getDateWeekdyByOffsetRow(int offsetRow) => (offsetRow - 7 + firstDay) % 7;

  DateTime getDateTimeByOffset(int offsetRow, int offsetColumn) {
    int totalDays;
    if (offsetColumn == 0) {
      totalDays = (offsetRow - offsetRowWithStartDate);
    } else if (offsetColumn > 0) {
      totalDays = math.max(0, offsetColumn.abs() - 1) * 7;
      totalDays += (6 - offsetRowWithStartDate) + offsetRow + 1;
    } else {
      totalDays = -math.max(0, offsetColumn.abs() - 1) * 7;
      totalDays -= (6 - offsetRow + 1) + offsetRowWithStartDate;
    }
    return startDate.addDays(totalDays);
  }

  DateTime getProtoDateByOffsetRow(int offsetRow) {
    final weekday = getDateWeekdyByOffsetRow(offsetRow);
    return (withUTC ? _protoSundayUTC : _protoSunday).addDays(weekday);
  }

  HeatmapCalendarLocationCalclator copyWith({
    DateTime? startDate,
    DateTime? endedDate,
    int? firstDay,
    bool? withUTC,
  }) {
    return HeatmapCalendarLocationCalclator(
      startDate: startDate ?? this.startDate,
      endedDate: endedDate ?? this.endedDate,
      firstDay: firstDay ?? this.firstDay,
      withUTC: withUTC ?? this.withUTC,
    );
  }
}
