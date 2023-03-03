import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_heatmap_calendar/simple_heatmap_calendar.dart';

class BasicHeatmapPage extends StatefulWidget {
  const BasicHeatmapPage({super.key});

  @override
  State<StatefulWidget> createState() => _BasicHeatmapPage();
}

class _BasicHeatmapPage extends State<BasicHeatmapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Basic Heatmap Calendar"),
      ),
      body: ListView(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const ListTile(
                      title: Text("Default (2023-1-3 to 2023-04-10)")),
                  HeatmapCalendar<num>(
                    startDate: DateTime(2023, 1, 3),
                    endedDate: DateTime(2023, 4, 10),
                    layoutParameters: const HeatmapLayoutParameters.defaults(
                      defaultScrollPosition: CalendarScrollPosition.start,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const ListTile(title: Text("With labels")),
                  HeatmapCalendar<num>(
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
                    colorTipCellSize: const Size.square(16),
                    layoutParameters: const HeatmapLayoutParameters.defaults(
                      monthLabelPosition: CalendarMonthLabelPosition.top,
                      weekLabelPosition: CalendarWeekLabelPosition.right,
                      colorTipPosition: CalendarColorTipPosition.bottom,
                    ),
                    style: const HeatmapCalendarStyle.defaults(
                      colorTipPosOffset: 50,
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
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const ListTile(title: Text("Scaled")),
                  HeatmapCalendar<num>(
                    startDate: DateTime(2022, 1, 3),
                    endedDate: DateTime(2023, 6, 12),
                    firstDay: DateTime.monday,
                    colorTipCellSize: const Size.square(16),
                    layoutParameters: const HeatmapLayoutParameters.defaults(
                      monthLabelPosition: CalendarMonthLabelPosition.top,
                      weekLabelPosition: CalendarWeekLabelPosition.right,
                    ),
                    style: const HeatmapCalendarStyle.defaults(
                      showYearOnMonthLabel: false,
                    ),
                    switchParameters: const HeatmapSwitchParameters.defaults(
                      showCellText: true,
                      autoScaled: true,
                    ),
                    monthLabelItemBuilder: (context, date, defaultFormat) =>
                        FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(DateFormat(defaultFormat).format(date)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
