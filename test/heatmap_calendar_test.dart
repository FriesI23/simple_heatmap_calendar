import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:simple_heatmap_calendar/simple_heatmap_calendar.dart';

final _start = DateTime(2023, 1, 1);

HeatmapCalendar<num> _calendar({
  HeatmapCalendarStyle? style,
  HeatmapCallbackModel<num>? callbacks,
  Map<DateTime, num>? selectedMap,
  bool tappable = true,
  ScrollController? controller,
  DateTime? endedDate,
  CalendarMonthLabelPosition? monthLabelPosition,
}) => HeatmapCalendar<num>(
  startDate: _start,
  endedDate: endedDate ?? DateTime(2023, 1, 7),
  colorMap: const {1: Colors.red, 10: Colors.blue},
  selectedMap: selectedMap,
  style: style,
  callbackModel: callbacks,
  controller: controller,
  layoutParameters: HeatmapLayoutParameters.defaults(
    defaultScrollPosition: CalendarScrollPosition.start,
    monthLabelPosition: monthLabelPosition,
  ),
  switchParameters: HeatmapSwitchParameters.defaults(
    tappable: tappable,
    showCellText: true,
  ),
  cellBuilder: (context, childBuilder, column, row, date) =>
      KeyedSubtree(key: ValueKey(date), child: childBuilder(context)),
);

Widget _host(Widget child, {ThemeData? theme}) => MaterialApp(
  theme: theme,
  home: Scaffold(
    body: Center(child: SizedBox(width: 320, height: 260, child: child)),
  ),
);

Finder _cell(DateTime date) => find.descendant(
  of: find.byKey(ValueKey(date)),
  matching: find.byType(HeatmapCell<int>),
);

void main() {
  for (final useMaterial3 in [false, true]) {
    testWidgets('reads the standalone Material $useMaterial3 theme', (
      tester,
    ) async {
      final theme = ThemeData(
        primaryColor: Colors.purple,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: useMaterial3,
      );
      await tester.pumpWidget(_host(_calendar(), theme: theme));
      await tester.pumpAndSettle();
      final cell = tester.widget<HeatmapCell<int>>(_cell(_start));
      expect(cell.valueColor, theme.primaryColor);
      expect(
        cell.color,
        (useMaterial3 ? theme.colorScheme.outlineVariant : Colors.grey)
            .withValues(alpha: 0.16),
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('keeps custom styles and selected value colors', (tester) async {
    const radius = BorderRadius.all(Radius.circular(8));
    await tester.pumpWidget(
      _host(
        _calendar(
          style: const HeatmapCalendarStyle.defaults(
            cellBackgroundColor: Colors.green,
            cellValueColor: Colors.yellow,
            cellRadius: radius,
          ),
          selectedMap: {_start: 10},
        ),
      ),
    );
    await tester.pumpAndSettle();
    final selected = tester.widget<HeatmapCell<int>>(_cell(_start));
    expect(selected.color, Colors.blue);
    expect(selected.radius, radius);
    expect(selected.valueColor, Colors.yellow);
    expect(
      tester.widget<HeatmapCell<int>>(_cell(DateTime(2023, 1, 2))).color,
      Colors.green,
    );
  });

  testWidgets('tap and long press return the date and selected value', (
    tester,
  ) async {
    final taps = <(DateTime, num?)>[];
    final longPresses = <(DateTime, num?)>[];
    await tester.pumpWidget(
      _host(
        _calendar(
          selectedMap: {_start: 10},
          callbacks: HeatmapCallbackModel<num>(
            onCellPressed: (date, value) => taps.add((date, value)),
            onCellLongPressed: (date, value) => longPresses.add((date, value)),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(_cell(_start));
    await tester.longPress(_cell(_start));
    await tester.pumpAndSettle();
    expect(taps, [(_start, 10)]);
    expect(longPresses, [(_start, 10)]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('disabled cells do not call tap or long press callbacks', (
    tester,
  ) async {
    var calls = 0;
    await tester.pumpWidget(
      _host(
        _calendar(
          tappable: false,
          callbacks: HeatmapCallbackModel<num>(
            onCellPressed: (date, value) => calls++,
            onCellLongPressed: (date, value) => calls++,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(_cell(_start));
    await tester.longPress(_cell(_start));
    await tester.pumpAndSettle();
    expect(calls, 0);
  });

  testWidgets('selected value changes animate to the new color', (
    tester,
  ) async {
    await tester.pumpWidget(_host(_calendar(selectedMap: {_start: 1})));
    await tester.pumpAndSettle();
    expect(tester.widget<HeatmapCell<int>>(_cell(_start)).color, Colors.red);
    await tester.pumpWidget(_host(_calendar(selectedMap: {_start: 10})));
    expect(_cell(_start), findsNWidgets(2));
    await tester.pumpAndSettle();
    expect(_cell(_start), findsOneWidget);
    expect(tester.widget<HeatmapCell<int>>(_cell(_start)).color, Colors.blue);
  });

  testWidgets('external controller scrolls cells and month labels together', (
    tester,
  ) async {
    final controller = ScrollController();
    await tester.pumpWidget(
      _host(
        _calendar(
          controller: controller,
          endedDate: DateTime(2023, 12, 31),
          monthLabelPosition: CalendarMonthLabelPosition.top,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(controller.hasClients, isTrue);
    await tester.drag(find.byType(ListView), const Offset(-160, 0));
    await tester.pumpAndSettle();
    expect(controller.offset, greaterThan(0));
    final labels = tester.widget<SingleChildScrollView>(
      find.byType(SingleChildScrollView),
    );
    expect(labels.controller!.offset, controller.offset);
    await tester.pumpWidget(const SizedBox.shrink());
    controller.dispose();
    expect(tester.takeException(), isNull);
  });
}
