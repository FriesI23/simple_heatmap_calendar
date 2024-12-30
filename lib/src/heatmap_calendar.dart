import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'const.dart';
import 'utils.dart';
import 'widget/cellitem.dart';
import 'widget/colortip.dart';
import 'widget/monthlabel.dart';
import 'widget/weeklabel.dart';

typedef ValueBuilder = Widget? Function(BuildContext context, int? dateDay);

typedef WeekLabelValueBuilder = Widget? Function(
  BuildContext context,
  DateTime protoDate,
  String defaultFormat,
);

typedef MonthLabelValueBuilder = Widget? Function(
  BuildContext context,
  DateTime date,
  String defaultFormat,
);

typedef CellItemBuilder = Widget? Function(
  BuildContext context,
  Widget Function(BuildContext, {ValueBuilder? valueBuilder}) childBuilder,
  int columnIndex,
  int rowIndex,
  DateTime date,
);

typedef CellPressedCallback<T> = void Function(DateTime date, T? value)?;

class HeatmapCalendarStyle {
  /// change heatmap cell container color
  final Color? cellBackgroundColor;

  /// change heatmap cell radius
  final BorderRadius? cellRadius;

  /// change heatmap cell value color, [HeatmapSwitchParameters.showCellText]
  /// must set true to display heatmap cell value;
  final Color? cellValueColor;

  /// change heatmap cell value padding in cell container
  /// e.g.
  /// +---cell-------+
  /// |    padding   |
  /// |   +-----+    |
  /// |   | val |    |
  /// |   +-----+    |
  /// |              |
  /// +--------------+
  final EdgeInsetsGeometry? cellValuePadding;

  // heatmap cell value font size
  final double? cellValueFontSize;

  // change week label color
  final Color? weekLabelColor;

  /// change week label aligmanet way
  /// e.g. centerLeft: 　| S        |
  ///      centerRight:  |        S |
  final Alignment? weekLabelValueAlignment;

  // heatmap week label value font size
  final double? weekLabelValueFontSize;

  /// change month label color
  final Color? monthLabelColor;

  /// change month label font size
  final double? monthLabelFontSize;

  // Set the width of several cells, default: 3
  final int? monthLabelTextSizeMultiple;

  /// if set false, The month of the New Year will only be displayed as the month
  /// (rather than year and month).
  /// e.g true "Dec ... 2022 Jan ... Feb", false "Dec ... Jan ... Feb"
  final bool showYearOnMonthLabel;

  /// change color tip cell border radius
  final BorderRadius? colorTipCellRadius;

  /// change color tip postion
  /// e.g. offset = 100
  /// | ----------------- | -- 100 -- |
  ///             [widget]
  /// this param ignored when `colorTipAlignBy` set `center`
  final int colorTipPosOffset;

  /// change color tips position alignment wat
  /// center | ---------- [widget] ----------- |
  /// left   | --- offset --- [widget]         |
  /// right  |          [wiget] --- offset --- |
  final CalendarColorTipAlignBy? colorTipAlignBy;

  const HeatmapCalendarStyle({
    this.cellBackgroundColor,
    this.cellRadius,
    this.cellValueColor,
    this.cellValuePadding,
    this.cellValueFontSize,
    this.weekLabelColor,
    this.weekLabelValueAlignment,
    this.weekLabelValueFontSize,
    this.monthLabelColor,
    this.monthLabelFontSize,
    this.monthLabelTextSizeMultiple,
    required this.showYearOnMonthLabel,
    this.colorTipCellRadius,
    required this.colorTipPosOffset,
    this.colorTipAlignBy,
  }) : assert(colorTipPosOffset > 0 && colorTipPosOffset < 100);

  const HeatmapCalendarStyle.defaults({
    this.cellBackgroundColor,
    this.cellRadius,
    this.cellValueColor,
    this.cellValuePadding,
    this.cellValueFontSize,
    this.weekLabelColor,
    this.weekLabelValueAlignment,
    this.weekLabelValueFontSize,
    this.monthLabelColor,
    this.monthLabelFontSize,
    this.monthLabelTextSizeMultiple = 3,
    this.showYearOnMonthLabel = true,
    this.colorTipCellRadius,
    this.colorTipPosOffset = 60,
    this.colorTipAlignBy,
  }) : assert(colorTipPosOffset > 0 && colorTipPosOffset < 100);
}

