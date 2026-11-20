# Simple Heatmap Calendar example

A small Material 3 gallery with light/dark appearance and five focused demos:

- **Basics:** defaults, labels, legends, and fitting a year to the available width.
- **Text scaling:** grow cells with the text scale.
- **Interaction:** tap to add activity, long press to edit a day, and reset the data.
- **Localization:** switch English/Chinese or override a single calendar's locale.
- **Playground:** adjust dates, cell geometry, labels, clipping, and custom builders.

## Run

From the repository root:

```sh
fvm install
make bootstrap
make gen
cd example
fvm flutter run
```

The toolbar toggles light/dark appearance. Material 3 is always enabled.
Use `-t lib/simple_example.dart` for the minimal standalone example.

## Source

`lib/main.dart` starts the app. `lib/app.dart` owns the theme and locale;
`lib/gallery_page.dart` presents the demos. Individual examples live in
`lib/demos/`, with sample data and small presentation helpers in `lib/shared/`.
State is local to each demo; no external state-management package is required.
Sample dates are fixed in 2023 so the same data appears on every run.

The gallery uses app-owned `intl` formatters in `lib/shared/label_formatters.dart`
and delegates to initialize locale data. The minimal example uses English defaults.

## Development

Run `make check` from the repository root. After editing `lib/l10n/*.arb`,
run `make gen`; do not edit generated localization files.

For README animations, follow the [demo capture rules](../AGENTS.md#readme-demo-capture).

Build with the installed platform toolchains:

```sh
fvm flutter build web --release
fvm flutter build apk --debug
fvm flutter build macos --debug
fvm flutter build ios --debug --no-codesign
```
