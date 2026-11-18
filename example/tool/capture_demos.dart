import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:example/app.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(_loadFonts);
  for (final scenario in ['playground', 'interaction']) {
    testWidgets('record $scenario', (tester) async {
      tester.view.physicalSize = const Size(1100, 780);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
      final recorder = _Recorder(tester, scenario);
      await recorder.prepare();
      await tester.pumpWidget(
        RepaintBoundary(
          key: recorder.surfaceKey,
          child: const HeatmapExampleApp(),
        ),
      );
      await tester.pumpAndSettle();
      await recorder.frames(8);
      if (scenario == 'playground') {
        await recorder.tap('theme-toggle', frames: 10);
        await recorder.tap('theme-toggle', frames: 10);
        await recorder.tap('demo-custom', frames: 10);
        final slider = find.descendant(
          of: find.byKey(const ValueKey('cell-size-control')),
          matching: find.byType(Slider),
        );
        final rect = tester.getRect(slider);
        await tester.tapAt(
          Offset(rect.left + rect.width * 0.8, rect.center.dy),
        );
        await recorder.frames(10);
        await recorder.tap('scroll-to-end', frames: 10);
      } else {
        await recorder.tap('demo-interaction', frames: 10);
        await recorder.tap('interactive-cell-2023-01-02', frames: 8);
        await recorder.tap('interactive-cell-2023-01-02', frames: 8);
        await tester.longPress(
          find.byKey(const ValueKey('interactive-cell-2023-01-02')),
        );
        await recorder.frames(8);
        await recorder.tap('cell-value-25', frames: 8);
        await recorder.tap('apply-cell-value', frames: 10);
      }
      await recorder.frames(10);
      expect(tester.takeException(), isNull);
    });
  }
}

class _Recorder {
  _Recorder(this.tester, String scenario)
    : directory = Directory('../build/example-demos/$scenario');

  final WidgetTester tester;
  final Directory directory;
  final surfaceKey = GlobalKey();
  int _frame = 0;

  Future<void> prepare() async {
    await tester.runAsync(() async {
      if (directory.existsSync()) directory.deleteSync(recursive: true);
      directory.createSync(recursive: true);
    });
  }

  Future<void> tap(String key, {int frames = 6}) async {
    final target = find.byKey(ValueKey(key));
    if (target.hitTestable().evaluate().isEmpty) {
      await tester.ensureVisible(target);
      await tester.pumpAndSettle();
    }
    await tester.tap(target);
    await this.frames(frames);
  }

  Future<void> frames(int count) async {
    for (var i = 0; i < count; i++) {
      await tester.pump(const Duration(milliseconds: 83));
      _useRecordingFont(surfaceKey.currentContext!.findRenderObject()!);
      await tester.pump();
      await tester.runAsync(() async {
        final boundary =
            surfaceKey.currentContext!.findRenderObject()!
                as RenderRepaintBoundary;
        final image = await boundary.toImage(pixelRatio: 0.8);
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        await File(
          '${directory.path}/${(_frame++).toString().padLeft(4, '0')}.png',
        ).writeAsBytes(bytes!.buffer.asUint8List());
        image.dispose();
      });
    }
  }
}

// Test fonts default to Ahem. Load real app fonts for readable recordings.
Future<void> _loadFonts() async {
  final manifest = jsonDecode(
    await rootBundle.loadString('FontManifest.json'),
  ) as List<dynamic>;
  for (final entry in manifest.cast<Map<String, dynamic>>()) {
    final loader = FontLoader(entry['family'] as String);
    for (final font
        in (entry['fonts'] as List<dynamic>).cast<Map<String, dynamic>>()) {
      loader.addFont(rootBundle.load(font['asset'] as String));
    }
    await loader.load();
  }
  final config = jsonDecode(
    File('.dart_tool/package_config.json').readAsStringSync(),
  ) as Map<String, dynamic>;
  final sdk = Uri.parse(config['flutterRoot'] as String).toFilePath();
  final loader = FontLoader('Roboto');
  for (final font
      in Directory('$sdk/bin/cache/artifacts/material_fonts')
          .listSync()
          .whereType<File>()
          .where((file) => file.uri.pathSegments.last.startsWith('Roboto-'))) {
    final bytes = font.readAsBytes().then(ByteData.sublistView);
    loader.addFont(bytes);
  }
  await loader.load();
}

// Unthemed labels otherwise fall back to Ahem inside flutter_tester.
// Keep explicit fonts (including icon fonts) and normalize only that fallback.
void _useRecordingFont(RenderObject object) {
  if (object is RenderParagraph && object.text.style?.fontFamily == null) {
    object.text = TextSpan(
      style: const TextStyle(fontFamily: 'Roboto'),
      children: [object.text],
    );
  }
  object.visitChildren(_useRecordingFont);
}
