import 'dart:math' as math;

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
    var offset = (date.weekday + 7 - firstDay) % 7;
    _rowCache[date] = offset;
    return offset;
  }

  int getOffsetColumn(DateTime date, {int? offsetRow}) {
    if (_columnCache.containsKey(date)) return _columnCache[date]!;
    var dateF = date.subtract(Duration(days: offsetRow ?? getOffsetRow(date)));
    var startDateF = startDate.subtract(Duration(days: offsetRowWithStartDate));
    var offsetWeek = dateF.difference(startDateF).inDays ~/ 7;
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
    return startDate.add(Duration(days: totalDays));
  }

  DateTime getProtoDateByOffsetRow(int offsetRow) {
    var weekday = getDateWeekdyByOffsetRow(offsetRow);
    return (withUTC ? _protoSundayUTC : _protoSunday)
        .add(Duration(days: weekday));
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