class HeatmapLayoutParameters {
  /// haetmap init scroll postion
  final CalendarScrollPosition defaultScrollPosition;

  /// Relative position of month label to the heatmap
  final CalendarMonthLabelPosition? monthLabelPosition;

  /// Relative position of week label to the heatmap
  final CalendarWeekLabelPosition? weekLabelPosition;

  /// Relative position of color tips to the heatmap
  final CalendarColorTipPosition? colorTipPosition;

  const HeatmapLayoutParameters({
    required this.defaultScrollPosition,
    this.monthLabelPosition,
    this.weekLabelPosition,
    this.colorTipPosition,
  });

  const HeatmapLayoutParameters.defaults({
    this.defaultScrollPosition = CalendarScrollPosition.ended,
    this.monthLabelPosition,
    this.weekLabelPosition,
    this.colorTipPosition,
  });
}

class HeatmapSwitchParameters {
  /// show call value text in heatmap
  final bool showCellText;

  /// Automatically scaled heatmap calendar with current widget constraint
  /// autoScaled &　autoClipped can only be set one at a time
  final bool autoScaled;

  /// Automatically clip heatmap according to constraints, instead of scrolling.
  /// autoScaled &　autoClipped can only be set one at a time
  final CalendarAutoChippedBasis? autoClipped;

  /// Toggle for scrollable heatmap calendar
  final bool? canScroll;

  /// Toggle for clickable heatmap cells
  final bool tappable;

  const HeatmapSwitchParameters({
    required this.showCellText,
    required this.autoScaled,
    required this.autoClipped,
    required this.canScroll,
    required this.tappable,
  }) : assert(!(autoScaled && autoClipped != null));

  const HeatmapSwitchParameters.defaults({
    this.showCellText = false,
    this.autoScaled = false,
    this.autoClipped,
    this.canScroll,
    this.tappable = true,
  }) : assert(!(autoScaled && autoClipped != null));
}

class HeatmapCallbackModel<T> {
  /// callback when heatmap cell clicked,
  /// `HeatmapSwitchParameters.tappable` must be `true``
  final CellPressedCallback<T>? onCellPressed;

  /// callback when heatmap cell long clicked
  /// `HeatmapSwitchParameters.tappable` must be `true``
  final CellPressedCallback<T>? onCellLongPressed;

  const HeatmapCallbackModel({
    this.onCellPressed,
    this.onCellLongPressed,
  });
}

enum CalendarScrollPosition { start, ended }

enum CalendarMonthLabelPosition { top, bottom }

enum CalendarWeekLabelPosition { left, right }

enum CalendarColorTipPosition { top, bottom }

enum CalendarColorTipAlignBy { left, right, center }

enum CalendarAutoChippedBasis { left, right }

class HeatmapCalendar<T extends Comparable<T>> extends StatefulWidget {
  /// Heatmap start date
  final DateTime startDate;

  /// Heatmap ended date
  final DateTime endedDate;

  /// Heatmap first day of week, See weekday define in [DateTime]
  ///   static const int monday = 1;
  ///   ...
  ///   static const int sunday = 7;
  final int firstDay;

  /// Handling time using UTC
  final bool withUTC;

  // Provide a map that needs emphasis or color change in a heatmap
  final Map<DateTime, T>? selectedMap;

  /// Provide a map that defines how the cell in 'selectedMap'
  /// should change color in the heatmap
  /// e.g. {1: Colors.red, 10: Colors.blue}
  /// color of heatmap cell: (-inf,1) defualt, [1, 10) red, [10,inf) blue
  final Map<T, Color>? colorMap;

  /// Provide a map that defines how the cell value in 'selectedMap'
  /// should change color in the heatmap
  /// This map is generally used in color maps when some colors in the map
  /// are too close to the value colors, making it difficult to distinguish them
  /// e.g. colorMap = {0: Colors.white, 10: Colors.black, 20: Colors.blue}
  ///      valueColorMap = {0: Colors.Black, 10: Colors.white}
  final Map<T, Color>? valueColorMap;

