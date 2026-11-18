# Simple Heatmap Calendar example

Material examples covering basic options, font scaling, interaction,
localization, and custom builders. Uses Flutter 3.47.9 from the repository's FVM pin.

## Run

From the repository root:

```sh
fvm install
make bootstrap
make gen
cd example
fvm flutter run
```

Use `-t lib/simple_example.dart` for the smaller example. The palette button
switches Material 2 / 3; the localization page switches English / Chinese.

## Development

Run `make check` from the repository root. After editing `lib/l10n/*.arb`,
run `make gen` to regenerate localizations.

From this directory, build with the installed platform toolchains:

```sh
fvm flutter build web --release
fvm flutter build apk --debug
fvm flutter build macos --debug
fvm flutter build ios --debug --no-codesign
```
