import 'package:flutter/material.dart';

import '../const.dart';
import '../heatmap_calendar.dart';
import '../utils.dart';

import '_cell.dart';

class _HeatmapCellItem extends StatelessWidget {
  final Size? cellSize;
  final Color? cellColor;
  final BorderRadius? cellRadius;
  final double? cellValueSize;
  final Color? cellValueColor;
  final EdgeInsetsGeometry? cellValuePadding;
  final int? cellValue;
  final EdgeInsetsGeometry padding;
  final bool isValidCell;
  final bool tappable;
  final bool showCellText;
  final bool autoScaled;
  final GestureTapCallback? onCellPressed;
  final GestureLongPressCallback? onCellLongPressed;
  final ValueBuilder? valueBuilder;

  const _HeatmapCellItem({
    super.key,
    this.cellSize,
    this.cellColor,
    this.cellRadius,
    this.cellValueSize,
    this.cellValueColor,
    this.cellValuePadding,
    this.cellValue,
    required this.padding,
    required this.isValidCell,
    required this.tappable,
    required this.showCellText,
    required this.autoScaled,
    this.onCellPressed,
    this.onCellLongPressed,
    this.valueBuilder,
  });

  @override
  Widget build(BuildContext context) {
    Widget cell = HeatmapCell<int>(
      key: ValueKey(cellColor),
      size: cellSize,
      color: cellColor,
      padding: cellValuePadding,
      radius: cellRadius,
      value: cellValue,
      valueColor: cellValueColor,
      valueBuilder: autoScaled
          ? (context, value) => FittedBox(
                child: value != null
                    ? (valueBuilder != null
                        ? valueBuilder!(context, value)
                        : Text(value.toString()))
                    : (valueBuilder != null
                        ? valueBuilder!(context, value)
                        : null),
              )
          : valueBuilder,
      valueSize: cellValueSize,
    );

    if (tappable && isValidCell) {
      cell = InkWell(
        borderRadius: cellRadius,
        onTap: onCellPressed,
        onLongPress: onCellLongPressed,
        child: cell,
      );
    }

    return Padding(
      padding: padding,
      child: cell,
    );
  }
}

class HeatmapCellItem<T extends Comparable<T>> extends StatelessWidget {
  final HeatmapCalendarLocationCalclator model;
  final DateTime date;
  final T? value;
  final Size? cellSize;
  final EdgeInsetsGeometry cellPadding;
  final BorderRadius? cellRadius;
  final double? cellValueSize;
  final EdgeInsetsGeometry? cellValuePadding;
  final bool showCellText;
  final bool autoScaled;
  final bool tappable;
  final Duration cellChangeAnimateDuration;
  final Curve switchInCurve;
  final Curve switchOutCurve;
  final AnimatedSwitcherTransitionBuilder? cellChangeAnimateTransitionBuilder;
  final Color? Function(DateTime date)? getSelectedDateColor;
  final Color? Function(DateTime date)? getSelectedDateValueColor;
  final CellPressedCallback<T>? onCellPressed;
  final CellPressedCallback<T>? onCellLongPressed;
  final ValueBuilder? valueBuilder;

  const HeatmapCellItem({
    super.key,
    required this.model,
    required this.date,
    this.value,
    this.cellSize,
    required this.cellPadding,
    this.cellRadius,
    this.cellValueSize,
    this.cellValuePadding,
    required this.showCellText,
    required this.autoScaled,
    required this.tappable,
    this.switchInCurve = Curves.easeInQuint,
    this.switchOutCurve = Curves.easeOutQuint,
    required this.cellChangeAnimateDuration,
    this.cellChangeAnimateTransitionBuilder,
    this.getSelectedDateColor,
    this.getSelectedDateValueColor,
    this.onCellPressed,
    this.onCellLongPressed,
    this.valueBuilder,
  });

  bool get useAnimate => cellChangeAnimateDuration != Duration.zero;