  /// i18n, also see flutter docs [Internationalizing Flutter apps] or
  /// example in `example/lib/page_localization.dart`;
  final Locale? locale;

  /// Heatmap style options, see [HeatmapCalendarStyle]
  final HeatmapCalendarStyle? style;

  /// Heatmap cell size
  final Size cellSize;

  /// Distance between Heatmap cells
  final double cellSpaceBetween;

  /// Heatmap week label size, recommand set same width with `cellSize`
  final Size? weekLabalCellSize;

  /// Distance between week label column and heatmap cell columns
  final double weekLabelSpaceBetweenHeatmap;

  /// Heatmap color tips cell size, recomannd equal or smaller than `cellSize`
  final Size? colorTipCellSize;

  /// Distance between heatmap color tips
  final double colorTipCellBetweem;

  /// Distance between color tip row and heatmap body
  final double colorTipSpaceBetweenHeatmap;

  /// Displayed color tip number, color defined in `colorMap`,
  /// Select n colors uniformly from `colorMap`,
  /// if set num larger than `colorMap.length`, show num as `colorMap.length`
  final int colorTipNum;

  /// cusom color tips left helper text
  final Widget? colorTipLeftHelper;

  /// cusom color tips right helper text
  final Widget? colorTipRightHelper;

  /// Heatmap layout options, see [HeatmapLayoutParameters]
  final HeatmapLayoutParameters layoutParameters;

  /// Heatmap switch options, see [HeatmapSwitchParameters]
  final HeatmapSwitchParameters switchParameters;

  /// Heatmap calendar horizontal scroll controller
  final ScrollController? _controller;

  /// some callbacks, see [HeatmapCallbackModel]
  final HeatmapCallbackModel<T>? callbackModel;

  // Duration of changes in heatmap cell value
  final Duration cellChangeAnimateDuration;

  // Custom animate of changes in heatmap cell value
  final AnimatedSwitcherTransitionBuilder? cellChangeAnimateTransitionBuilder;

  /// Custom heatmap cell builder
  /// e.g. (add tootips):
  /// ```dart
  /// cellBuilder: (context, childBuilder, columnIndex, rowIndex, date) {
  ///   return Tooltip(
  ///     message: "${DateFormat('yyyy-MM-dd').format(date)} value: $value",
  ///     waitDuration: const Duration(seconds: 1),
  ///     child: childBuilder(
  ///       context,
  ///       valueBuilder: (context, dateDay) {
  ///         if (dateDay == null) return null;
  ///         var n = vm.data[date];
  ///         return Text((n ?? 0).toString());
  ///       },
  ///     ),
  ///   );
  /// },
  /// ```
  final CellItemBuilder? cellBuilder;

  /// Customn month label builder
  /// e.g.
  /// ```dart
  /// monthLabelItemBuilder: (context, data, format) {
  ///   return Text(DateFormat(DateFormat.YEAR_MONTH).format(data));
  /// }
  /// ```
  final MonthLabelValueBuilder? monthLabelItemBuilder;

  /// Custom week label builder
  /// e.g.
  /// ```dart
  /// weekLabelValueBuilder: (context, data, format) {
  ///   Text(DateFormat('cccc', myLocale).format(protoDate));
  /// }
  /// ```
  final WeekLabelValueBuilder? weekLabelValueBuilder;

