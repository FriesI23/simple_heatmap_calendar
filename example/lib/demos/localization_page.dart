import 'package:material_ui/material_ui.dart';
import 'package:simple_heatmap_calendar/simple_heatmap_calendar.dart';

import '../l10n/localizations.dart';
import '../shared/demo_data.dart';
import '../shared/demo_widgets.dart';

class L10nPage extends StatelessWidget {
  const L10nPage({super.key, required this.onLocaleChanged});

  final ValueChanged<Locale> onLocaleChanged;

  Widget _calendar(
    BuildContext context, {
    Locale? locale,
    bool legend = true,
  }) => HeatmapCalendar<num>(
    locale: locale,
    startDate: DateTime(2023, 1, 1),
    endedDate: DateTime(2023, 4, 30),
    firstDay: DateTime.monday,
    selectedMap: sampleYearData,
    colorMap: heatmapColors(context),
    layoutParameters: HeatmapLayoutParameters.defaults(
      defaultScrollPosition: CalendarScrollPosition.start,
      monthLabelPosition: CalendarMonthLabelPosition.top,
      weekLabelPosition: CalendarWeekLabelPosition.left,
      colorTipPosition: legend ? CalendarColorTipPosition.bottom : null,
    ),
    colorTipLeftHelper: Text(L10n.of(context)!.colorTipLeftHelperText),
    colorTipRightHelper: Text(L10n.of(context)!.colorTipRightHelperText),
  );

  @override
  Widget build(BuildContext context) => DemoScaffold(
    title: 'Localization',
    description: 'Calendar labels follow the app locale. A calendar can also override its locale independently.',
    children: [
      DemoCard(
        title: 'App language',
        child: ChoiceControl<Locale>(
          label: 'Language',
          value: Localizations.localeOf(context),
          options: {const Locale('en'): 'English', const Locale('zh'): '中文'},
          onChanged: onLocaleChanged,
        ),
      ),
      DemoCard(title: 'Follow app language', child: _calendar(context)),
      DemoCard(
        title: 'Always Chinese',
        description: 'Only this calendar uses an explicit locale.',
        child: _calendar(context, locale: const Locale('zh'), legend: false),
      ),
    ],
  );
}
