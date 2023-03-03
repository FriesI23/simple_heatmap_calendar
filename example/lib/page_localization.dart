import 'package:example/l10n/localizations.dart';
import 'package:flutter/material.dart';
import 'package:simple_heatmap_calendar/simple_heatmap_calendar.dart';

import 'main.dart';

class L10nPage extends StatefulWidget {
  const L10nPage({super.key});

  @override
  State<StatefulWidget> createState() => _L10nPage();
}

class _L10nPage extends State<L10nPage> {
  Widget _buildHeatmap(BuildContext context,
      {Locale? locale, bool showColorTip = true}) {
    var colorTipLeftHelperText = L10n.of(context)?.colorTipLeftHelperText;
    var colorTipRightHelperText = L10n.of(context)?.colorTipRightHelperText;
    return HeatmapCalendar<num>(
      locale: locale,
      startDate: DateTime(2020, 1, 3),
      endedDate: DateTime(2023, 4, 12),
      firstDay: DateTime.monday,
      colorMap: {
        10: Colors.red.shade100,
        20: Colors.red.shade300,
        30: Colors.red.shade500,
        40: Colors.red.shade700,
        50: Colors.red.shade900,
      },
      valueColorMap: const {
        10: Colors.black,
        20: Colors.white,
        39: Colors.yellow,
      },
      colorTipNum: 3,
      layoutParameters: HeatmapLayoutParameters.defaults(
        monthLabelPosition: CalendarMonthLabelPosition.top,
        weekLabelPosition: CalendarWeekLabelPosition.right,
        colorTipPosition: showColorTip ? CalendarColorTipPosition.bottom : null,
      ),
      style: const HeatmapCalendarStyle.defaults(
        colorTipPosOffset: 30,
      ),
      switchParameters: const HeatmapSwitchParameters.defaults(
        showCellText: true,
      ),
      selectedMap: {
        DateTime(2023, 4, 1): 1,
        DateTime(2023, 4, 2): 9,
        DateTime(2023, 4, 3): 12,
        DateTime(2023, 4, 4): 25,
        DateTime(2023, 4, 5): 35,
        DateTime(2023, 4, 6): 42,
        DateTime(2023, 4, 7): 999,
      },
      colorTipLeftHelper:
          colorTipLeftHelperText != null ? Text(colorTipLeftHelperText) : null,
      colorTipRightHelper: colorTipRightHelperText != null
          ? Text(colorTipRightHelperText)
          : null,
      cellBuilder: (context, childBuilder, columnIndex, rowIndex, date) {
        return childBuilder(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("L10n"),
      ),
      body: ListView(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  _buildHeatmap(context),
                ],
              ),
            ),
          ),
          RadioListTile<Locale>(
            title: const Text('English'),
            value: const Locale('en'),
            groupValue: Localizations.localeOf(context),
            onChanged: (value) =>
                value != null ? MyApp.setLocale(context, value) : null,
          ),
          RadioListTile<Locale>(
            title: const Text('中文'),
            value: const Locale('zh'),
            groupValue: Localizations.localeOf(context),
            onChanged: (value) =>
                value != null ? MyApp.setLocale(context, value) : null,
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const Text("specify region"),
                  _buildHeatmap(context,
                      locale: const Locale('zh'), showColorTip: false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
