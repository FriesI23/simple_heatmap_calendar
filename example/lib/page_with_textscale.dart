import 'package:flutter/material.dart';
import 'package:simple_heatmap_calendar/simple_heatmap_calendar.dart';

class FontScalePage extends StatefulWidget {
  const FontScalePage({super.key});

  @override
  State<StatefulWidget> createState() => _FontScalePage();
}

class _FontScalePage extends State<FontScalePage> {
  double _crtfontScale = 1.0;

  Widget _buildHeatmapUseMediaQuery(BuildContext context) {
    final double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return HeatmapCalendar<num>(
      startDate: DateTime(2020, 1, 3),
      endedDate: DateTime(2023, 4, 12),
      firstDay: DateTime.monday,
      // change cell size
      cellSize: Size(defaultCellSize.width * textScaleFactor,
          defaultCellSize.height * textScaleFactor),

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
      layoutParameters: const HeatmapLayoutParameters.defaults(
        monthLabelPosition: CalendarMonthLabelPosition.top,
        weekLabelPosition: CalendarWeekLabelPosition.right,
        colorTipPosition: CalendarColorTipPosition.bottom,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Workaround when font scale changed"),
      ),
      body: ListView(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Slider(
                    value: _crtfontScale,
                    min: 1.0,
                    max: 2.0,
                    divisions: 10,
                    label: _crtfontScale.toString(),
                    onChanged: (value) => setState(() {
                      _crtfontScale = value;
                    }),
                  ),
                  MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(textScaleFactor: _crtfontScale),
                    child: Builder(
                      builder: (context) => _buildHeatmapUseMediaQuery(context),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