  const HeatmapCalendar({
    super.key,
    required this.startDate,
    required this.endedDate,
    this.firstDay = DateTime.sunday,
    this.withUTC = false,
    this.selectedMap,
    this.colorMap,
    this.valueColorMap,
    this.locale,
    this.style,
    this.cellSize = defaultCellSize,
    this.cellSpaceBetween = defualtCellSpaceBetween,
    this.weekLabalCellSize,
    this.weekLabelSpaceBetweenHeatmap = defualtCellSpaceBetween,
    this.colorTipNum = 5,
    this.colorTipLeftHelper,
    this.colorTipRightHelper,
    this.colorTipCellSize,
    this.colorTipCellBetweem = defualtCellSpaceBetween,
    this.colorTipSpaceBetweenHeatmap = defualtCellSpaceBetween,
    this.layoutParameters = const HeatmapLayoutParameters.defaults(),
    this.switchParameters = const HeatmapSwitchParameters.defaults(),
    ScrollController? controller,
    this.callbackModel,
    this.cellChangeAnimateDuration = const Duration(milliseconds: 300),
    this.cellChangeAnimateTransitionBuilder,
    this.cellBuilder,
    this.monthLabelItemBuilder,
    this.weekLabelValueBuilder,
  })  : _controller = controller,
        assert(cellSize != Size.zero && cellSize != Size.infinite),
        assert(weekLabalCellSize != Size.zero &&
            weekLabalCellSize != Size.infinite),
        assert(
            colorTipCellSize != Size.zero && colorTipCellSize != Size.infinite);

  @override
  State<StatefulWidget> createState() => _HeatmapCalendar<T>();
}

