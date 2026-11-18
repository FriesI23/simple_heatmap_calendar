# Change log

## Unreleased

- **Breaking:** Require Flutter 3.47.9 / Dart 3.13 and migrate the calendar to
  `material_ui`. Host apps, themes, and custom Material builders must use the
  standalone Material package.
- Adapt the example, localization setup, and native runners to Flutter 3.47.9.
- Add shared Makefile and CI gates for analysis, formatting, package and example
  tests, Web builds, and pub.dev validation.

## 0.4.0

- Revert withValues to withOpacity

Upstream fixed this deprecation warning. see [here](https://github.com/dart-lang/dart-pad/pull/3065).

## 0.3.0

- Update code to be compatible with Flutter 3.27
- Add some flutter analysis options
- Resolve issues related to crossing Daylight Saving Time boundaries. (#9)

## 0.2.0

- add utc datetime support
- fix intl deps

## 0.1.2

- expose labelTextSizeMultiple in MonthLabelRow

## 0.1.1

- dart dependency changed: 2.17.0~3.0.0

## 0.1.0

- Change functional widgets to stateless widgets, see [here](https://github.com/flutter/flutter/issues/19269#issuecomment-562945713)
- Fix monthLabel sync issue during scrolling
- Refactor some code

## 0.0.3

- Add `valueBuilder` to the build method of `childBuilder` in `cellBuilder`

## 0.0.2

- Add `colorTipSpaceBetweenHeatmap` param in `CalendarHeatmap`

## 0.0.1

- Release package