  @override
  Widget build(BuildContext context) {
    Color? cellColor, valueColor;
    int? dateDay;
    bool isValidCell = true;

    if (date.isBefore(model.startDate) || date.isAfter(model.endedDate)) {
      cellColor = Colors.transparent;
      isValidCell = false;
    } else {
      cellColor = getSelectedDateColor?.call(date);
      dateDay = showCellText ? date.day : null;
    }
    valueColor = getSelectedDateValueColor?.call(date);

    Widget buildCell(BuildContext context) {
      return _HeatmapCellItem(
        key: useAnimate ? ValueKey<String>("$date|$value") : null,
        cellSize: cellSize,
        cellColor: cellColor,
        cellRadius: cellRadius,
        cellValueSize: cellValueSize,
        cellValueColor: valueColor,
        cellValuePadding: cellValuePadding,
        cellValue: dateDay,
        padding: cellPadding,
        isValidCell: isValidCell,
        tappable: tappable,
        showCellText: showCellText,
        autoScaled: autoScaled,
        onCellPressed:
            onCellPressed != null ? () => onCellPressed!(date, value) : null,
        onCellLongPressed: onCellLongPressed != null
            ? () => onCellLongPressed!(date, value)
            : null,
        valueBuilder: valueBuilder,
      );
    }

    return cellChangeAnimateDuration != Duration.zero
        ? AnimatedSwitcher(
            duration: cellChangeAnimateDuration,
            switchInCurve: switchInCurve,
            switchOutCurve: switchOutCurve,
            transitionBuilder: cellChangeAnimateTransitionBuilder ??
                AnimatedSwitcher.defaultTransitionBuilder,
            child: buildCell(context),
          )
        : buildCell(context);
  }
}

class HeatmapCellItemColumn<T extends Comparable<T>> extends StatelessWidget {
  final HeatmapCalendarLocationCalclator model;
  final int columnIndex;
  final CalendarWeekLabelPosition? weekLabelLocation;
  final Size? cellSize;
  final BorderRadius? cellRadius;
  final double? cellValueSize;
  final EdgeInsetsGeometry? cellValuePadding;
  final bool showCellText;
  final bool autoScaled;
  final bool tappable;
  final Duration cellChangeAnimateDuration;
  final AnimatedSwitcherTransitionBuilder? cellChangeAnimateTransitionBuilder;
  final Color? Function(DateTime date)? getSelectedDateColor;
  final Color? Function(DateTime date)? getSelectedDateValueColor;
  final CellPressedCallback<T>? onCellPressed;
  final CellPressedCallback<T>? onCellLongPressed;
  final T? Function(DateTime date)? getValue;
  final EdgeInsetsGeometry Function(int columnIndex, int rowIndex)?
      getCellPadding;
  final CellItemBuilder? cellItemBuilder;

  const HeatmapCellItemColumn({
    super.key,
    required this.model,
    required this.columnIndex,
    this.weekLabelLocation,
    this.cellSize,
    this.cellRadius,
    this.cellValueSize,
    this.cellValuePadding,
    required this.showCellText,
    required this.autoScaled,
    required this.tappable,
    required this.cellChangeAnimateDuration,
    this.cellChangeAnimateTransitionBuilder,
    this.getSelectedDateColor,
    this.getSelectedDateValueColor,
    this.onCellPressed,
    this.onCellLongPressed,
    this.getValue,
    this.getCellPadding,
    this.cellItemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(
        maxDayOfWeek,
        (rowIndex) {
          final dateColumnIndex =
              weekLabelLocation == CalendarWeekLabelPosition.left
                  ? columnIndex - 1
                  : columnIndex;
          final date = model.getDateTimeByOffset(rowIndex, dateColumnIndex);

          Widget buildItem(BuildContext context, {ValueBuilder? valueBuilder}) {
            return HeatmapCellItem<T>(
              model: model,
              date: date,
              value: getValue?.call(date),
              cellSize: cellSize,
              cellPadding: getCellPadding?.call(columnIndex, rowIndex) ??
                  EdgeInsets.zero,
              cellRadius: cellRadius,
              cellValueSize: cellValueSize,
              cellValuePadding: cellValuePadding,
              showCellText: showCellText,
              autoScaled: autoScaled,
              tappable: tappable,
              cellChangeAnimateDuration: cellChangeAnimateDuration,
              cellChangeAnimateTransitionBuilder:
                  cellChangeAnimateTransitionBuilder,
              getSelectedDateColor: getSelectedDateColor,
              getSelectedDateValueColor: getSelectedDateValueColor,
              onCellPressed: onCellPressed,
              onCellLongPressed: onCellLongPressed,
              valueBuilder: valueBuilder,
            );
          }

          return cellItemBuilder?.call(
                  context, buildItem, columnIndex, rowIndex, date) ??
              buildItem(context);
        },
      ),
    );
  }
}
