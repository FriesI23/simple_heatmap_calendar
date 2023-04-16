import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_heatmap_calendar/simple_heatmap_calendar.dart';

class _CustomProvider {
  DateTime startDate = DateTime(2021, 1, 1);
  DateTime endedData = DateTime(2022, 4, 12);
  int firstDay = DateTime.sunday;
  double cellSize = 32.0;
  double cellSpaceBetween = 1.0;
  double weekLabelSpaceBetweenHeatmap = 5.0;
  bool topColorTip = false;
  double colorTipCellSize = 24.0;
  bool useColorTipCellSize = false;
  double colorTipCellBetweem = 1.0;
  bool useColorTipCellBetweem = false;
  double colorTipSpaceBetweenHeatmap = 5.0;
  double cellRadius = 1.0;
  bool showText = true;
  bool expandWeekLabel = true;
  bool expandMonthLabel = false;
  double monthLabelFontSize = 0.0;
  int monthLabelTextSizeMultiple = 3;
  CalendarAutoChippedBasis? autoClip;
  CalendarWeekLabelPosition? weekLabelPosition =
      CalendarWeekLabelPosition.right;
  CalendarMonthLabelPosition? monthLabelPosition =
      CalendarMonthLabelPosition.top;

  Size? get expandWeekLabelSize =>
      expandWeekLabel ? Size(cellSize * 3, cellSize) : null;
}

class CustomHeatmapPage extends StatefulWidget {
  const CustomHeatmapPage({super.key});

  @override
  State<StatefulWidget> createState() => _CustomHeatmapPage();
}