class _HeatmapCalendar<T extends Comparable<T>>
    extends State<HeatmapCalendar<T>> {
  late SplayTreeMap<T, Color> colorMap;
  late SplayTreeMap<T, Color> valueColorMap;
  late HeatmapCalendarLocationCalclator _model;
  late final ScrollController controller;
  late final ScrollController _labelController;
  Size? _overlayCellSize;
  HeatmapCalendarLocationCalclator? _clippedModel;

  HeatmapCalendarLocationCalclator get model {
    if (autoClipped) return _clippedModel ?? _model;
    return _model;
  }

  static double calcHeatmapWidth(
      int columnCount, double cellWidth, double cellSpaceBetween) {
    return columnCount * cellWidth + (columnCount - 1) * cellSpaceBetween;
  }

  static int calcHeatmapColumnCount(
      double width, double cellWidth, double cellSpaceBetween) {
    return (cellSpaceBetween + width) ~/ (cellWidth + cellSpaceBetween);
  }

  String get localeName =>
      (widget.locale ?? Localizations.localeOf(context)).toString();

  Map<DateTime, T>? get selectedMap => widget.selectedMap;

  HeatmapCalendarStyle? get userStyle => widget.style;

  double get cellSpaceBetween => widget.cellSpaceBetween;

  double get weekLabelSpaceBetweenHeatmap =>
      widget.weekLabelSpaceBetweenHeatmap;

  CalendarScrollPosition get defaultLocation =>
      widget.layoutParameters.defaultScrollPosition;

  CalendarMonthLabelPosition? get calendarLabelLocation =>
      widget.layoutParameters.monthLabelPosition;

  CalendarWeekLabelPosition? get weekLabelLocation =>
      widget.layoutParameters.weekLabelPosition;

  CalendarColorTipPosition? get colorTipLocation =>
      widget.layoutParameters.colorTipPosition;

  Size get colorTipCellSize => widget.colorTipCellSize ?? cellSize;

  double get colorTipCellBetweem => widget.colorTipCellBetweem;

  int get colorTipNum => widget.colorTipNum;

  double get colorTipSpaceBetweenHeatmap => widget.colorTipSpaceBetweenHeatmap;

  bool get showCellText => widget.switchParameters.showCellText;

  bool get autoScaled => widget.switchParameters.autoScaled;

  bool get autoClipped => widget.switchParameters.autoClipped != null;

  CalendarAutoChippedBasis? get autoClippedBasis =>
      widget.switchParameters.autoClipped;

  bool get tappable => widget.switchParameters.tappable;

  bool get canScroll => widget.switchParameters.canScroll != null
      ? widget.switchParameters.canScroll!
      : autoScaled
          ? false
          : true;

  HeatmapCallbackModel<T>? get callbacks => widget.callbackModel;

  Size get cellSize => _overlayCellSize ?? widget.cellSize;

  double get heatmapHeight =>
      maxDayOfWeek * cellSize.height + (maxDayOfWeek - 1) * cellSpaceBetween;

  double get heatmapWidth {
    final columnCount = model.offsetColumnWithEndDate + 1;
    return calcHeatmapWidth(columnCount, cellSize.width, cellSpaceBetween);
  }

  Size get weekLabelCellSize => widget.weekLabalCellSize ?? cellSize;

  double get weekLabelWidth =>
      weekLabelCellSize.width + weekLabelSpaceBetweenHeatmap;

  double get widgetWidth {
    var totalWidth = heatmapWidth;
    if (weekLabelLocation != null) {
      totalWidth += weekLabelWidth;
    }
    return totalWidth;
  }

  HeatmapCalendarStyle _getDefaultStyle(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    if (theme.useMaterial3) {
      return HeatmapCalendarStyle.defaults(
        cellValueColor: theme.primaryColor,
        cellBackgroundColor: theme.colorScheme.outlineVariant.withOpacity(0.16),
        cellValuePadding: defaultCellValuePadding,
        cellRadius: defaultCellBorderRadius,
        weekLabelColor: theme.primaryColor,
        colorTipCellRadius: userStyle?.cellRadius ?? defaultCellBorderRadius,
        monthLabelColor: theme.colorScheme.outline,
      );
    } else {
      return HeatmapCalendarStyle.defaults(
        cellValueColor: theme.primaryColor,
        cellBackgroundColor: Colors.grey.withOpacity(0.16),
        cellValuePadding: defaultCellValuePadding,
        cellRadius: defaultCellBorderRadius,
        weekLabelColor: theme.primaryColor,
        colorTipCellRadius: userStyle?.cellRadius ?? defaultCellBorderRadius,
        monthLabelColor: Colors.grey,
      );
    }
  }

  Widget _getColorTipLeftHelper(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        fontSize: colorTipCellSize.height,
        color: Theme.of(context).primaryColor,
      ),
      child: widget.colorTipLeftHelper ?? const Text("Less"),
    );
  }

  Widget _getColorTipRightHelper(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        fontSize: colorTipCellSize.height,
        color: Theme.of(context).primaryColor,
      ),
      child: widget.colorTipRightHelper ?? const Text("More"),
    );
  }

  Color? getSelectedDateColor(DateTime date) {
    if (selectedMap == null || !selectedMap!.containsKey(date)) return null;
    final value = selectedMap![date]!;
    for (var i in colorMap.keys) {
      if (value.compareTo(i) >= 0) return colorMap[i];
    }
    return null;
  }

  Color? getSelectedDateValueColor(DateTime date) {
    if (selectedMap == null || !selectedMap!.containsKey(date)) return null;
    final value = selectedMap![date]!;
    for (var i in valueColorMap.keys) {
      if (value.compareTo(i) >= 0) return valueColorMap[i];
    }
    return null;
  }

  EdgeInsets getCellPadding(int columnIndex, int rowIndex) {
    return EdgeInsets.only(
      // left: columnIndex == 0 ? 0.0 : cellSpaceBetween,
      top: rowIndex == 0 ? 0.0 : cellSpaceBetween,
    );
  }

  Iterable<Color> getSampleColorsFromColorMap({bool reverse = false}) {
    final keyList = <T>[];
    if (colorTipNum > colorMap.length) {
      keyList.addAll(colorMap.keys);
    } else {
      switch (colorTipNum) {
        case 0:
          break;
        case 1:
          if (colorMap.isNotEmpty) keyList.add(colorMap.firstKey()!);
          break;
        case 2:
          if (colorMap.isNotEmpty) keyList.add(colorMap.firstKey()!);
          if (colorMap.length > 1) keyList.add(colorMap.lastKey()!);
          break;
        default:
          if (colorMap.isNotEmpty) keyList.add(colorMap.firstKey()!);
          if (colorMap.length > 1) keyList.add(colorMap.lastKey()!);
          if (colorMap.length > 2) {
            var newList = colorMap.keys.toList();
            newList.sort();
            newList = newList.sublist(1, colorMap.length - 1);
            final lastTipNum = colorTipNum - 2;
            final interval = newList.length ~/ lastTipNum;
            keyList.addAll(
              Iterable.generate(
                  lastTipNum, (i) => newList.skip(i * interval).first),
            );
          }
          break;
      }
    }

    if (!reverse) {
      keyList.sort((a, b) => a.compareTo(b));
    } else {
      keyList.sort((a, b) => b.compareTo(a));
    }
    return keyList.map((e) => colorMap[e]!);
  }

  @override
  void didUpdateWidget(covariant HeatmapCalendar<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _overlayCellSize = null;
    _clippedModel = null;
    if (widget.startDate != oldWidget.startDate ||
        widget.endedDate != oldWidget.endedDate ||
        widget.firstDay != oldWidget.firstDay) {
      _model = HeatmapCalendarLocationCalclator(
        startDate: widget.startDate,
        endedDate: widget.endedDate,
        firstDay: widget.firstDay,
        withUTC: widget.withUTC,
      );
    }
    if (!mapEquals(widget.colorMap, oldWidget.colorMap)) {
      colorMap = SplayTreeMap.of(
        widget.colorMap ?? {},
        (a, b) => b.compareTo(a),
      );
    }
    if (!mapEquals(widget.valueColorMap, oldWidget.valueColorMap)) {
      valueColorMap = SplayTreeMap.of(
        widget.valueColorMap ?? {},
        (a, b) => b.compareTo(a),
      );
    }
  }

  void syncScrollPostionListener() {
    if (calendarLabelLocation != null &&
        controller.position.pixels != _labelController.position.pixels) {
      _labelController.jumpTo(controller.position.pixels);
    }
  }

  @override
  void initState() {
    super.initState();
    _model = HeatmapCalendarLocationCalclator(
      startDate: widget.startDate,
      endedDate: widget.endedDate,
      firstDay: widget.firstDay,
      withUTC: widget.withUTC,
    );
    colorMap = SplayTreeMap.of(
      widget.colorMap ?? {},
      (a, b) => b.compareTo(a),
    );
    valueColorMap = SplayTreeMap.of(
      widget.valueColorMap ?? {},
      (a, b) => b.compareTo(a),
    );
    controller = widget._controller ?? ScrollController();
    _labelController = ScrollController();
    controller.addListener(syncScrollPostionListener);
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   switch (defaultLocation) {
    //     case CalendarScrollPosition.start:
    //       controller.jumpTo(0);
    //       break;
    //     case CalendarScrollPosition.ended:
    //       controller.jumpTo(widgetWidth);
    //       break;
    //   }
    // });
  }

  @override
  void dispose() {
    if (widget._controller == null) controller.dispose();
    _labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = _getDefaultStyle(context);

    Widget buildFrame(BuildContext context) {
      final children = <Widget>[
        SizedBox(
          height: heatmapHeight,
          width: widgetWidth,
          child: Builder(builder: (context) => _buildHeatmap(context, style)),
        )
      ];

      switch (calendarLabelLocation) {
        case CalendarMonthLabelPosition.top:
          children.insert(
            0,
            Builder(
              key: ValueKey(calendarLabelLocation),
              builder: (context) => _buildCalendarLabel(context, style),
            ),
          );
          break;
        case CalendarMonthLabelPosition.bottom:
          children.add(
            Builder(
              key: ValueKey(calendarLabelLocation),
              builder: (context) => _buildCalendarLabel(context, style),
            ),
          );
          break;
        default:
          break;
      }

      switch (colorTipLocation) {
        case CalendarColorTipPosition.top:
          children.insert(
            0,
            Builder(
              key: ValueKey(colorTipLocation),
              builder: (context) => _buildColorTip(context, style),
            ),
          );
          break;
        case CalendarColorTipPosition.bottom:
          children.add(
            Builder(
              key: ValueKey(colorTipLocation),
              builder: (context) => _buildColorTip(context, style),
            ),
          );
          break;
        default:
          break;
      }

      return Column(mainAxisSize: MainAxisSize.max, children: children);
    }

    if (autoScaled) {
      return LayoutBuilder(
        builder: (context, constraints) {
          var columnCount = model.offsetColumnWithEndDate + 1;
          if (weekLabelLocation != null) columnCount += 1;
          final size =
              (constraints.maxWidth - (columnCount - 1) * cellSpaceBetween) /
                  columnCount;
          _overlayCellSize = Size.square(math.max(0.1, size));
          return buildFrame(context);
        },
      );
    } else if (autoClipped) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final double clippedHeatmapWidth =
              math.max(constraints.maxWidth - weekLabelWidth, 0);
          final clippedHeatmapColumn = math.max(
              calcHeatmapColumnCount(
                  clippedHeatmapWidth, cellSize.width, cellSpaceBetween),
              1);
          switch (autoClippedBasis) {
            case CalendarAutoChippedBasis.left:
              final newEndedDate = _model.startDate.add(Duration(
                  days: (maxDayOfWeek - 1) -
                      _model.offsetRowWithStartDate +
                      (clippedHeatmapColumn - 1) * maxDayOfWeek));
              if (newEndedDate.isBefore(_model.endedDate)) {
                _clippedModel = _model.copyWith(endedDate: newEndedDate);
              } else {
                _clippedModel = null;
              }
              break;
            case CalendarAutoChippedBasis.right:
              final newStartDate = _model.endedDate.subtract(Duration(
                  days: _model.offsetRowWithEndDate +
                      (clippedHeatmapColumn - 1) * maxDayOfWeek));
              if (newStartDate.isAfter(_model.startDate)) {
                _clippedModel = _model.copyWith(startDate: newStartDate);
              } else {
                _clippedModel = null;
              }
              break;
            default:
              break;
          }
          return buildFrame(context);
        },
      );
    } else {
      return buildFrame(context);
    }
  }

  Widget _buildHeatmap(BuildContext context, HeatmapCalendarStyle style) {
    final needBuildFromEnd = defaultLocation == CalendarScrollPosition.ended;
    var itemMaxIndex = model.offsetColumnWithEndDate;
    if (weekLabelLocation != null) itemMaxIndex += 1;

    return ListView.separated(
      itemBuilder: (context, columnIndex) {
        if (needBuildFromEnd) columnIndex = itemMaxIndex - columnIndex;

        if ((columnIndex == 0 &&
                weekLabelLocation == CalendarWeekLabelPosition.left) ||
            (columnIndex == itemMaxIndex &&
                weekLabelLocation == CalendarWeekLabelPosition.right)) {
          return WeekLabelColumn(
            model: model,
            format: DateFormat(defaultWeekLabelDateFormatter, localeName),
            valueColor: userStyle?.weekLabelColor ?? style.weekLabelColor,
            valueAlignment: userStyle?.weekLabelValueAlignment ??
                style.weekLabelValueAlignment,
            valueSize: userStyle?.weekLabelValueFontSize ??
                style.weekLabelValueFontSize,
            cellSize: weekLabelCellSize,
            cellSpaceBetween: cellSpaceBetween,
            autoScaled: autoScaled,
            weekLabelLocation: weekLabelLocation,
            weekLabelSpaceBetweenHeatmap: weekLabelSpaceBetweenHeatmap,
            weekLabelValueBuilder: widget.weekLabelValueBuilder,
          );
        }

        return HeatmapCellItemColumn<T>(
          model: model,
          columnIndex: columnIndex,
          weekLabelLocation: weekLabelLocation,
          cellSize: cellSize,
          cellRadius: userStyle?.cellRadius ?? style.cellRadius,
          cellValueSize:
              userStyle?.cellValueFontSize ?? style.cellValueFontSize,
          cellValuePadding:
              userStyle?.cellValuePadding ?? style.cellValuePadding,
          showCellText: showCellText,
          autoScaled: autoScaled,
          tappable: tappable,
          cellChangeAnimateDuration: widget.cellChangeAnimateDuration,
          cellChangeAnimateTransitionBuilder:
              widget.cellChangeAnimateTransitionBuilder,
          getSelectedDateColor: (date) =>
              getSelectedDateColor(date) ??
              userStyle?.cellBackgroundColor ??
              style.cellBackgroundColor!,
          getSelectedDateValueColor: (date) =>
              getSelectedDateValueColor(date) ??
              userStyle?.cellValueColor ??
              style.cellValueColor!,
          onCellPressed: callbacks?.onCellPressed,
          onCellLongPressed: callbacks?.onCellLongPressed,
          getValue: (date) => selectedMap?[date],
          getCellPadding: getCellPadding,
          cellItemBuilder: widget.cellBuilder,
        );
      },
      separatorBuilder: (context, index) {
        if (index == 0 || index >= itemMaxIndex) {
          return const SizedBox();
        }

        return SizedBox(width: cellSpaceBetween);
      },
      reverse: needBuildFromEnd,
      itemCount: itemMaxIndex + 1,
      scrollDirection: Axis.horizontal,
      physics: canScroll ? null : const NeverScrollableScrollPhysics(),
      controller: controller,
    );
  }

  Widget _buildCalendarLabel(BuildContext context, HeatmapCalendarStyle style) {
    return SingleChildScrollView(
      controller: _labelController,
      scrollDirection: Axis.horizontal,
      reverse: defaultLocation == CalendarScrollPosition.ended,
      physics: const NeverScrollableScrollPhysics(),
      child: SizedBox(
        width: widgetWidth,
        child: MonthLabelRow(
          model: model,
          offset: weekLabelWidth,
          weekLabelLocation: weekLabelLocation,
          cellSize: cellSize,
          cellSpaceBetween: cellSpaceBetween,
          monthLabelColor: userStyle?.monthLabelColor ?? style.monthLabelColor,
          monthLabelFontSize:
              userStyle?.monthLabelFontSize ?? style.monthLabelFontSize,
          labelTextSizeMultiple: userStyle?.monthLabelTextSizeMultiple ??
              style.monthLabelTextSizeMultiple!,
          getFormat: (date) {
            final formatter = date.month == 1 &&
                    (userStyle?.showYearOnMonthLabel ??
                        style.showYearOnMonthLabel)
                ? "yMMM"
                : "MMM";
            return DateFormat(formatter, localeName);
          },
          getCellPadding: (columnIndex) => getCellPadding(columnIndex, 0),
          monthLabelItemBuilder: widget.monthLabelItemBuilder,
        ),
      ),
    );
  }

  Widget _buildColorTip(BuildContext context, HeatmapCalendarStyle style) {
    final offset = userStyle?.colorTipPosOffset ?? style.colorTipPosOffset;

    var colorTipAlignBy = userStyle?.colorTipAlignBy ?? style.colorTipAlignBy;
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center;
    if (colorTipAlignBy == null) {
      switch (defaultLocation) {
        case CalendarScrollPosition.start:
          colorTipAlignBy = CalendarColorTipAlignBy.left;
          mainAxisAlignment = MainAxisAlignment.start;
          break;
        case CalendarScrollPosition.ended:
          colorTipAlignBy = CalendarColorTipAlignBy.right;
          mainAxisAlignment = MainAxisAlignment.end;
          break;
      }
    }

    double topPadding = cellSpaceBetween, bottomPadding = cellSpaceBetween;
    switch (colorTipLocation) {
      case CalendarColorTipPosition.top:
        bottomPadding = colorTipSpaceBetweenHeatmap;
        break;
      case CalendarColorTipPosition.bottom:
        topPadding = colorTipSpaceBetweenHeatmap;
        break;
      default:
        break;
    }

    return Container(
      padding: EdgeInsets.only(
        top: topPadding,
        bottom: bottomPadding,
      ),
      width: widgetWidth,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: mainAxisAlignment,
        children: [
          if (colorTipAlignBy == CalendarColorTipAlignBy.left)
            SizedBox(width: offset.toDouble()),
          Flexible(
            flex: 1,
            child: HeatmapColorTip<T>(
              cellSize: colorTipCellSize,
              cellSpaceBetween: colorTipCellBetweem,
              cellRadius:
                  userStyle?.colorTipCellRadius ?? style.colorTipCellRadius,
              leftTip: _getColorTipLeftHelper(context),
              rigthtTip: _getColorTipRightHelper(context),
              colors: getSampleColorsFromColorMap().toList(),
            ),
          ),
          if (colorTipAlignBy == CalendarColorTipAlignBy.right)
            SizedBox(width: offset.toDouble()),
        ],
      ),
    );
  }
}
