import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:simple_heatmap_calendar/simple_heatmap_calendar.dart';

import '../shared/demo_data.dart';
import '../shared/demo_widgets.dart';

class TappableHeatmapPage extends StatefulWidget {
  const TappableHeatmapPage({super.key});

  @override
  State<TappableHeatmapPage> createState() => _TappableHeatmapPageState();
}

class _TappableHeatmapPageState extends State<TappableHeatmapPage> {
  Map<DateTime, num> _values = {};
  DateTime? _selectedDate;
  bool _tappable = true;
  bool _canScroll = true;
  bool _showText = true;

  void _update(DateTime date, num value) => setState(() {
    _selectedDate = date;
    _values = {..._values, date: value};
  });

  Future<void> _edit(DateTime date, num? value) async {
    var selected = (value ?? 0).clamp(0, 100).toDouble();
    final result = await showModalBottomSheet<num>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  DateFormat.yMMMd().format(date),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final preset in [0, 5, 10, 25, 50, 100])
                      ChoiceChip(
                        key: ValueKey('cell-value-$preset'),
                        label: Text('$preset'),
                        selected: selected == preset,
                        onSelected: (_) =>
                            setSheetState(() => selected = preset.toDouble()),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Slider(
                  value: selected,
                  min: 0,
                  max: 100,
                  divisions: 20,
                  label: '${selected.round()}',
                  onChanged: (value) => setSheetState(() => selected = value),
                ),
                FilledButton(
                  key: const ValueKey('apply-cell-value'),
                  onPressed: () => Navigator.of(context).pop(selected.round()),
                  child: Text('Apply ${selected.round()}'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (!mounted || result == null) return;
    _update(date, result);
  }

  @override
  Widget build(BuildContext context) => DemoScaffold(
    title: 'Interaction',
    description:
        'Tap a day to add 5. Long press to choose a value in the editor.',
    children: [
      DemoCard(
        title: 'Activity editor',
        child: HeatmapCalendar<num>(
          startDate: DateTime(2023, 1, 1),
          endedDate: DateTime(2023, 3, 31),
          firstDay: DateTime.monday,
          cellSize: const Size.square(32),
          selectedMap: _values,
          colorMap: heatmapColors(context),
          style: const HeatmapCalendarStyle.defaults(
            cellRadius: BorderRadius.all(Radius.circular(6)),
          ),
          layoutParameters: const HeatmapLayoutParameters.defaults(
            defaultScrollPosition: CalendarScrollPosition.start,
            monthLabelPosition: CalendarMonthLabelPosition.top,
            weekLabelPosition: CalendarWeekLabelPosition.left,
          ),
          switchParameters: HeatmapSwitchParameters.defaults(
            tappable: _tappable,
            canScroll: _canScroll,
            showCellText: _showText,
          ),
          callbackModel: HeatmapCallbackModel<num>(
            onCellPressed: (date, value) => _update(date, (value ?? 0) + 5),
            onCellLongPressed: _edit,
          ),
          cellBuilder: (context, childBuilder, column, row, date) => Tooltip(
            key: ValueKey(
              'interactive-cell-${DateFormat('yyyy-MM-dd').format(date)}',
            ),
            message:
                '${DateFormat.yMMMd().format(date)}: ${_values[date] ?? 0}',
            child: childBuilder(
              context,
              valueBuilder: (context, day) =>
                  day == null ? null : Text('${_values[date] ?? 0}'),
            ),
          ),
        ),
      ),
      DemoCard(
        title: 'Selected day',
        child: Text(
          key: const ValueKey('selected-cell-summary'),
          _selectedDate == null
              ? 'Choose a day to start.'
              : '${DateFormat.yMMMd().format(_selectedDate!)} · ${_values[_selectedDate] ?? 0}',
        ),
      ),
      DemoCard(
        title: 'Interaction options',
        child: Column(
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Enable editing'),
              value: _tappable,
              onChanged: (value) => setState(() => _tappable = value),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Horizontal scrolling'),
              value: _canScroll,
              onChanged: (value) => setState(() => _canScroll = value),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Show values'),
              value: _showText,
              onChanged: (value) => setState(() => _showText = value),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                key: const ValueKey('reset-activity'),
                onPressed: () => setState(() {
                  _values = {};
                  _selectedDate = null;
                }),
                icon: const Icon(Icons.restart_alt),
                label: const Text('Reset activity'),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
