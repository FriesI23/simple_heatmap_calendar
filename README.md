# Simple Heatmap Calendar

![Package][pubdev-package]
![Likes][pubdev-likes]
![Points][pubdev-points]

![banner][banner]

Powerful and easy-to-use heatmap flutter chart package.

## Features

- customizable localized labels without a direct `intl` dependency.
- various configuration choices.
- has better performance when dealing with a large time span on the calendar.

See the [runnable example](example/README.md) to explore the available options.

## Example gallery

Material 3, light/dark appearance, and live configuration:

![Heatmap gallery and live playground](https://raw.githubusercontent.com/FriesI23/simple_heatmap_calendar/master/screenshots/playground.webp)

Tap to add activity, or long press to edit a day:

![Interactive heatmap and value editor](https://raw.githubusercontent.com/FriesI23/simple_heatmap_calendar/master/screenshots/interaction.webp)

## Requirements

Requires **Flutter 3.47.0 / Dart 3.13 or newer**.
Material components use `material_ui`; host UI and themes must use the same
standalone package. See Flutter's [migration guide](https://docs.flutter.dev/release/breaking-changes/material-ui-and-cupertino-ui).

## Getting started

### Add dependency with `flutter pub add` command

```shell
flutter pub add simple_heatmap_calendar
```

### **Or** Add below line to `pubspec.yaml`

```yaml
dependencies:
  ...
  simple_heatmap_calendar: any  # or special version

```

Then run `flutter pub get`

## Development

Development and CI use Flutter 3.47.9, pinned in `.fvmrc`.

```sh
fvm install
make check
```

Use `make help` for other commands. See the [example guide](example/README.md)
for run and build commands.

## Usage

```dart
import 'package:material_ui/material_ui.dart';
import 'package:simple_heatmap_calendar/simple_heatmap_calendar.dart';

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
              10: theme.primaryColor.withValues(alpha: 0.2),
              20: theme.primaryColor.withValues(alpha: 0.4),
              30: theme.primaryColor.withValues(alpha: 0.6),
              40: theme.primaryColor.withValues(alpha: 0.8),
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

```

## Localized labels

Labels default to English. Formatters receive the calendar's `locale` or follow
the app locale. For localization with an app-owned `intl` dependency:

```dart
import 'package:intl/intl.dart'; // Add intl to the app's dependencies.

HeatmapCalendar<num>(
  startDate: DateTime(2023, 1, 1),
  endedDate: DateTime(2023, 12, 31),
  weekLabelFormatter: (date, locale) =>
      DateFormat('ccccc', locale.toString()).format(date),
  monthLabelFormatter: (date, locale, {required showYear}) =>
      DateFormat(showYear ? 'yMMM' : 'MMM', locale.toString()).format(date),
  layoutParameters: const HeatmapLayoutParameters.defaults(
    monthLabelPosition: CalendarMonthLabelPosition.top,
    weekLabelPosition: CalendarWeekLabelPosition.left,
  ),
)
```

Initialize locale data through app delegates or `initializeDateFormatting`.
Other formatting libraries or app translations also work. `material_ui` still
depends on `intl`; this package adds no direct version constraint.

### Migration

- `weekLabelValueBuilder` and `monthLabelItemBuilder` now receive
  `(context, date, defaultText)`: formatted text replaces the date pattern.
- `MonthLabelItem.format` → `label` (text); `MonthLabelRow.getFormat` and
  `WeekLabelColumn.format` → `formatter` (callbacks shown above).
- Both row/column widgets accept `locale`. `MonthLabelRow` now defaults to
  English month abbreviations and shows the year in January unless
  `showYearOnMonthLabel` is false.
- Remove `defaultWeekLabelDateFormatter` and `WeekLabelItem.dateFormatter`;
  the week builder receives `value` as its default text.

## Donate

[!["Buy Me A Coffee"][buymeacoffee-badge]](https://www.buymeacoffee.com/d49cb87qgww)
[![Alipay][alipay-badge]][alipay-addr]
[![WechatPay][wechat-badge]][wechat-addr]

[![ETH][eth-badge]][eth-addr]
[![BTC][btc-badge]][btc-addr]

<!-- friesi23-projects:start -->

## More projects

| Project | Description |
| --- | --- |
| ![Flutter Package](https://img.shields.io/badge/-02569B?style=flat-square&logo=flutter&logoColor=white) [Named HTML Color](https://github.com/FriesI23/named_html_color) | HTML named colors for Flutter. |
| ![Flutter Package](https://img.shields.io/badge/-02569B?style=flat-square&logo=flutter&logoColor=white) [Adaptive Actions](https://github.com/FriesI23/adaptive_actions) | Adaptive Flutter action bars and overflow menus for Material and Cupertino. |
| ![Flutter Package](https://img.shields.io/badge/-02569B?style=flat-square&logo=flutter&logoColor=white) [Flutter Adaptive Sidebar](https://github.com/FriesI23/flutter_adaptive_sidebar) | Material and Cupertino sidebars for Flutter with a shared controller. |
| ![Flutter Plugin](https://img.shields.io/badge/-02569B?style=flat-square&logo=flutter&logoColor=white) [Native Natural Sort](https://github.com/FriesI23/native_natural_sort) | Locale-aware natural sorting for Flutter using native platform engines. |
| ![Flutter Plugin](https://img.shields.io/badge/-02569B?style=flat-square&logo=flutter&logoColor=white) [iOS Window Control Layout](https://github.com/FriesI23/ios_window_control_layout) | Keep Flutter layouts clear of iPadOS window controls. |
| ![Dart Package](https://img.shields.io/badge/-0175C2?style=flat-square&logo=dart&logoColor=white) [Simple WebDAV Client](https://github.com/FriesI23/simple_webdav_client) | Dart WebDAV client for file operations, properties, and resource locks. |
| ![Dart Package](https://img.shields.io/badge/-0175C2?style=flat-square&logo=dart&logoColor=white) [Dart Transmission RPC](https://github.com/FriesI23/dart_transmission_rpc) | Dart client for the Transmission RPC API. |
| ![Dart Package](https://img.shields.io/badge/-0175C2?style=flat-square&logo=dart&logoColor=white) [Win2IANA TimeZone Converter](https://github.com/FriesI23/win2iana_tz_converter) | Dart utilities for converting Windows and IANA time zone identifiers. |
| ![App](https://img.shields.io/badge/-02569B?style=flat-square&logo=flutter&logoColor=white) [Table Habit](https://github.com/FriesI23/mhabit) | Cross-platform habit tracker with scoring, charts, and WebDAV sync. |

<!-- friesi23-projects:end -->

## License

```text
MIT License

Copyright (c) 2023-2026 Fries_I23

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

```

[pubdev-package]: https://img.shields.io/pub/v/simple_heatmap_calendar.svg
[pubdev-likes]: https://img.shields.io/pub/likes/simple_heatmap_calendar?logo=dart
[pubdev-points]: https://img.shields.io/pub/points/simple_heatmap_calendar?logo=dart
[banner]: https://user-images.githubusercontent.com/20661034/224279041-833335b9-70c5-41b9-826b-0214ac525b6b.png
[buymeacoffee-badge]: https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black
[alipay-badge]: https://img.shields.io/badge/alipay-00A1E9?style=for-the-badge&logo=alipay&logoColor=white
[alipay-addr]: https://raw.githubusercontent.com/FriesI23/mhabit/main/docs/README/images/donate-alipay.jpg
[wechat-badge]: https://img.shields.io/badge/WeChat-07C160?style=for-the-badge&logo=wechat&logoColor=white
[wechat-addr]: https://raw.githubusercontent.com/FriesI23/mhabit/main/docs/README/images/donate-wechatpay.png
[eth-badge]: https://img.shields.io/badge/Ethereum-3C3C3D?style=for-the-badge&logo=Ethereum&logoColor=white
[eth-addr]: https://etherscan.io/address/0x35FC877Ef0234FbeABc51ad7fC64D9c1bE161f8F
[btc-badge]: https://img.shields.io/badge/Bitcoin-000000?style=for-the-badge&logo=bitcoin&logoColor=white
[btc-addr]: https://blockchair.com/bitcoin/address/bc1qz2vjews2fcscmvmcm5ctv47mj6236x9p26zk49
