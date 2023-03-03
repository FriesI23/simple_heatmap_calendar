import 'localizations.dart';

/// The translations for Chinese (`zh`).
class L10nZh extends L10n {
  L10nZh([String locale = 'zh']) : super(locale);

  @override
  String get colorTipLeftHelperText => '更少';

  @override
  String get colorTipRightHelperText => '更多';
}
