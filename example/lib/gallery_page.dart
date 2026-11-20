import 'package:material_ui/material_ui.dart';
import 'package:simple_heatmap_calendar/simple_heatmap_calendar.dart';

import 'demos/basic_page.dart';
import 'demos/custom_page.dart';
import 'demos/interaction_page.dart';
import 'demos/localization_page.dart';
import 'demos/text_scale_page.dart';
import 'shared/demo_data.dart';
import 'shared/demo_widgets.dart';
import 'shared/label_formatters.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({
    super.key,
    required this.onToggleBrightness,
    required this.onLocaleChanged,
  });

  final VoidCallback onToggleBrightness;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final demos =
        <
          ({
            String id,
            String title,
            String description,
            IconData icon,
            WidgetBuilder builder,
          })
        >[
          (
            id: 'basic',
            title: 'Basics',
            description: 'Labels, legends, and automatic sizing.',
            icon: Icons.grid_view_rounded,
            builder: (_) => const BasicHeatmapPage(),
          ),
          (
            id: 'text-scale',
            title: 'Text scaling',
            description: 'Keep cells readable as text grows.',
            icon: Icons.text_increase,
            builder: (_) => const FontScalePage(),
          ),
          (
            id: 'interaction',
            title: 'Interaction',
            description: 'Tap to add activity. Hold to edit a day.',
            icon: Icons.touch_app_outlined,
            builder: (_) => const TappableHeatmapPage(),
          ),
          (
            id: 'localization',
            title: 'Localization',
            description: 'Switch calendar labels and app language.',
            icon: Icons.translate,
            builder: (_) => L10nPage(onLocaleChanged: onLocaleChanged),
          ),
          (
            id: 'custom',
            title: 'Playground',
            description: 'Adjust geometry, labels, and custom builders.',
            icon: Icons.tune,
            builder: (_) => const CustomHeatmapPage(),
          ),
        ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Heatmap Calendar'),
        actions: [
          IconButton(
            key: const ValueKey('theme-toggle'),
            tooltip: theme.brightness == Brightness.light
                ? 'Use dark theme'
                : 'Use light theme',
            onPressed: onToggleBrightness,
            icon: Icon(
              theme.brightness == Brightness.light
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'A year at a glance',
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Explore a heatmap, then try a focused example below.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  DemoCard(
                    title: '2023 activity',
                    child: HeatmapCalendar<num>(
                      weekLabelFormatter: intlWeekLabelFormatter,
                      monthLabelFormatter: intlMonthLabelFormatter,
                      startDate: DateTime(2023, 1, 1),
                      endedDate: DateTime(2023, 12, 31),
                      firstDay: DateTime.monday,
                      selectedMap: sampleYearData,
                      colorMap: heatmapColors(context),
                      cellSize: const Size.square(16),
                      style: const HeatmapCalendarStyle.defaults(
                        cellRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      layoutParameters: const HeatmapLayoutParameters.defaults(
                        defaultScrollPosition: CalendarScrollPosition.start,
                        monthLabelPosition: CalendarMonthLabelPosition.top,
                      ),
                      switchParameters: const HeatmapSwitchParameters.defaults(
                        autoScaled: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = constraints.maxWidth >= 900
                          ? 3
                          : constraints.maxWidth >= 600
                          ? 2
                          : 1;
                      final width =
                          (constraints.maxWidth - (columns - 1) * 16) / columns;
                      return Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          for (final demo in demos)
                            SizedBox(
                              width: width,
                              child: Card.filled(
                                margin: EdgeInsets.zero,
                                clipBehavior: Clip.antiAlias,
                                child: InkWell(
                                  key: ValueKey('demo-${demo.id}'),
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: demo.builder,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          demo.icon,
                                          color: theme.colorScheme.primary,
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                demo.title,
                                                style:
                                                    theme.textTheme.titleMedium,
                                              ),
                                            ),
                                            const Icon(
                                              Icons.arrow_forward,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(demo.description),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
