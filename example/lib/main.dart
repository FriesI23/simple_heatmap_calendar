import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:simple_heatmap_calendar/simple_heatmap_calendar.dart';

import 'l10n/localizations.dart';

import 'page_localization.dart';
import 'page_basic_heatmap.dart';
import 'page_custom.dart';
import 'page_tappable.dart';
import 'page_with_textscale.dart';

final Map<DateTime, num> textSimple = {
  DateTime(2023, 1, 30): 10,
  DateTime(2023, 1, 23): 15,
  DateTime(2023, 1, 16): 10,
  DateTime(2023, 1, 9): 10,
  DateTime(2023, 1, 3): 10,
  DateTime(2023, 1, 4): 10,
  DateTime(2023, 1, 12): 10,
  DateTime(2023, 1, 19): 10,
  DateTime(2023, 1, 26): 10,
  DateTime(2023, 2, 3): 10,
  DateTime(2023, 2, 4): 10,
  DateTime(2023, 1, 29): 10,
  DateTime(2023, 1, 22): 10,
  DateTime(2023, 1, 15): 15,
  DateTime(2023, 1, 8): 10,
  DateTime(2023, 2, 13): 10,
  DateTime(2023, 2, 20): 10,
  DateTime(2023, 2, 27): 10,
  DateTime(2023, 2, 21): 10,
  DateTime(2023, 2, 22): 10,
  DateTime(2023, 2, 23): 10,
  DateTime(2023, 2, 24): 10,
  DateTime(2023, 2, 25): 10,
  DateTime(2023, 2, 26): 10,
  DateTime(2023, 2, 19): 10,
  DateTime(2023, 3, 5): 10,
  DateTime(2023, 3, 19): 10,
  DateTime(2023, 3, 18): 10,
  DateTime(2023, 3, 17): 10,
  DateTime(2023, 3, 16): 10,
  DateTime(2023, 3, 15): 10,
  DateTime(2023, 3, 14): 10,
  DateTime(2023, 3, 13): 10,
  DateTime(2023, 3, 20): 10,
  DateTime(2023, 3, 27): 10,
  DateTime(2023, 4, 3): 10,
  DateTime(2023, 4, 17): 10,
  DateTime(2023, 4, 10): 10,
  DateTime(2023, 4, 5): 15,
  DateTime(2023, 4, 6): 15,
  DateTime(2023, 4, 4): 10,
  DateTime(2023, 4, 7): 10,
  DateTime(2023, 4, 8): 10,
  DateTime(2023, 4, 9): 10,
  DateTime(2023, 4, 30): 10,
  DateTime(2023, 4, 29): 10,
  DateTime(2023, 4, 28): 10,
  DateTime(2023, 4, 27): 10,
  DateTime(2023, 4, 26): 10,
  DateTime(2023, 4, 25): 10,
  DateTime(2023, 4, 24): 10,
  DateTime(2023, 5, 8): 10,
  DateTime(2023, 5, 9): 10,
  DateTime(2023, 5, 10): 10,
  DateTime(2023, 5, 11): 10,
  DateTime(2023, 5, 12): 10,
  DateTime(2023, 5, 13): 10,
  DateTime(2023, 5, 14): 10,
  DateTime(2023, 5, 15): 10,
  DateTime(2023, 5, 22): 10,
  DateTime(2023, 5, 29): 10,
  DateTime(2023, 6, 5): 10,
  DateTime(2023, 6, 6): 10,
  DateTime(2023, 6, 7): 10,
  DateTime(2023, 6, 8): 10,
  DateTime(2023, 6, 1): 10,
  DateTime(2023, 5, 25): 10,
  DateTime(2023, 5, 18): 10,
  DateTime(2023, 6, 19): 20,
  DateTime(2023, 6, 20): 20,
  DateTime(2023, 6, 21): 20,
  DateTime(2023, 6, 22): 20,
  DateTime(2023, 6, 23): 20,
  DateTime(2023, 6, 24): 20,
  DateTime(2023, 6, 25): 20,
  DateTime(2023, 7, 2): 25,
  DateTime(2023, 7, 9): 20,
  DateTime(2023, 7, 16): 30,
  DateTime(2023, 7, 30): 10,
  DateTime(2023, 7, 29): 10,
  DateTime(2023, 7, 28): 10,
  DateTime(2023, 7, 27): 10,
  DateTime(2023, 7, 26): 10,
  DateTime(2023, 7, 25): 10,
  DateTime(2023, 7, 24): 10,
  DateTime(2023, 7, 31): 10,
  DateTime(2023, 8, 7): 10,
  DateTime(2023, 8, 14): 10,
  DateTime(2023, 8, 3): 15,
  DateTime(2023, 8, 10): 15,
  DateTime(2023, 8, 17): 10,
  DateTime(2023, 8, 6): 15,
  DateTime(2023, 8, 13): 10,
  DateTime(2023, 8, 20): 15,
  DateTime(2023, 8, 31): 999,
  DateTime(2023, 9, 7): 999,
  DateTime(2023, 9, 14): 999,
  DateTime(2023, 9, 25): 30,
  DateTime(2023, 9, 26): 30,
  DateTime(2023, 9, 27): 30,
  DateTime(2023, 9, 28): 30,
  DateTime(2023, 9, 29): 30,
  DateTime(2023, 9, 30): 30,
  DateTime(2023, 10, 1): 30,
  DateTime(2023, 10, 5): 30,
  DateTime(2023, 10, 12): 30,
  DateTime(2023, 10, 19): 30,
  DateTime(2023, 10, 25): 30,
  DateTime(2023, 10, 24): 30,
  DateTime(2023, 10, 23): 30,
  DateTime(2023, 10, 26): 30,
  DateTime(2023, 10, 27): 30,
  DateTime(2023, 10, 28): 30,
  DateTime(2023, 10, 29): 30,
  DateTime(2023, 11, 6): 40,
  DateTime(2023, 11, 13): 40,
  DateTime(2023, 11, 20): 40,
  DateTime(2023, 11, 27): 40,
  DateTime(2023, 11, 28): 40,
  DateTime(2023, 11, 7): 40,
  DateTime(2023, 11, 8): 40,
  DateTime(2023, 11, 9): 40,
  DateTime(2023, 11, 10): 40,
  DateTime(2023, 11, 11): 40,
  DateTime(2023, 11, 12): 40,
  DateTime(2023, 11, 19): 40,
  DateTime(2023, 11, 26): 40,
  DateTime(2023, 12, 3): 40,
  DateTime(2023, 12, 10): 40,
  DateTime(2023, 12, 9): 40,
};

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