class _CustomHeatmapPage extends State<CustomHeatmapPage> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _customWeekLabelValueBuilder(
      BuildContext context, DateTime protoDate, String defaultFormat) {
    return FittedBox(
      fit: BoxFit.fill,
      child: Text(DateFormat('cccc', Localizations.localeOf(context).toString())
          .format(protoDate)),
    );
  }

  Widget _customMonthLabelValueBuilder(
      BuildContext context, DateTime data, String defaultFormat) {
    return Text(DateFormat(DateFormat.YEAR_MONTH).format(data));
  }

  Widget _buildHeatmap(BuildContext context) {
    var data = context.read<_CustomProvider>();
    return HeatmapCalendar<num>(
      controller: _controller,
      startDate: data.startDate,
      endedDate: data.endedData,
      firstDay: data.firstDay,
      cellSize: Size.square(data.cellSize),
      cellSpaceBetween: data.cellSpaceBetween,
      weekLabelSpaceBetweenHeatmap: data.weekLabelSpaceBetweenHeatmap,
      colorTipCellSize:
          data.useColorTipCellSize ? Size.square(data.colorTipCellSize) : null,
      colorTipCellBetweem: data.useColorTipCellBetweem
          ? data.colorTipCellBetweem
          : data.cellSpaceBetween,
      colorTipSpaceBetweenHeatmap: data.colorTipSpaceBetweenHeatmap,
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
        monthLabelPosition: data.monthLabelPosition,
        weekLabelPosition: data.weekLabelPosition,
        colorTipPosition: data.topColorTip
            ? CalendarColorTipPosition.top
            : CalendarColorTipPosition.bottom,
      ),
      style: HeatmapCalendarStyle.defaults(
        colorTipPosOffset: 30,
        weekLabelValueAlignment:
            data.expandWeekLabel ? Alignment.centerLeft : null,
        cellRadius: BorderRadius.all(Radius.circular(data.cellRadius)),
        monthLabelFontSize:
            data.monthLabelFontSize > 0 ? data.monthLabelFontSize : null,
        monthLabelTextSizeMultiple: data.monthLabelTextSizeMultiple,
      ),
      switchParameters: HeatmapSwitchParameters.defaults(
        showCellText: data.cellSize > 24 ? data.showText : false,
        autoClipped: data.autoClip,
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
      cellBuilder: (context, childBuilder, columnIndex, rowIndex, date) {
        return Tooltip(
          message: DateFormat('yyyy-MM-dd').format(date),
          waitDuration: const Duration(seconds: 1),
          child: childBuilder(context),
        );
      },
      weekLabalCellSize: data.expandWeekLabelSize,
      weekLabelValueBuilder:
          data.expandWeekLabel ? _customWeekLabelValueBuilder : null,
      monthLabelItemBuilder:
          data.expandMonthLabel ? _customMonthLabelValueBuilder : null,
    );
  }

  Widget _buildOptions(BuildContext context) {
    var data = context.read<_CustomProvider>();
    return ListView(
      children: [
        const SizedBox(height: 20),
        // scroll
        Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceAround,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                _controller.animateTo(_controller.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOutQuart);
              },
              icon: const Icon(Icons.arrow_left),
              label: const Text("to ended"),
            ),
            ChoiceChip(
              selected: data.autoClip == CalendarAutoChippedBasis.left,
              onSelected: (value) => setState(() {
                switch (data.autoClip) {
                  case CalendarAutoChippedBasis.left:
                    data.autoClip = null;
                    break;
                  case CalendarAutoChippedBasis.right:
                  default:
                    data.autoClip = CalendarAutoChippedBasis.left;
                    break;
                }
              }),
              label: const Text("auto clip from left size"),
            ),
            OutlinedButton(
              onPressed: () => setState(() {
                data.showText = !data.showText;
              }),
              child: const Text("show Text"),
            ),
            ChoiceChip(
              selected: data.autoClip == CalendarAutoChippedBasis.right,
              onSelected: (value) => setState(() {
                switch (data.autoClip) {
                  case CalendarAutoChippedBasis.right:
                    data.autoClip = null;
                    break;
                  case CalendarAutoChippedBasis.left:
                  default:
                    data.autoClip = CalendarAutoChippedBasis.right;
                    break;
                }
              }),
              label: const Text("auto clip from right size"),
            ),
            ElevatedButton.icon(
              onPressed: () {
                _controller.animateTo(_controller.position.minScrollExtent,
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOutQuart);
              },
              icon: const Icon(Icons.arrow_right),
              label: const Text("to start"),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // options2
        Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceAround,
          children: [
            OutlinedButton(
              onPressed: () {
                switch (data.weekLabelPosition) {
                  case CalendarWeekLabelPosition.left:
                    setState(() {
                      data.weekLabelPosition = null;
                    });
                    break;
                  case CalendarWeekLabelPosition.right:
                    setState(() {
                      data.weekLabelPosition = CalendarWeekLabelPosition.left;
                    });
                    break;
                  default:
                    setState(() {
                      data.weekLabelPosition = CalendarWeekLabelPosition.right;
                    });
                    break;
                }
              },
              child: const Text("chagne weekLabel pos"),
            ),
            OutlinedButton(
              onPressed: () {
                switch (data.monthLabelPosition) {
                  case CalendarMonthLabelPosition.top:
                    setState(() {
                      data.monthLabelPosition = null;
                    });
                    break;
                  case CalendarMonthLabelPosition.bottom:
                    setState(() {
                      data.monthLabelPosition = CalendarMonthLabelPosition.top;
                    });
                    break;
                  default:
                    setState(() {
                      data.monthLabelPosition =
                          CalendarMonthLabelPosition.bottom;
                    });
                    break;
                }
              },
              child: const Text("chagne monthLabel pos"),
            ),
          ],
        ),
        // StartDate
        ListTile(
          title: const Text("startDate"),
          subtitle: Text(data.startDate.toString()),
          leading: const Icon(Icons.calendar_today),
          onTap: () async {
            var result = await showDatePicker(
              context: context,
              initialDate: data.startDate,
              firstDate: DateTime(2000, 1, 1),
              lastDate: data.endedData,
            );
            if (!mounted || result == null || result.isAfter(data.endedData)) {
              return;
            }
            setState(() {
              data.startDate = result;
            });
          },
        ),
        // EndedDate
        ListTile(
          title: const Text("endedDate"),
          subtitle: Text(data.endedData.toString()),
          leading: const Icon(Icons.calendar_month),
          onTap: () async {
            var result = await showDatePicker(
              context: context,
              initialDate: data.endedData,
              firstDate: data.startDate,
              lastDate: DateTime(2050, 1, 1),
            );
            if (!mounted || result == null || result.isBefore(data.startDate)) {
              return;
            }
            setState(() {
              data.endedData = result;
            });
          },
        ),
        // FirstDay
        ListTile(
          title: const Text("FirstDay"),
          subtitle: Text(data.firstDay.toString()),
          leading: const Icon(Icons.calendar_view_day),
          onTap: () async {
            var result = await showDialog<int>(
              context: context,
              builder: (context) => SimpleDialog(
                title: const Text('select'),
                children: [
                  SimpleDialogOption(
                    child: const Text('Sunday'),
                    onPressed: () => Navigator.of(context).pop(DateTime.sunday),
                  ),
                  SimpleDialogOption(
                    child: const Text('Monday'),
                    onPressed: () => Navigator.of(context).pop(DateTime.monday),
                  ),
                  SimpleDialogOption(
                    child: const Text('Teusday'),
                    onPressed: () =>
                        Navigator.of(context).pop(DateTime.tuesday),
                  ),
                  SimpleDialogOption(
                    child: const Text('Wednesday'),
                    onPressed: () =>
                        Navigator.of(context).pop(DateTime.wednesday),
                  ),
                  SimpleDialogOption(
                    child: const Text('Tursday'),
                    onPressed: () =>
                        Navigator.of(context).pop(DateTime.thursday),
                  ),
                  SimpleDialogOption(
                    child: const Text('Friday'),
                    onPressed: () => Navigator.of(context).pop(DateTime.friday),
                  ),
                  SimpleDialogOption(
                    child: const Text('Saturday'),
                    onPressed: () =>
                        Navigator.of(context).pop(DateTime.saturday),
                  )
                ],
              ),
            );
            if (!mounted || result == null || result == data.firstDay) {
              return;
            }
            setState(() {
              data.firstDay = result;
            });
          },
        ),
        // cellSize
        ListTile(
          title: const Text("cellSize"),
          leading: const Icon(Icons.crop_square),
          subtitle: Slider(
            value: data.cellSize,
            min: 12,
            max: 64,
            divisions: 20,
            label: data.cellSize.toStringAsFixed(2),
            onChanged: (value) => setState(() {
              data.cellSize = value;
            }),
          ),
        ),
        // cellSpaceBetween
        ListTile(
          title: const Text("cellSpaceBetween"),
          leading: const Icon(Icons.view_module),
          subtitle: Slider(
            value: data.cellSpaceBetween,
            min: 1.0,
            max: 10.0,
            divisions: 20,
            label: data.cellSpaceBetween.toStringAsFixed(2),
            onChanged: (value) => setState(() {
              data.cellSpaceBetween = value;
            }),
          ),
        ),
        // weekLabelSpaceBetweenHeatmap
        ListTile(
          title: const Text("weekLabelSpaceBetweenHeatmap"),
          leading: const Icon(Icons.crop_square),
          subtitle: Slider(
            value: data.weekLabelSpaceBetweenHeatmap,
            min: 1.0,
            max: 40.0,
            divisions: 10,
            label: data.weekLabelSpaceBetweenHeatmap.toStringAsFixed(2),
            onChanged: (value) => setState(() {
              data.weekLabelSpaceBetweenHeatmap = value;
            }),
          ),
        ),
        // colorTipCellSize
        SwitchListTile(
          title: const Text("colorTipCellSize"),
          secondary: const Icon(Icons.crop),
          subtitle: Slider(
            value: data.colorTipCellSize,
            min: 1.0,
            max: 40.0,
            divisions: 10,
            label: data.colorTipCellSize.toStringAsFixed(2),
            onChanged: (value) => setState(() {
              data.colorTipCellSize = value;
            }),
          ),
          value: data.useColorTipCellSize,
          onChanged: (bool value) => setState(() {
            data.useColorTipCellSize = value;
          }),
        ),
        // colorTipCellBetweem
        SwitchListTile(
          title: const Text("colorTipCellBetweem"),
          secondary: const Icon(Icons.view_module_outlined),
          subtitle: Slider(
            value: data.colorTipCellBetweem,
            min: 1.0,
            max: 40.0,
            divisions: 10,
            label: data.colorTipCellBetweem.toStringAsFixed(2),
            onChanged: (value) => setState(() {
              data.colorTipCellBetweem = value;
            }),
          ),
          value: data.useColorTipCellBetweem,
          onChanged: (bool value) => setState(() {
            data.useColorTipCellBetweem = value;
          }),
        ),
        // topColorTip
        SwitchListTile(
          title: const Text("topColorTip"),
          secondary: const Icon(Icons.architecture),
          subtitle: Text(data.topColorTip.toString()),
          value: data.topColorTip,
          onChanged: (bool value) => setState(() {
            data.topColorTip = value;
          }),
        ),
        // colorTipSpaceBetweenHeatmap
        ListTile(
          title: const Text("colorTipSpaceBetweenHeatmap"),
          leading: const Icon(Icons.crop_square),
          subtitle: Slider(
            value: data.colorTipSpaceBetweenHeatmap,
            min: 0.0,
            max: 40.0,
            divisions: 20,
            label: data.colorTipSpaceBetweenHeatmap.toStringAsFixed(2),
            onChanged: (value) => setState(() {
              data.colorTipSpaceBetweenHeatmap = value;
            }),
          ),
        ),
        // cellRadius
        ListTile(
          title: const Text("cellRadius"),
          leading: const Icon(Icons.rounded_corner),
          subtitle: Slider(
            value: data.cellRadius,
            min: 0.0,
            max: data.cellSize / 2,
            divisions: 20,
            label: data.cellRadius.toStringAsFixed(2),
            onChanged: (value) => setState(() {
              data.cellRadius = value;
            }),
          ),
        ),
        // expandWeekLabel
        SwitchListTile(
          title: const Text("customedWeekLabel - use builder"),
          secondary: const Icon(Icons.aspect_ratio),
          subtitle: Text(data.expandWeekLabelSize.toString()),
          value: data.expandWeekLabel,
          onChanged: (bool value) => setState(() {
            data.expandWeekLabel = value;
          }),
        ),
        // expandMonthLabel
        SwitchListTile(
          title: const Text("customedMonthLabel - use builder"),
          subtitle: Slider(
            value: data.monthLabelFontSize,
            min: 0.0,
            max: 40.0,
            divisions: 40,
            label: data.monthLabelFontSize.toStringAsFixed(2),
            onChanged: (value) => setState(() {
              data.monthLabelFontSize = value;
            }),
          ),
          secondary: const Icon(Icons.aspect_ratio),
          value: data.expandMonthLabel,
          onChanged: (bool value) => setState(() {
            data.expandMonthLabel = value;
          }),
        ),
        // monthLabelTextSizeMultiple
        ListTile(
          title: const Text("monthLabelTextSizeMultiple"),
          subtitle: Slider(
            value: data.monthLabelTextSizeMultiple.toDouble(),
            min: 1.0,
            max: 10.0,
            divisions: 9,
            label: data.monthLabelTextSizeMultiple.toString(),
            onChanged: (value) => setState(() {
              data.monthLabelTextSizeMultiple = min(10, max(1, value.toInt()));
            }),
          ),
          leading: const Icon(Icons.aspect_ratio),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => _CustomProvider(),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: const Text("Custom page"),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  debugPaintSizeEnabled = !debugPaintSizeEnabled;
                });
              },
              icon: const Icon(Icons.view_agenda),
            ),
          ],
        ),
        body: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: _buildHeatmap(context),
              ),
            ),
            const Divider(height: 10),
            Expanded(child: _buildOptions(context)),
          ],
        ),
      ),
    );
  }
}
