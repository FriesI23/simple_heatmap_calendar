import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:simple_heatmap_calendar/simple_heatmap_calendar.dart';

import '../shared/demo_data.dart';
import '../shared/demo_widgets.dart';

class CustomHeatmapPage extends StatefulWidget {
  const CustomHeatmapPage({super.key});

  @override
  State<CustomHeatmapPage> createState() => _CustomHeatmapPageState();
}

class _CustomHeatmapPageState extends State<CustomHeatmapPage> {
  final ScrollController _controller = ScrollController();
  DateTimeRange _range = DateTimeRange(
    start: DateTime(2023, 1, 1),
    end: DateTime(2023, 12, 31),
  );
  double _cellSize = 24;
  double _spacing = 2;
  double _radius = 4;
  int _firstDay = DateTime.monday;
  bool _showText = false;
  bool _customLabels = false;
  CalendarWeekLabelPosition? _weekLabels = CalendarWeekLabelPosition.left;
  CalendarMonthLabelPosition? _monthLabels = CalendarMonthLabelPosition.top;
  CalendarColorTipPosition? _legend = CalendarColorTipPosition.bottom;
  CalendarAutoChippedBasis? _clip;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _chooseRange() async {
    final range = await showDateRangePicker(
      context: context,
      initialDateRange: _range,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030, 12, 31),
    );
    if (!mounted || range == null) return;
    setState(() => _range = range);
  }

  void _scrollTo(bool end) {
    if (!_controller.hasClients) return;
    _controller.animateTo(
      end
          ? _controller.position.maxScrollExtent
          : _controller.position.minScrollExtent,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  Widget _preview(BuildContext context) => DemoCard(
    title: 'Live preview',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeatmapCalendar<num>(
          key: const ValueKey('playground-calendar'),
          controller: _controller,
          startDate: _range.start,
          endedDate: _range.end,
          firstDay: _firstDay,
          cellSize: Size.square(_cellSize),
          cellSpaceBetween: _spacing,
          selectedMap: sampleYearData,
          colorMap: heatmapColors(context),
          style: HeatmapCalendarStyle.defaults(
            cellRadius: BorderRadius.all(Radius.circular(_radius)),
            monthLabelFontSize: 12,
          ),
          layoutParameters: HeatmapLayoutParameters.defaults(
            defaultScrollPosition: CalendarScrollPosition.start,
            monthLabelPosition: _monthLabels,
            weekLabelPosition: _weekLabels,
            colorTipPosition: _legend,
          ),
          switchParameters: HeatmapSwitchParameters.defaults(
            showCellText: _showText,
            autoClipped: _clip,
          ),
          weekLabalCellSize: _customLabels
              ? Size(_cellSize * 2, _cellSize)
              : null,
          weekLabelValueBuilder: _customLabels
              ? (context, date, format) => Text(
                  DateFormat(
                    'EEE',
                    Localizations.localeOf(context).toLanguageTag(),
                  ).format(date).toUpperCase(),
                )
              : null,
          monthLabelItemBuilder: _customLabels
              ? (context, date, format) => Text(
                  DateFormat(
                    'MMM',
                    Localizations.localeOf(context).toLanguageTag(),
                  ).format(date).toUpperCase(),
                )
              : null,
          cellBuilder: (context, childBuilder, column, row, date) => Tooltip(
            message: DateFormat.yMMMd().format(date),
            child: childBuilder(context),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              key: const ValueKey('scroll-to-start'),
              onPressed: _clip == null ? () => _scrollTo(false) : null,
              icon: const Icon(Icons.first_page),
              label: const Text('Start'),
            ),
            OutlinedButton.icon(
              key: const ValueKey('scroll-to-end'),
              onPressed: _clip == null ? () => _scrollTo(true) : null,
              icon: const Icon(Icons.last_page),
              label: const Text('End'),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _controls() => Column(
    children: [
      DemoCard(
        title: 'Layout',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OutlinedButton.icon(
              key: const ValueKey('date-range'),
              onPressed: _chooseRange,
              icon: const Icon(Icons.date_range),
              label: Text(
                '${DateFormat.yMMMd().format(_range.start)} – ${DateFormat.yMMMd().format(_range.end)}',
              ),
            ),
            const SizedBox(height: 16),
            SliderControl(
              key: const ValueKey('cell-size-control'),
              label: 'Cell size',
              value: _cellSize,
              min: 16,
              max: 40,
              divisions: 12,
              onChanged: (value) => setState(() {
                _cellSize = value;
                _radius = _radius.clamp(0, value / 2);
              }),
            ),
            SliderControl(
              label: 'Spacing',
              value: _spacing,
              min: 0,
              max: 8,
              divisions: 8,
              onChanged: (value) => setState(() => _spacing = value),
            ),
            SliderControl(
              label: 'Corner radius',
              value: _radius,
              min: 0,
              max: _cellSize / 2,
              onChanged: (value) => setState(() => _radius = value),
            ),
            ChoiceControl<int>(
              label: 'First weekday',
              value: _firstDay,
              options: const {
                DateTime.monday: 'Monday',
                DateTime.sunday: 'Sunday',
              },
              onChanged: (value) => setState(() => _firstDay = value),
            ),
            ChoiceControl<CalendarAutoChippedBasis?>(
              label: 'Overflow',
              value: _clip,
              options: const {
                null: 'Scroll',
                CalendarAutoChippedBasis.left: 'Clip start',
                CalendarAutoChippedBasis.right: 'Clip end',
              },
              onChanged: (value) => setState(() => _clip = value),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      DemoCard(
        title: 'Labels and builders',
        child: Column(
          children: [
            ChoiceControl<CalendarWeekLabelPosition?>(
              label: 'Week labels',
              value: _weekLabels,
              options: const {
                CalendarWeekLabelPosition.left: 'Left',
                CalendarWeekLabelPosition.right: 'Right',
                null: 'Hidden',
              },
              onChanged: (value) => setState(() => _weekLabels = value),
            ),
            ChoiceControl<CalendarMonthLabelPosition?>(
              label: 'Month labels',
              value: _monthLabels,
              options: const {
                CalendarMonthLabelPosition.top: 'Top',
                CalendarMonthLabelPosition.bottom: 'Bottom',
                null: 'Hidden',
              },
              onChanged: (value) => setState(() => _monthLabels = value),
            ),
            ChoiceControl<CalendarColorTipPosition?>(
              label: 'Legend',
              value: _legend,
              options: const {
                CalendarColorTipPosition.top: 'Top',
                CalendarColorTipPosition.bottom: 'Bottom',
                null: 'Hidden',
              },
              onChanged: (value) => setState(() => _legend = value),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Show day numbers'),
              value: _showText,
              onChanged: (value) => setState(() => _showText = value),
            ),
            SwitchListTile(
              key: const ValueKey('custom-labels-toggle'),
              contentPadding: EdgeInsets.zero,
              title: const Text('Custom label builders'),
              value: _customLabels,
              onChanged: (value) => setState(() => _customLabels = value),
            ),
          ],
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) => DemoScaffold(
    title: 'Playground',
    description: 'Adjust a few options and see the calendar update. Hover a cell for its date.',
    children: [
      LayoutBuilder(
        builder: (context, constraints) {
          final preview = _preview(context);
          final controls = _controls();
          return constraints.maxWidth >= 900
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: preview),
                    const SizedBox(width: 20),
                    SizedBox(width: 340, child: controls),
                  ],
                )
              : Column(
                  children: [preview, const SizedBox(height: 16), controls],
                );
        },
      ),
    ],
  );
}
