import 'package:material_ui/material_ui.dart';
import 'package:simple_heatmap_calendar/simple_heatmap_calendar.dart';

import '../shared/demo_data.dart';
import '../shared/demo_widgets.dart';

class BasicHeatmapPage extends StatelessWidget {
  const BasicHeatmapPage({super.key});

  @override
  Widget build(BuildContext context) => DemoScaffold(
    title: 'Basics',
    description: 'Start with the default calendar, add labels, or fit a whole year into the available width.',
    children: [
      DemoCard(
        title: 'Default calendar',
        child: HeatmapCalendar<num>(
          startDate: DateTime(2023, 1, 1),
          endedDate: DateTime(2023, 4, 10),
          selectedMap: sampleYearData,
          colorMap: heatmapColors(context),
          layoutParameters: const HeatmapLayoutParameters.defaults(
            defaultScrollPosition: CalendarScrollPosition.start,
          ),
        ),
      ),
      DemoCard(
        title: 'Labels and legend',
        child: HeatmapCalendar<num>(
          startDate: DateTime(2023, 1, 1),
          endedDate: DateTime(2023, 12, 31),
          firstDay: DateTime.monday,
          selectedMap: sampleYearData,
          colorMap: heatmapColors(context),
          layoutParameters: const HeatmapLayoutParameters.defaults(
            defaultScrollPosition: CalendarScrollPosition.start,
            monthLabelPosition: CalendarMonthLabelPosition.top,
            weekLabelPosition: CalendarWeekLabelPosition.left,
            colorTipPosition: CalendarColorTipPosition.bottom,
          ),
          style: const HeatmapCalendarStyle.defaults(
            cellRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
      ),
      DemoCard(
        title: 'Fit to width',
        description:
            'Resize the window to see the same year scale automatically.',
        child: HeatmapCalendar<num>(
          startDate: DateTime(2023, 1, 1),
          endedDate: DateTime(2023, 12, 31),
          selectedMap: sampleYearData,
          colorMap: heatmapColors(context),
          layoutParameters: const HeatmapLayoutParameters.defaults(
            monthLabelPosition: CalendarMonthLabelPosition.top,
          ),
          style: const HeatmapCalendarStyle.defaults(
            showYearOnMonthLabel: false,
            cellRadius: BorderRadius.all(Radius.circular(4)),
          ),
          switchParameters: const HeatmapSwitchParameters.defaults(
            autoScaled: true,
          ),
        ),
      ),
    ],
  );
}
