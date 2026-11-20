import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';

import 'gallery_page.dart';
import 'l10n/localizations.dart';

class HeatmapExampleApp extends StatefulWidget {
  const HeatmapExampleApp({super.key});

  @override
  State<HeatmapExampleApp> createState() => _HeatmapExampleAppState();
}

class _HeatmapExampleAppState extends State<HeatmapExampleApp> {
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('en');

  ThemeData _theme(Brightness brightness) => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.teal,
      brightness: brightness,
    ),
  );

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Simple Heatmap Calendar',
    debugShowCheckedModeBanner: false,
    theme: _theme(Brightness.light),
    darkTheme: _theme(Brightness.dark),
    themeMode: _themeMode,
    locale: _locale,
    supportedLocales: L10n.supportedLocales,
    localizationsDelegates: const [
      L10n.delegate,
      ...GlobalMaterialLocalizations.delegates,
    ],
    scrollBehavior: const MaterialScrollBehavior().copyWith(
      dragDevices: {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      },
    ),
    home: GalleryPage(
      onLocaleChanged: (locale) => setState(() => _locale = locale),
      onToggleBrightness: () => setState(() {
        final dark =
            _themeMode == ThemeMode.dark ||
            (_themeMode == ThemeMode.system &&
                View.of(context).platformDispatcher.platformBrightness ==
                    Brightness.dark);
        _themeMode = dark ? ThemeMode.light : ThemeMode.dark;
      }),
    ),
  );
}