bool _useM3Theme = false;

final GlobalKey appKey = GlobalKey<_MyApp>();

void main() async {
  runApp(MyApp(key: appKey));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyApp();

  static void setLocale(BuildContext context, Locale newLocale) async {
    _MyApp? state = context.findAncestorStateOfType<_MyApp>();
    state?.changeLanguage(newLocale);
  }
}

class _MyApp extends State<MyApp> {
  Locale? _locale;

  changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: _useM3Theme,
      ),
      scrollBehavior: CustomScrollBehavior(),
      localizationsDelegates: const [
        L10n.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('zh'),
      ],
      locale: _locale,
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
  Widget _buildSimpleHeatmapCalendar(BuildContext context) {
    var theme = Theme.of(context);
    return HeatmapCalendar<num>(
      startDate: DateTime(2023, 1, 1),
      endedDate: DateTime(2023, 12, 31),
      firstDay: DateTime.monday,
      cellSize: const Size.square(16.0),
      colorTipCellSize: const Size.square(12.0),
      colorMap: {
        10: theme.primaryColor.withOpacity(0.2),
        20: theme.primaryColor.withOpacity(0.4),
        30: theme.primaryColor.withOpacity(0.6),
        40: theme.primaryColor.withOpacity(0.8),
        50: theme.primaryColor,
      },
      selectedMap: textSimple,
      style: const HeatmapCalendarStyle.defaults(
        cellValueFontSize: 6.0,
        cellRadius: BorderRadius.all(Radius.circular(4.0)),
        weekLabelValueFontSize: 12.0,
        monthLabelFontSize: 12.0,
      ),
      layoutParameters: const HeatmapLayoutParameters.defaults(
        defaultScrollPosition: CalendarScrollPosition.start,
        // monthLabelPosition: CalendarMonthLabelPosition.top,
        // weekLabelPosition: CalendarWeekLabelPosition.left,
        // colorTipPosition: CalendarColorTipPosition.bottom,
      ),
      switchParameters: const HeatmapSwitchParameters.defaults(
        autoScaled: true,
      ),
      cellBuilder: (context, childBuilder, columnIndex, rowIndex, date) =>
          Tooltip(
        message: date.toIso8601String(),
        waitDuration: const Duration(seconds: 1),
        child: childBuilder(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Simple Heatmap Calendar"),
        actions: [
          IconButton(
            onPressed: () {
              appKey.currentState?.setState(() {
                _useM3Theme = !_useM3Theme;
              });
            },
            icon: const Icon(Icons.palette),
          ),
        ],
      ),
      body: ListView(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: _buildSimpleHeatmapCalendar(context),
            ),
          ),
          ListTile(
            title: const Text("Basic Heatmap"),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const BasicHeatmapPage(),
            )),
          ),
          ListTile(
            title: const Text("Large Font Size"),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const FontScalePage(),
            )),
          ),
          ListTile(
            title: const Text("Tappable & Use Provider"),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const TappableHeatmapPage(),
            )),
          ),
          ListTile(
            title: const Text("L10n"),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const L10nPage(),
            )),
          ),
          ListTile(
            title: const Text("Custom"),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const CustomHeatmapPage(),
            )),
          ),
        ],
      ),
    );
  }
}
