import 'package:flutter/widgets.dart';

import '../const.dart';
import '../heatmap_calendar.dart';
import '../label_formatters.dart';
import '../utils.dart';

import '_cell.dart';

class WeekLabelItem extends StatelessWidget {
  final DateTime date;

  /// Formatted text passed to [weekLabelValueBuilder] and used by default.
  final String? value;
  final Color? valueColor;
  final Alignment? valueAlignment;
  final double? valueSize;
  final EdgeInsetsGeometry padding;
  final Size? cellSize;
  final bool autoScaled;
  final WeekLabelValueBuilder? weekLabelValueBuilder;

  const WeekLabelItem({
    super.key,
    required this.date,
    this.value,
    this.valueColor,
    this.valueAlignment,
    this.valueSize,
    required this.padding,
    this.cellSize,
    required this.autoScaled,
    this.weekLabelValueBuilder,
  });

  @override
  Widget build(BuildContext context) {
    Widget? valueBuilder(BuildContext context, String? value) {
      if (weekLabelValueBuilder != null) {
        return weekLabelValueBuilder!(context, date, value ?? '');
      }
      if (value == null) return null;
      if (autoScaled) return FittedBox(child: Text(value));
      return Text(value);
    }

    return Padding(
      padding: padding,
      child: HeatmapCell<String>(
        size: cellSize,
        color: const Color(0x00000000),
        value: value,
        valueColor: valueColor,
        valueAlignment: valueAlignment,
        valueBuilder: weekLabelValueBuilder == null && !autoScaled
            ? null
            : valueBuilder,
        valueSize: valueSize,
      ),
    );
  }
}

class WeekLabelColumn extends StatelessWidget {
  final HeatmapCalendarLocationCalclator model;

  /// Locale passed to [formatter], defaulting to the surrounding locale or en.
  final Locale? locale;
  final WeekLabelFormatter formatter;
  final Color? valueColor;
  final Alignment? valueAlignment;
  final double? valueSize;
  final Size? cellSize;
  final double cellSpaceBetween;
  final bool autoScaled;
  final CalendarWeekLabelPosition? weekLabelLocation;
  final double weekLabelSpaceBetweenHeatmap;
  final WeekLabelValueBuilder? weekLabelValueBuilder;

  const WeekLabelColumn({
    super.key,
    required this.model,
    this.locale,
    this.formatter = defaultWeekLabelFormatter,
    this.valueColor,
    this.valueAlignment,
    this.valueSize,
    this.cellSize,
    required this.cellSpaceBetween,
    required this.autoScaled,
    this.weekLabelLocation,
    required this.weekLabelSpaceBetweenHeatmap,
    this.weekLabelValueBuilder,
  });

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

  @override
  Widget build(BuildContext context) {
    final effectiveLocale =
        locale ?? Localizations.maybeLocaleOf(context) ?? const Locale('en');
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(maxDayOfWeek, (rowIndex) {
        final date = model.getProtoDateByOffsetRow(rowIndex);
        return WeekLabelItem(
          date: date,
          value: formatter(date, effectiveLocale),
          valueColor: valueColor,
          valueAlignment: valueAlignment,
          valueSize: valueSize,
          padding: getWeekLabelPadding(rowIndex),
          cellSize: cellSize,
          autoScaled: autoScaled,
          weekLabelValueBuilder: weekLabelValueBuilder,
        );
      }),
    );
  }
}
