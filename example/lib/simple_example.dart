import 'package:material_ui/material_ui.dart';
import 'package:simple_heatmap_calendar/simple_heatmap_calendar.dart';

void main() => runApp(const SimpleHeatmapApp());

class SimpleHeatmapApp extends StatelessWidget {
  const SimpleHeatmapApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
    home: Scaffold(
      appBar: AppBar(title: const Text('Simple Heatmap Calendar')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: HeatmapCalendar<num>(
          startDate: DateTime(2023, 1, 1),
          endedDate: DateTime(2023, 12, 31),
          selectedMap: {
            DateTime(2023, 1, 2): 1,
            DateTime(2023, 1, 3): 3,
            DateTime(2023, 1, 4): 5,
          },
          colorMap: const {
            1: Color(0xFF99F6E4),
            3: Color(0xFF14B8A6),
            5: Color(0xFF0F766E),
          },
          layoutParameters: const HeatmapLayoutParameters.defaults(
            defaultScrollPosition: CalendarScrollPosition.start,
            monthLabelPosition: CalendarMonthLabelPosition.top,
          ),
          switchParameters: const HeatmapSwitchParameters.defaults(
            autoScaled: true,
          ),
        ),
      ),
    ),
  );
}
