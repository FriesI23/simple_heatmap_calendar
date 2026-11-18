import 'package:material_ui/material_ui.dart';
import 'package:simple_heatmap_calendar/simple_heatmap_calendar.dart';

import '../shared/demo_data.dart';
import '../shared/demo_widgets.dart';
import '../shared/label_formatters.dart';
import '../shared/text_scale.dart';

class FontScalePage extends StatefulWidget {
  const FontScalePage({super.key});

  @override
  State<FontScalePage> createState() => _FontScalePageState();
}

class _FontScalePageState extends State<FontScalePage> {
  double _scale = 1;

  @override
  Widget build(BuildContext context) => DemoScaffold(
    title: 'Text scaling',
    description: 'Scale the calendar cells along with the text so labels remain readable.',
    children: [
      DemoCard(
        title: 'Text size',
        child: SliderControl(
          key: const ValueKey('text-scale-control'),
          label: 'Scale',
          value: _scale,
          min: 1,
          max: 2,
          divisions: 10,
          onChanged: (value) => setState(() => _scale = value),
        ),
      ),
      DemoCard(
        title: 'Scaled calendar',
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: MediaQuery.textScalerOf(context)
                .clamp(minScaleFactor: _scale),
          ),
          child: Builder(
            builder: (context) => HeatmapCalendar<num>(
              weekLabelFormatter: intlWeekLabelFormatter,
              monthLabelFormatter: intlMonthLabelFormatter,
              startDate: DateTime(2023, 1, 1),
              endedDate: DateTime(2023, 4, 30),
              firstDay: DateTime.monday,
              cellSize: MediaQuery.textScalerOf(context)
                  .scaleForSize(defaultCellSize),
              selectedMap: sampleYearData,
              colorMap: heatmapColors(context),
              layoutParameters: const HeatmapLayoutParameters.defaults(
                defaultScrollPosition: CalendarScrollPosition.start,
                monthLabelPosition: CalendarMonthLabelPosition.top,
                weekLabelPosition: CalendarWeekLabelPosition.left,
              ),
              switchParameters: const HeatmapSwitchParameters.defaults(
                showCellText: true,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
