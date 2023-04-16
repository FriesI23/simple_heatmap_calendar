# Simple Heatmap Calendar

<img src="https://user-images.githubusercontent.com/20661034/224279041-833335b9-70c5-41b9-826b-0214ac525b6b.png" alt= "title" width="600" height="82">

Powerful and easy-to-use heatmap flutter chart package.

## Features

- support intl.
- various configuration choices.
- has better performance when dealing with a large time span on the calendar.

More details check example by run code `example/main.dart`

<img src="https://user-images.githubusercontent.com/20661034/224278286-08dde6be-2e6d-4f9e-a732-07add1842c6c.gif" alt= “” width="200" height="466">
<img src="https://user-images.githubusercontent.com/20661034/224278425-5ea1b21f-290c-44d1-8e92-e919ef1fc82e.gif" alt= “” width="200" height="466">
<img src="https://user-images.githubusercontent.com/20661034/224278429-7cf7c8cb-2f55-4cae-b71a-cdbc1a4342be.gif" alt= “” width="200" height="466">

<img src="https://user-images.githubusercontent.com/20661034/224278619-21b04340-2d74-48cc-a0c5-06c67f35cf47.gif" alt= “” width="200" height="466">
<img src="https://user-images.githubusercontent.com/20661034/224278631-2855d819-f51e-451a-aaf1-b0e2d18507db.gif" alt= “” width="200" height="466">
<img src="https://user-images.githubusercontent.com/20661034/224278416-37524f10-08b9-4c51-aa19-5e52f0d69e38.gif" alt= “” width="200" height="466">



```shell
cd exmaple
flutter pub get
flutter run --debug # --profile or --release
```
## Getting started

### Add dependency with `flutter pub add` command

```shell
flutter pub add simple_heatmap_calendar
```

### **Or** Add below line to `pubspec.yaml `

```yaml
dependencies:
  ...
  simple_heatmap_calendar: any  # or special version

```

Then run `flutter pub get`

## Usage

```Dart
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

```


## License

```text
MIT License

Copyright (c) 2023 Fries_I23

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