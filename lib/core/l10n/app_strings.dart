import 'package:flutter/widgets.dart';
import 'bangla_strings.dart';

enum AppLanguage {
  english('en', 'English'),
  bangla('bn', 'বাংলা');

  final String code;

  /// Always shown in its own language, never translated.
  final String nativeName;
  const AppLanguage(this.code, this.nativeName);

  Locale get locale => Locale(code);

  static AppLanguage fromCode(String? code) =>
      AppLanguage.values.firstWhere((l) => l.code == code,
          orElse: () => AppLanguage.english);
}

/// Every user-facing string, in English and Bangla.
///
/// * Plain text: write the English as the key, `'Sign Out'.tr(context)`. The
///   Bangla is in [banglaStrings]. A missing translation shows the English.
/// * Text with values in it: `AppStrings.t(context, 'Age: $n years', 'বয়স: $n বছর')`
///   keeps both languages side by side.
/// * Code with no [BuildContext] (errors, notifications, date formats) uses
///   [trNow] / [tNow], which follow the language the user last chose.
class AppStrings {
  AppStrings._();

  /// Kept in step with `LocaleCubit`. English is the default.
  static AppLanguage current = AppLanguage.english;

  static bool get isBangla => current == AppLanguage.bangla;

  static const _bnDigits = '০১২৩৪৫৬৭৮৯';

  /// Latin digits to Bangla digits (০-৯) when the app is in Bangla.
  static String digits(String s) => isBangla ? _digitsOf(s) : s;

  static String _digitsOf(String s) {
    final b = StringBuffer();
    for (final r in s.runes) {
      b.write(r >= 0x30 && r <= 0x39 ? _bnDigits[r - 0x30] : String.fromCharCode(r));
    }
    return b.toString();
  }

  /// Language for [context]; rebuilds the widget when the language changes.
  static AppLanguage of(BuildContext context) =>
      AppLanguage.fromCode(Localizations.localeOf(context).languageCode);

  /// Translates plain [english] text for the current language.
  static String trNow(String english) =>
      isBangla ? _digitsOf(banglaStrings[english] ?? english) : english;

  /// Both versions of a string that has values in it.
  static String tNow(String english, String bangla) =>
      isBangla ? _digitsOf(bangla) : english;

  static String tr(BuildContext context, String english) {
    if (of(context) != AppLanguage.bangla) return english;
    return _digitsOf(banglaStrings[english] ?? english);
  }

  static String t(BuildContext context, String english, String bangla) =>
      of(context) == AppLanguage.bangla ? _digitsOf(bangla) : english;

  /// Letter spacing pulls Bangla conjuncts apart, so Bangla gets none.
  static double? spacing(double value) => isBangla ? null : value;
}

extension AppStringsX on String {
  /// This English text in the user's language.
  String tr(BuildContext context) => AppStrings.tr(context, this);

  /// Same, for code without a [BuildContext].
  String get trNow => AppStrings.trNow(this);
}
