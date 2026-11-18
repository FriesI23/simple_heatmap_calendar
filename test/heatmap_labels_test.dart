import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:simple_heatmap_calendar/simple_heatmap_calendar.dart';

HeatmapCalendar<num> _calendar({
  Locale? locale,
  bool withUTC = false,
  int firstDay = DateTime.monday,
  bool showYear = true,
  bool showLabels = true,
  WeekLabelFormatter weekFormatter = defaultWeekLabelFormatter,
  MonthLabelFormatter monthFormatter = defaultMonthLabelFormatter,
  WeekLabelValueBuilder? weekBuilder,
  MonthLabelValueBuilder? monthBuilder,
}) => HeatmapCalendar<num>(
  startDate: withUTC ? DateTime.utc(2023, 12, 1) : DateTime(2023, 12, 1),
  endedDate: withUTC ? DateTime.utc(2024, 2, 29) : DateTime(2024, 2, 29),
  locale: locale,
  withUTC: withUTC,
  firstDay: firstDay,
  weekLabelFormatter: weekFormatter,
  monthLabelFormatter: monthFormatter,
  weekLabelValueBuilder: weekBuilder,
  monthLabelItemBuilder: monthBuilder,
  style: HeatmapCalendarStyle.defaults(showYearOnMonthLabel: showYear),
  layoutParameters: HeatmapLayoutParameters.defaults(
    defaultScrollPosition: CalendarScrollPosition.start,
    weekLabelPosition: showLabels ? CalendarWeekLabelPosition.left : null,
    monthLabelPosition: showLabels ? CalendarMonthLabelPosition.top : null,
  ),
);

Widget _host(Widget child, {Locale appLocale = const Locale('en')}) =>
    MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => Localizations.override(
            context: context,
            locale: appLocale,
            child: Center(
              child: SizedBox(width: 760, height: 400, child: child),
            ),
          ),
        ),
      ),
    );

List<String> _labels(Type container) => find
    .descendant(of: find.byType(container), matching: find.byType(Text))
    .evaluate()
    .map((element) => (element.widget as Text).data!)
    .toList();

String _weekFormatter(DateTime date, Locale locale) =>
    'weekday-${locale.toLanguageTag()}-${date.weekday}';

String _monthFormatter(
  DateTime date,
  Locale locale, {
  required bool showYear,
}) => 'month-${locale.toLanguageTag()}-${date.month}-$showYear';

void main() {
  const chinese = Locale.fromSubtags(
    languageCode: 'zh',
    scriptCode: 'Hant',
    countryCode: 'TW',
  );

  testWidgets('English defaults work under a different app locale', (
    tester,
  ) async {
    await tester.pumpWidget(_host(_calendar(), appLocale: chinese));
    await tester.pumpAndSettle();

    expect(_labels(WeekLabelColumn), ['M', 'T', 'W', 'T', 'F', 'S', 'S']);
    expect(_labels(MonthLabelRow), ['Dec', 'Jan 2024', 'Feb']);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'formatters follow app locale changes including script and region',
    (tester) async {
      final calendar = _calendar(
        weekFormatter: _weekFormatter,
        monthFormatter: _monthFormatter,
      );
      await tester.pumpWidget(_host(calendar));
      await tester.pumpAndSettle();
      expect(find.text('weekday-en-1'), findsOneWidget);
      expect(find.text('month-en-1-true'), findsOneWidget);

      await tester.pumpWidget(_host(calendar, appLocale: chinese));
      await tester.pumpAndSettle();
      expect(find.text('weekday-en-1'), findsNothing);
      expect(find.text('weekday-zh-Hant-TW-1'), findsOneWidget);
      expect(find.text('month-zh-Hant-TW-1-true'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'explicit locale overrides and formatter replacements take effect',
    (tester) async {
      await tester.pumpWidget(
        _host(
          _calendar(
            locale: chinese,
            weekFormatter: _weekFormatter,
            monthFormatter: _monthFormatter,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('weekday-zh-Hant-TW-1'), findsOneWidget);
      expect(find.text('month-zh-Hant-TW-1-true'), findsOneWidget);

      await tester.pumpWidget(
        _host(
          _calendar(
            locale: const Locale('en', 'GB'),
            weekFormatter: (date, locale) =>
                'new-${_weekFormatter(date, locale)}',
            monthFormatter: (date, locale, {required showYear}) =>
                'new-${_monthFormatter(date, locale, showYear: showYear)}',
          ),
          appLocale: chinese,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('weekday-zh-Hant-TW-1'), findsNothing);
      expect(find.text('new-weekday-en-GB-1'), findsOneWidget);
      expect(find.text('new-month-en-GB-1-true'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('UTC and first weekday are preserved for custom formatters', (
    tester,
  ) async {
    final dates = <DateTime>[];
    final monthsWithYear = <int>{};
    await tester.pumpWidget(
      _host(
        _calendar(
          withUTC: true,
          firstDay: DateTime.sunday,
          weekFormatter: (date, locale) {
            dates.add(date);
            return _weekFormatter(date, locale);
          },
          monthFormatter: (date, locale, {required showYear}) {
            dates.add(date);
            if (showYear) monthsWithYear.add(date.month);
            return _monthFormatter(date, locale, showYear: showYear);
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(dates, isNotEmpty);
    expect(dates.every((date) => date.isUtc), isTrue);
    expect(_labels(WeekLabelColumn), [
      for (final weekday in [7, 1, 2, 3, 4, 5, 6]) 'weekday-en-$weekday',
    ]);
    expect(monthsWithYear, {DateTime.january});
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'builders receive formatted text and year display can be disabled',
    (tester) async {
      await tester.pumpWidget(
        _host(
          _calendar(
            showYear: false,
            weekFormatter: _weekFormatter,
            monthFormatter: _monthFormatter,
            weekBuilder: (context, date, defaultText) =>
                Text('built:$defaultText'),
            monthBuilder: (context, date, defaultText) =>
                Text('built:$defaultText'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('built:weekday-en-1'), findsOneWidget);
      expect(_labels(MonthLabelRow), [
        'built:month-en-12-false',
        'built:month-en-1-false',
        'built:month-en-2-false',
      ]);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('hidden labels do not invoke formatters', (tester) async {
    await tester.pumpWidget(
      _host(
        _calendar(
          showLabels: false,
          weekFormatter: (date, locale) => throw StateError('hidden weekdays'),
          monthFormatter: (date, locale, {required showYear}) =>
              throw StateError('hidden months'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(WeekLabelColumn), findsNothing);
    expect(find.byType(MonthLabelRow), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
