import 'dart:math' as math;
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'const.dart';
import 'heatmap_cell.dart';
import 'heatmap_colortip.dart';
import 'utils.dart';

class HeatmapCalendarStyle {
  /// change heatmap cell container color
  final Color? cellBackgroundColor;

  /// change heatmap cell radius
  final BorderRadius? cellRadius;

  /// change heatmap cell value color, [HeatmapSwitchParameters.showText]
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
  final void Function(DateTime date, T? value)? onCellPressed;

  /// callback when heatmap cell long clicked
  /// `HeatmapSwitchParameters.tappable` must be `true``
  final void Function(DateTime date, T? value)? onCellLongPressed;

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
  ///   Tooltip(
  ///     message: "${DateFormat('yyyy-MM-dd').format(date)}",
  ///     waitDuration: const Duration(seconds: 1),
  ///     child: childBuilder(context),
  ///   );
  /// }
  /// ```
  final Widget Function(
    BuildContext context,
    Widget Function(BuildContext) childBuilder,
    int columnIndex,
    int rowIndex,
    DateTime date,
  )? cellBuilder;

  /// Customn month label builder
  /// e.g.
  /// ```dart
  /// monthLabelItemBuilder: (context, data, format) {
  ///   return Text(DateFormat(DateFormat.YEAR_MONTH).format(data));
  /// }
  /// ```
  final Widget Function(
    BuildContext context,
    DateTime date,
    String defaultFormat,
  )? monthLabelItemBuilder;

  /// Custom week label builder
  /// e.g.
  /// ```dart
  /// weekLabelValueBuilder: (context, data, format) {
  ///   Text(DateFormat('cccc', myLocale).format(protoDate));
  /// }
  /// ```
  final Widget Function(
    BuildContext context,
    DateTime protoDate,
    String defaultFormat,
  )? weekLabelValueBuilder;

