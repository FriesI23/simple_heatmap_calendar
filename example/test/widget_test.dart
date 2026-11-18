import 'package:example/main.dart';
import 'package:example/page_localization.dart';
import 'package:example/page_with_textscale.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:simple_heatmap_calendar/simple_heatmap_calendar.dart';

void main() {
  testWidgets('home renders a heatmap and switches Material versions', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    expect(find.text('Simple Heatmap Calendar'), findsOneWidget);
    expect(find.byType(HeatmapCalendar<num>), findsOneWidget);
    BuildContext context() => tester.element(find.byType(HomePage));
    expect(Theme.of(context()).useMaterial3, isFalse);
    await tester.tap(find.byIcon(Icons.palette));
    await tester.pumpAndSettle();
    expect(Theme.of(context()).useMaterial3, isTrue);
    expect(tester.takeException(), isNull);
  });

  for (final title in ['Basic Heatmap', 'Tappable & Use Provider', 'Custom']) {
    testWidgets('opens the $title example', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      await tester.tap(find.text(title));
      await tester.pumpAndSettle();
      expect(find.byType(HeatmapCalendar<num>), findsWidgets);
      expect(find.byType(BackButton), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('locale selection updates Material and heatmap localizations', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('L10n'));
    await tester.pumpAndSettle();
    expect(find.text('Less'), findsOneWidget);
    await tester.tap(find.text('中文'));
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(L10nPage));
    expect(Localizations.localeOf(context), const Locale('zh'));
    expect(MaterialLocalizations.of(context).backButtonTooltip, '返回');
    expect(find.text('更少'), findsOneWidget);
    expect(find.text('更多'), findsOneWidget);
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    expect(MaterialLocalizations.of(context).backButtonTooltip, 'Back');
    expect(find.text('Less'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('font scale example resizes heatmap cells', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Large Font Size'));
    await tester.pumpAndSettle();
    expect(find.byType(FontScalePage), findsOneWidget);
    HeatmapCalendar<num> calendar() =>
        tester.widget<HeatmapCalendar<num>>(find.byType(HeatmapCalendar<num>));
    expect(calendar().cellSize.width, 24);
    await tester.tapAt(
      tester.getTopRight(find.byType(Slider)) - const Offset(24, -12),
    );
    await tester.pumpAndSettle();
    expect(calendar().cellSize.width, greaterThan(24));
    expect(tester.takeException(), isNull);
  });
}
