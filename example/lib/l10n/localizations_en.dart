import 'localizations.dart';

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get colorTipLeftHelperText => 'Less';

  @override
  String get colorTipRightHelperText => 'More';
}
