import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_heatmap_calendar/simple_heatmap_calendar.dart';
import 'package:tuple/tuple.dart';

class SelectDateColProvider extends ChangeNotifier {
  final Map<DateTime, num> _data = {};

  SelectDateColProvider();

  Map<DateTime, num> get data => _data;

  num getValue(DateTime date) => _data[date] ?? 0;

  void changeValue(DateTime date, num value) {
    var orgValue = _data[date];
    if (orgValue != value) {
      _data[date] = value;
      notifyListeners();
    }
  }

  void onPressedAddValue(DateTime date) {
    if (!_data.containsKey(date)) {
      _data[date] = 5;
    } else {
      _data[date] = _data[date]! + 5;
    }
    notifyListeners();
  }
}

class HeatmapStatusChangeProvider extends ChangeNotifier {
  bool _tappable;
  bool _canScroll;
  bool _showText;

  HeatmapStatusChangeProvider({
    bool tappable = true,
    bool canScroll = true,
    bool showText = false,
  })  : _tappable = tappable,
        _canScroll = canScroll,
        _showText = showText;

  bool get tappable => _tappable;
  set tappable(bool newStatus) {
    if (newStatus != _tappable) {
      _tappable = newStatus;
      notifyListeners();
    }
  }

  bool get canScroll => _canScroll;
  set canScroll(bool newStatus) {
    if (newStatus != _canScroll) {
      _canScroll = newStatus;
      notifyListeners();
    }
  }

  bool get showText => _showText;
  set showText(bool newStatus) {
    if (newStatus != _showText) {
      _showText = newStatus;
      notifyListeners();
    }
  }
}

class TappableHeatmapPage extends StatefulWidget {
  const TappableHeatmapPage({super.key});

  @override
  State<StatefulWidget> createState() => _TappableHeatmapPage();
}

class _TappableHeatmapPage extends State<TappableHeatmapPage> {
  Widget _buildChangeValueDialog(BuildContext context, num? value) {
    Widget buildOptions(num selectValue) {
      return SimpleDialogOption(
        child: Text(selectValue.toString()),
        onPressed: () => Navigator.of(context).pop(selectValue),
      );
    }

    return SimpleDialog(
      title: Text("select value, current: ${value ?? 0}"),
      children: [
        buildOptions(05),
        buildOptions(10),
        buildOptions(15),
        buildOptions(20),
        buildOptions(25),
        buildOptions(30),
        buildOptions(35),
        buildOptions(40),
        buildOptions(45),
        buildOptions(50),
        buildOptions(100),
        buildOptions(999),
      ],
    );
  }

  Widget _buildHeatmap(BuildContext context) {
    var vm = context.read<SelectDateColProvider>();
    var svm = context.read<HeatmapStatusChangeProvider>();
    return HeatmapCalendar<num>(
      startDate: DateTime(2023, 1, 1),
      endedDate: DateTime(2023, 12, 29),
      firstDay: DateTime.monday,
      colorMap: {
        10: Colors.red.shade100,
        20: Colors.red.shade300,
        30: Colors.red.shade500,
        40: Colors.red.shade700,
        50: Colors.red.shade900,
      },
      valueColorMap: const {
        20: Colors.black12,
        30: Colors.white,
      },
      colorTipNum: 4,
      colorTipCellSize: const Size(16.0, 16.0),
      layoutParameters: const HeatmapLayoutParameters.defaults(
        monthLabelPosition: CalendarMonthLabelPosition.bottom,
        weekLabelPosition: CalendarWeekLabelPosition.left,
        colorTipPosition: CalendarColorTipPosition.top,
        defaultScrollPosition: CalendarScrollPosition.start,
      ),
      style: const HeatmapCalendarStyle.defaults(
        colorTipPosOffset: 30,
        cellRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      switchParameters: HeatmapSwitchParameters.defaults(
        tappable: svm.tappable,
        canScroll: svm.canScroll,
        showCellText: svm.showText,
      ),
      selectedMap: vm.data,
      callbackModel: HeatmapCallbackModel(
        onCellPressed: (date, value) {
          if (!mounted) return;
          context.read<SelectDateColProvider>().onPressedAddValue(date);
        },
        onCellLongPressed: (date, value) async {
          var result = await showDialog<num>(
            context: context,
            builder: (context) => _buildChangeValueDialog(context, value),
          );
          if (!mounted || result == null) return;
          context.read<SelectDateColProvider>().changeValue(date, result);
        },
      ),
      cellBuilder: (context, childBuilder, columnIndex, rowIndex, date) {
        return Selector<SelectDateColProvider, num>(
          selector: (context, vm) => vm.getValue(date),
          shouldRebuild: (previous, next) => previous != next,
          builder: (context, value, _) {
            // var str = '{';
            // vm.data.forEach((key, v) {
            //   str += "DateTime(${key.year}, ${key.month}, ${key.day}): $v, ";
            // });
            // str += '}';
            // debugPrint(str);
            return Tooltip(
              message: "${DateFormat('yyyy-MM-dd').format(date)} value: $value",
              waitDuration: const Duration(seconds: 1),
              child: childBuilder(context),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Workaround when font scale changed"),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider<SelectDateColProvider>(
            create: (context) => SelectDateColProvider(),
          ),
          ChangeNotifierProvider<HeatmapStatusChangeProvider>(
            create: (context) => HeatmapStatusChangeProvider(),
          ),
        ],
        builder: (context, child) => ListView(
          children: [
            Card(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: const [
                    Text("short press: +5"),
                    Text("long press: show dialog"),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Selector<HeatmapStatusChangeProvider,
                        Tuple3<bool, bool, bool>>(
                      selector: (context, vm) =>
                          Tuple3(vm.tappable, vm.canScroll, vm.showText),
                      shouldRebuild: (previous, next) => previous != next,
                      builder: (context, value, child) =>
                          _buildHeatmap(context),
                    ),
                  ],
                ),
              ),
            ),
            Consumer<HeatmapStatusChangeProvider>(
              builder: (context, value, child) => SwitchListTile(
                title: const Text("tappable"),
                value: context.read<HeatmapStatusChangeProvider>().tappable,
                onChanged: (value) {
                  if (!mounted) return;
                  context.read<HeatmapStatusChangeProvider>().tappable = value;
                },
                secondary: const Icon(Icons.touch_app_outlined),
              ),
            ),
            Consumer<HeatmapStatusChangeProvider>(
              builder: (context, value, child) => SwitchListTile(
                title: const Text("can scroll"),
                value: context.read<HeatmapStatusChangeProvider>().canScroll,
                onChanged: (value) {
                  if (!mounted) return;
                  context.read<HeatmapStatusChangeProvider>().canScroll = value;
                },
                secondary: const Icon(Icons.layers_outlined),
              ),
            ),
            Consumer<HeatmapStatusChangeProvider>(
              builder: (context, value, child) => SwitchListTile(
                title: const Text("show text"),
                value: context.read<HeatmapStatusChangeProvider>().showText,
                onChanged: (value) {
                  if (!mounted) return;
                  context.read<HeatmapStatusChangeProvider>().showText = value;
                },
                secondary: const Icon(Icons.title_outlined),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
