# Repository Guidelines

## Project Structure & Module Organization

`lib/simple_heatmap_calendar.dart` defines public exports; implementations live in
`lib/src/`, with package tests in `test/`. `example/lib/` contains the Material 3
gallery, demos and helpers; `example/test/` covers the app.
Localization inputs are `example/lib/l10n/*.arb`. `screenshots/` holds README
animations; `.github/workflows/` defines checks and publishing.

## Build, Test, and Development Commands

Run from repository root. Install the SDK pinned in `.fvmrc` with `fvm install`;
Make prefers `.fvm/flutter_sdk`. Run Flutter commands sequentially.

- `make bootstrap`: resolve package and example dependencies.
- `make gen`: regenerate and format example localizations; edit ARBs, not generated Dart.
- `make check`: resolve dependencies, generate, verify formatting, analyze and test both projects.
- `make format` / `make format-check`: apply or verify Dart formatting.
- `make aio`: also apply automated fixes before validation.
- `make publish-dry-run`: inspect archive contents and warnings when package configuration,
  dependencies, assets or archive inclusion rules change.
- From `example/`, use `fvm flutter run` or `fvm flutter build web --release`.

## Coding Style & Naming Conventions

Use `dart format` with two-space indentation and `flutter_lints` rules in
`analysis_options.yaml`. Use `lower_snake_case.dart`, `UpperCamelCase` types and
`lowerCamelCase` members; prefer relative imports within the library.
Material widgets, hosts and themes use `material_ui`. Labels default to English;
applications supply localized formatters. Review public exports when changing APIs.

## Testing Guidelines

Use `flutter_test`, `*_test.dart` files and descriptive `test`/`testWidgets` names.
Run `make test-package`, `make test-example`, or `make test` for both.
Cover changed behavior, including locale/UTC handling, interactions, scrolling and
example regressions. Run `make check` for code changes and report skipped or blocked checks.

## Commit & Pull Request Guidelines

Follow Conventional Commits (`feat:`, `fix:`, `refactor:`, `chore:`); use `!` for
breaking changes. Follow `.github/PULL_REQUEST_TEMPLATE.md`, describe compatibility
and migration, record validation, and include screenshots for UI changes.
Update affected docs/examples and add concise CHANGELOG entries for user-facing changes.
Keep version bumps, tags and publication within the requested release scope;
tag publishing depends on shared CI checks.

## README demo capture

- Use the running example to demonstrate appearance switching, playground controls,
  and tap/long-press editing. Keep framing consistent and text/icons readable.
- Capture temporary frames or recordings, then compress them into looping WebP
  animations at `screenshots/playground.webp` and `screenshots/interaction.webp`.
- Preview the animations and verify README links; keep temporary recordings and
  frames outside version control. Final animations remain excluded from pub.dev
  by `screenshots/.pubignore`.
- Keep this as a maintenance procedure; do not commit capture/encoding scripts
  or add a capture target to the Makefile.
