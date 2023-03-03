import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:simple_heatmap_calendar/simple_heatmap_calendar.dart';

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      scrollBehavior: CustomScrollBehavior(),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Simple Heatmap Calendar")),
      body: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: HeatmapCalendar<num>(
            startDate: DateTime(2020, 1, 1),
            endedDate: DateTime(2025, 12, 31),
            colorMap: {
              10: theme.primaryColor.withOpacity(0.2),
              20: theme.primaryColor.withOpacity(0.4),
              30: theme.primaryColor.withOpacity(0.6),
              40: theme.primaryColor.withOpacity(0.8),
              50: theme.primaryColor,
            },
            selectedMap: {
              DateTime(2025, 12, 31): 10,
              DateTime(2025, 12, 30): 20,
              DateTime(2025, 12, 29): 30,
              DateTime(2025, 12, 28): 40,
              DateTime(2025, 12, 26): 50,
              DateTime(2025, 12, 22): 60,
              DateTime(2025, 12, 12): 999,
              DateTime(2025, 12, 1): 0,
              DateTime(2025, 11, 23): 12,
              DateTime(2025, 12, 16): 34,
              DateTime(2025, 12, 15): 45,
              DateTime(2025, 12, 12): 89,
              DateTime(2020, 1, 16): 34,
              DateTime(2020, 1, 15): 45,
              DateTime(2020, 1, 12): 89,
            },
            cellSize: const Size.square(16.0),
            colorTipCellSize: const Size.square(12.0),
            style: const HeatmapCalendarStyle.defaults(
              cellValueFontSize: 6.0,
              cellRadius: BorderRadius.all(Radius.circular(4.0)),
              weekLabelValueFontSize: 12.0,
              monthLabelFontSize: 12.0,
            ),
            layoutParameters: const HeatmapLayoutParameters.defaults(
              monthLabelPosition: CalendarMonthLabelPosition.top,
              weekLabelPosition: CalendarWeekLabelPosition.right,
              colorTipPosition: CalendarColorTipPosition.bottom,
            ),
          ),
        ),
      ),
    );
  }
}