  const HeatmapCalendar({
    super.key,
    required this.startDate,
    required this.endedDate,
    this.firstDay = DateTime.sunday,
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
  static const _maxDayOfWeek = DateTime.sunday;
  static const _labelTextSizeMultiple = 3;

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
      _maxDayOfWeek * cellSize.height + (_maxDayOfWeek - 1) * cellSpaceBetween;

  double get heatmapWidth {
    var columnCount = model.offsetColumnWithEndDate + 1;
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
    ThemeData theme = Theme.of(context);
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
    var value = selectedMap![date]!;
    for (var i in colorMap.keys) {
      if (value.compareTo(i) >= 0) return colorMap[i];
    }
    return null;
  }

  Color? getSelectedDateValueColor(DateTime date) {
    if (selectedMap == null || !selectedMap!.containsKey(date)) return null;
    var value = selectedMap![date]!;
    for (var i in valueColorMap.keys) {
      if (value.compareTo(i) >= 0) return valueColorMap[i];
    }
    return null;
  }

  EdgeInsets getCellPadding(int columnIndex, int rowIndex) {
    return EdgeInsets.only(
      left: columnIndex == 0 ? 0.0 : cellSpaceBetween,
      top: rowIndex == 0 ? 0.0 : cellSpaceBetween,
    );
  }

  EdgeInsets getWeekLabelPadding(int rowIndex) {
    return EdgeInsets.only(
      left: weekLabelLocation == CalendarWeekLabelPosition.left
          ? 0.0
          : weekLabelSpaceBetweenHeatmap,
      right: weekLabelLocation == CalendarWeekLabelPosition.right
          ? 0.0
          : weekLabelSpaceBetweenHeatmap,
      top: rowIndex == 0 ? 0.0 : cellSpaceBetween,
    );
  }

  Iterable<Color> getSampleColorsFromColorMap({bool reverse = false}) {
    var keyList = <T>[];
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
            var lastTipNum = colorTipNum - 2;
            var interval = newList.length ~/ lastTipNum;
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

  @override
  void initState() {
    super.initState();
    _model = HeatmapCalendarLocationCalclator(
      startDate: widget.startDate,
      endedDate: widget.endedDate,
      firstDay: widget.firstDay,
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
    if (calendarLabelLocation != null) {
      controller.addListener(() {
        if (controller.position.pixels != _labelController.position.pixels) {
          _labelController.jumpTo(controller.position.pixels);
        }
      });
    }
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

  Widget _cellBuilder(
    BuildContext context, {
    required int columnIndex,
    required int rowIndex,
    required DateTime date,
    required HeatmapCalendarStyle defaultStyle,
  }) {
    Color cellColor, valueColor;
    int? value;
    EdgeInsets padding;
    bool isValidCell = true;
    if (date.isBefore(model.startDate) || date.isAfter(model.endedDate)) {
      cellColor = Colors.transparent;
      isValidCell = false;
    } else {
      var selectedColor = getSelectedDateColor(date);
      cellColor = selectedColor ??
          userStyle?.cellBackgroundColor ??
          defaultStyle.cellBackgroundColor!;
      value = showCellText ? date.day : null;
    }
    valueColor = getSelectedDateValueColor(date) ??
        userStyle?.cellValueColor ??
        defaultStyle.cellValueColor!;
    padding = getCellPadding(columnIndex, rowIndex);

    Widget cell = HeatmapCell<int>(
      key: ValueKey(cellColor),
      size: cellSize,
      color: cellColor,
      padding: userStyle?.cellValuePadding ?? defaultStyle.cellValuePadding,
      radius: userStyle?.cellRadius ?? defaultStyle.cellRadius,
      value: value,
      valueColor: valueColor,
      valueBuilder: autoScaled
          ? (context, value) =>
              FittedBox(child: value != null ? Text(value.toString()) : null)
          : null,
      valueSize: userStyle?.cellValueFontSize ?? defaultStyle.cellValueFontSize,
    );

    cell = widget.cellChangeAnimateDuration != Duration.zero
        ? AnimatedSwitcher(
            duration: widget.cellChangeAnimateDuration,
            switchInCurve: Curves.easeInQuint,
            switchOutCurve: Curves.easeOutQuint,
            transitionBuilder: widget.cellChangeAnimateTransitionBuilder ??
                AnimatedSwitcher.defaultTransitionBuilder,
            child: cell,
          )
        : cell;

    if (tappable && isValidCell) {
      cell = InkWell(
        borderRadius: userStyle?.cellRadius ?? defaultStyle.cellRadius,
        onTap: callbacks?.onCellPressed != null
            ? () => callbacks!.onCellPressed!(date, selectedMap?[date])
            : null,
        onLongPress: callbacks?.onCellLongPressed != null
            ? () => callbacks!.onCellLongPressed!(date, selectedMap?[date])
            : null,
        child: cell,
      );
    }

    return Padding(
      padding: padding,
      child: cell,
    );
  }

  Widget _getWeekLabelItem(
      BuildContext context, int rowIndex, HeatmapCalendarStyle defaultStyle) {
    var date = model.getProtoDateByOffsetRow(rowIndex);
    var formatter = 'ccccc';

    Widget? valueBuilder(BuildContext context, String? value) {
      if (widget.weekLabelValueBuilder != null) {
        return widget.weekLabelValueBuilder!(context, date, formatter);
      }
      if (value == null) return null;
      if (autoScaled) return FittedBox(child: Text(value));
      return Text(value);
    }

    return Padding(
      padding: getWeekLabelPadding(rowIndex),
      child: HeatmapCell<String>(
        size: weekLabelCellSize,
        color: Colors.transparent,
        value: DateFormat(formatter, localeName).format(date),
        valueColor: userStyle?.weekLabelColor ?? defaultStyle.weekLabelColor,
        valueAlignment: userStyle?.weekLabelValueAlignment ??
            defaultStyle.weekLabelValueAlignment,
        valueBuilder: widget.weekLabelValueBuilder == null && !autoScaled
            ? null
            : valueBuilder,
        valueSize: userStyle?.weekLabelValueFontSize ??
            defaultStyle.weekLabelValueFontSize,
      ),
    );
  }

  Widget _getMonthLabelItem(
      BuildContext context, DateTime date, HeatmapCalendarStyle style) {
    var formatter = date.month == 1 &&
            (userStyle?.showYearOnMonthLabel ?? style.showYearOnMonthLabel)
        ? "yMMM"
        : "MMM";
    return DefaultTextStyle(
      style: TextStyle(
        color: userStyle?.monthLabelColor ?? style.monthLabelColor,
        fontSize: userStyle?.monthLabelFontSize ?? style.monthLabelFontSize,
      ),
      child: widget.monthLabelItemBuilder?.call(context, date, formatter) ??
          Text(DateFormat(formatter, localeName).format(date)),
    );
  }

  Widget _monthLabelBuilder(BuildContext context) {
    var style = _getDefaultStyle(context);
    var dateMap = <int, DateTime>{};
    if (model.startDate.day == 1) {
      dateMap[model.getOffsetColumn(model.startDate)] = model.startDate;
    }
    var tmpDate = model.startDate;
    while (tmpDate.isBefore(model.endedDate)) {
      tmpDate = DateTime(tmpDate.year, tmpDate.month + 1, 1);
      dateMap[model.getOffsetColumn(tmpDate)] = tmpDate;
    }

    var children = <Widget>[];
    var columns = model.offsetColumnWithEndDate + 1;

    var columnIndex = 0;
    var maxColumnIndex = model.offsetColumnWithEndDate;
    while (columnIndex < maxColumnIndex) {
      var padding = getCellPadding(columnIndex, 0);
      if (dateMap.containsKey(columnIndex) &&
          (columns - columnIndex) >= _labelTextSizeMultiple) {
        var date = dateMap[columnIndex]!;
        children.add(
          Padding(
            padding: padding,
            child: SizedBox(
              width: cellSize.width * _labelTextSizeMultiple +
                  padding.left * (_labelTextSizeMultiple - 1),
              child: _getMonthLabelItem(context, date, style),
            ),
          ),
        );
        columnIndex += _labelTextSizeMultiple;
      } else {
        children.add(
          Padding(
            padding: padding,
            child: ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: cellSize.width),
            ),
          ),
        );
        columnIndex += 1;
      }
    }

    return Row(children: children);
  }

  @override
  Widget build(BuildContext context) {
    var style = _getDefaultStyle(context);

    Widget buildHeatmapCell(
        BuildContext context, int columnIndex, int rowIndex) {
      var dateColumnIndex = weekLabelLocation == CalendarWeekLabelPosition.left
          ? columnIndex - 1
          : columnIndex;
      var date = model.getDateTimeByOffset(rowIndex, dateColumnIndex);

      Widget childBuilder(BuildContext context) => _cellBuilder(
            context,
            date: date,
            columnIndex: columnIndex,
            rowIndex: rowIndex,
            defaultStyle: style,
          );

      if (widget.cellBuilder != null) {
        return widget.cellBuilder!(
          context,
          childBuilder,
          columnIndex,
          rowIndex,
          date,
        );
      } else {
        return childBuilder(context);
      }
    }

    Widget buildHeatmapWeekLabels(BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: List<Widget>.generate(
          _maxDayOfWeek,
          (rowIndex) => _getWeekLabelItem(context, rowIndex, style),
        ),
      );
    }

    Widget buildHeatmap(BuildContext context) {
      var needBuildFromEnd = defaultLocation == CalendarScrollPosition.ended;
      var itemMaxIndex = model.offsetColumnWithEndDate;
      if (weekLabelLocation != null) itemMaxIndex += 1;

      return ListView.builder(
        itemBuilder: (context, columnIndex) {
          if (needBuildFromEnd) columnIndex = itemMaxIndex - columnIndex;

          if ((columnIndex == 0 &&
                  weekLabelLocation == CalendarWeekLabelPosition.left) ||
              (columnIndex == itemMaxIndex &&
                  weekLabelLocation == CalendarWeekLabelPosition.right)) {
            return buildHeatmapWeekLabels(context);
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: List<Widget>.generate(
              _maxDayOfWeek,
              (rowIndex) => buildHeatmapCell(context, columnIndex, rowIndex),
            ),
          );
        },
        reverse: needBuildFromEnd,
        itemCount: itemMaxIndex + 1,
        scrollDirection: Axis.horizontal,
        physics: canScroll ? null : const NeverScrollableScrollPhysics(),
        controller: controller,
      );
    }

    Widget buildCalendarLabel(BuildContext context) {
      return SingleChildScrollView(
        controller: _labelController,
        scrollDirection: Axis.horizontal,
        reverse: defaultLocation == CalendarScrollPosition.ended,
        physics: const NeverScrollableScrollPhysics(),
        child: SizedBox(
          width: widgetWidth,
          child: _monthLabelBuilder(context),
        ),
      );
    }

    Widget buildColorTip(BuildContext context) {
      var offset = userStyle?.colorTipPosOffset ?? style.colorTipPosOffset;

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

    Widget buildFrame(BuildContext context) {
      var children = <Widget>[
        SizedBox(
          height: heatmapHeight,
          width: widgetWidth,
          child: buildHeatmap(context),
        )
      ];

      switch (calendarLabelLocation) {
        case CalendarMonthLabelPosition.top:
          children.insert(0, buildCalendarLabel(context));
          break;
        case CalendarMonthLabelPosition.bottom:
          children.add(buildCalendarLabel(context));
          break;
        default:
          break;
      }

      switch (colorTipLocation) {
        case CalendarColorTipPosition.top:
          children.insert(0, buildColorTip(context));
          break;
        case CalendarColorTipPosition.bottom:
          children.add(buildColorTip(context));
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
          var size =
              (constraints.maxWidth - (columnCount - 1) * cellSpaceBetween) /
                  columnCount;
          debugPrint(size.toString());
          _overlayCellSize = Size.square(math.max(0.1, size));
          return buildFrame(context);
        },
      );
    } else if (autoClipped) {
      return LayoutBuilder(
        builder: (context, constraints) {
          double clippedHeatmapWidth =
              math.max(constraints.maxWidth - weekLabelWidth, 0);
          var clippedHeatmapColumn = math.max(
              calcHeatmapColumnCount(
                  clippedHeatmapWidth, cellSize.width, cellSpaceBetween),
              1);
          switch (autoClippedBasis) {
            case CalendarAutoChippedBasis.left:
              var newEndedDate = _model.startDate.add(Duration(
                  days: (_maxDayOfWeek - 1) -
                      _model.offsetRowWithStartDate +
                      (clippedHeatmapColumn - 1) * _maxDayOfWeek));
              if (newEndedDate.isBefore(_model.endedDate)) {
                _clippedModel = _model.copyWith(endedDate: newEndedDate);
              } else {
                _clippedModel = null;
              }
              break;
            case CalendarAutoChippedBasis.right:
              var newStartDate = _model.endedDate.subtract(Duration(
                  days: _model.offsetRowWithEndDate +
                      (clippedHeatmapColumn - 1) * _maxDayOfWeek));
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
}
