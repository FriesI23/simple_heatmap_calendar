import 'package:example/app.dart';
import 'package:example/demos/custom_page.dart';
import 'package:example/demos/interaction_page.dart';
import 'package:example/demos/localization_page.dart';
import 'package:example/demos/text_scale_page.dart';
import 'package:example/gallery_page.dart';
import 'package:example/simple_example.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:simple_heatmap_calendar/simple_heatmap_calendar.dart';

Future<void> openDemo(WidgetTester tester, String id) async {
  final tile = find.byKey(ValueKey('demo-$id'));
  await tester.ensureVisible(tile);
  await tester.pumpAndSettle();
  await tester.tap(tile);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('gallery uses Material 3 in both light and dark appearances', (
    tester,
  ) async {
    await tester.pumpWidget(const HeatmapExampleApp());
    await tester.pumpAndSettle();
    expect(find.text('A year at a glance'), findsOneWidget);
    BuildContext context() => tester.element(find.byType(GalleryPage));
    expect(Theme.of(context()).useMaterial3, isTrue);
    final original = Theme.of(context()).brightness;
    await tester.tap(find.byKey(const ValueKey('theme-toggle')));
    await tester.pumpAndSettle();
    expect(Theme.of(context()).brightness, isNot(original));
    expect(Theme.of(context()).useMaterial3, isTrue);
    expect(tester.takeException(), isNull);
  });

  for (final id in [
    'basic',
    'text-scale',
    'interaction',
    'localization',
    'custom',
  ]) {
    testWidgets('opens and returns from the $id demo', (tester) async {
      await tester.pumpWidget(const HeatmapExampleApp());
      await tester.pumpAndSettle();
      await openDemo(tester, id);
      expect(find.byType(HeatmapCalendar<num>), findsWidgets);
      expect(find.byType(BackButton), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('A year at a glance'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('locale selection updates Material and calendar localizations', (
    tester,
  ) async {
    await tester.pumpWidget(const HeatmapExampleApp());
    await tester.pumpAndSettle();
    await openDemo(tester, 'localization');
    expect(find.text('Less'), findsOneWidget);
    Finder months(HeatmapCalendar<num> calendar, String text) =>
        find.descendant(of: find.byWidget(calendar), matching: find.text(text));
    final calendars = tester
        .widgetList<HeatmapCalendar<num>>(find.byType(HeatmapCalendar<num>))
        .toList();
    expect(months(calendars.first, 'Jan 2023'), findsOneWidget);
    expect(months(calendars.last, '2023年1月'), findsOneWidget);
    await tester.tap(find.text('中文'));
    await tester.pumpAndSettle();
    BuildContext context() => tester.element(find.byType(L10nPage));
    expect(Localizations.localeOf(context()), const Locale('zh'));
    expect(MaterialLocalizations.of(context()).backButtonTooltip, '返回');
    expect(find.text('更少'), findsOneWidget);
    expect(find.text('更多'), findsOneWidget);
    expect(find.text('Jan 2023'), findsNothing);
    expect(find.text('2023年1月'), findsNWidgets(2));
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    expect(MaterialLocalizations.of(context()).backButtonTooltip, 'Back');
    expect(find.text('Less'), findsOneWidget);
    expect(find.text('Jan 2023'), findsOneWidget);
    expect(find.text('2023年1月'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('text scale slider resizes heatmap cells', (tester) async {
    await tester.pumpWidget(const HeatmapExampleApp());
    await tester.pumpAndSettle();
    await openDemo(tester, 'text-scale');
    expect(find.byType(FontScalePage), findsOneWidget);
    HeatmapCalendar<num> calendar() =>
        tester.widget<HeatmapCalendar<num>>(find.byType(HeatmapCalendar<num>));
    expect(calendar().cellSize.width, 24);
    final slider = find.byType(Slider);
    await tester.tapAt(
      tester.getRect(slider).centerRight - const Offset(16, 0),
    );
    await tester.pumpAndSettle();
    expect(calendar().cellSize.width, greaterThan(24));
    expect(tester.takeException(), isNull);
  });

  testWidgets('a day can be incremented, edited, and reset', (tester) async {
    await tester.pumpWidget(const HeatmapExampleApp());
    await tester.pumpAndSettle();
    await openDemo(tester, 'interaction');
    expect(find.byType(TappableHeatmapPage), findsOneWidget);
    final cell = find.byKey(const ValueKey('interactive-cell-2023-01-02'));
    await tester.tap(cell);
    await tester.pumpAndSettle();
    HeatmapCalendar<num> calendar() =>
        tester.widget<HeatmapCalendar<num>>(find.byType(HeatmapCalendar<num>));
    expect(calendar().selectedMap![DateTime(2023, 1, 2)], 5);
    await tester.tap(cell);
    await tester.pumpAndSettle();
    expect(calendar().selectedMap![DateTime(2023, 1, 2)], 10);
    await tester.longPress(cell);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('cell-value-25')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('apply-cell-value')));
    await tester.pumpAndSettle();
    expect(calendar().selectedMap![DateTime(2023, 1, 2)], 25);
    final reset = find.byKey(const ValueKey('reset-activity'));
    await tester.ensureVisible(reset);
    await tester.pumpAndSettle();
    await tester.tap(reset);
    await tester.pumpAndSettle();
    expect(calendar().selectedMap, isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('disabled editing leaves cell values unchanged', (tester) async {
    await tester.pumpWidget(const HeatmapExampleApp());
    await tester.pumpAndSettle();
    await openDemo(tester, 'interaction');
    final toggle = find.widgetWithText(SwitchListTile, 'Enable editing');
    await tester.ensureVisible(toggle);
    await tester.pumpAndSettle();
    await tester.tap(toggle);
    await tester.pumpAndSettle();
    final cell = find.byKey(const ValueKey('interactive-cell-2023-01-02'));
    await tester.ensureVisible(cell);
    await tester.pumpAndSettle();
    await tester.tap(cell);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<HeatmapCalendar<num>>(find.byType(HeatmapCalendar<num>))
          .selectedMap,
      isEmpty,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('playground controls update geometry and custom builders', (
    tester,
  ) async {
    await tester.pumpWidget(const HeatmapExampleApp());
    await tester.pumpAndSettle();
    await openDemo(tester, 'custom');
    expect(find.byType(CustomHeatmapPage), findsOneWidget);
    HeatmapCalendar<num> calendar() => tester.widget<HeatmapCalendar<num>>(
      find.byKey(const ValueKey('playground-calendar')),
    );
    final sizeControl = find.byKey(const ValueKey('cell-size-control'));
    await tester.ensureVisible(sizeControl);
    await tester.pumpAndSettle();
    final slider = find.descendant(
      of: sizeControl,
      matching: find.byType(Slider),
    );
    await tester.tapAt(
      tester.getRect(slider).centerRight - const Offset(12, 0),
    );
    await tester.pumpAndSettle();
    expect(calendar().cellSize.width, greaterThan(24));
    final customLabels = find.byKey(const ValueKey('custom-labels-toggle'));
    await tester.ensureVisible(customLabels);
    await tester.pumpAndSettle();
    await tester.tap(customLabels);
    await tester.pumpAndSettle();
    expect(calendar().weekLabelValueBuilder, isNotNull);
    expect(calendar().monthLabelItemBuilder, isNotNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('gallery and playground fit a narrow phone', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const HeatmapExampleApp());
    await tester.pumpAndSettle();
    await openDemo(tester, 'custom');
    expect(tester.takeException(), isNull);
    final control = find.byKey(const ValueKey('custom-labels-toggle'));
    await tester.ensureVisible(control);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('minimal entry point uses Material 3', (tester) async {
    await tester.pumpWidget(const SimpleHeatmapApp());
    await tester.pumpAndSettle();
    expect(find.byType(HeatmapCalendar<num>), findsOneWidget);
    expect(
      Theme.of(tester.element(find.byType(Scaffold))).useMaterial3,
      isTrue,
    );
    expect(tester.takeException(), isNull);
  });
}
