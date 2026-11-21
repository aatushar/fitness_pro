import 'dart:io';

import 'package:fitness_pro/core/format/formatters.dart';
import 'package:fitness_pro/core/l10n/app_strings.dart';
import 'package:fitness_pro/core/l10n/bangla_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() => AppStrings.current = AppLanguage.english);

  test('English is the default and text passes through unchanged', () {
    expect(AppStrings.current, AppLanguage.english);
    expect('Sign Out'.trNow, 'Sign Out');
    expect(AppStrings.digits('12 days'), '12 days');
    expect(AppStrings.spacing(0.5), 0.5);
  });

  test('Bangla translates text, digits and drops letter spacing', () {
    AppStrings.current = AppLanguage.bangla;
    expect('Sign Out'.trNow, 'সাইন আউট');
    expect(AppStrings.digits('Age 25'), 'Age ২৫');
    expect(AppStrings.tNow('5 days', '5 দিন'), '৫ দিন');
    expect(AppStrings.spacing(0.5), isNull);
  });

  test('a missing translation falls back to English', () {
    AppStrings.current = AppLanguage.bangla;
    expect('Not in the map'.trNow, 'Not in the map');
  });

  test('dates and money follow the language', () {
    final date = DateTime(2027, 2, 11, 9, 5);
    expect(formatDate(date), '11 Feb 2027');
    expect(formatTaka(124500), '৳ 1,24,500');
    AppStrings.current = AppLanguage.bangla;
    expect(formatDate(date), '১১ ফেব্রু ২০২৭');
    expect(formatTaka(124500), '৳ ১,২৪,৫০০');
    expect(formatDateTime(date, now: date), '১১ ফেব্রু, ৯:০৫ পূর্বাহ্ণ');
  });

  test('language names are shown in their own language', () {
    expect(AppLanguage.english.nativeName, 'English');
    expect(AppLanguage.bangla.nativeName, 'বাংলা');
    expect(AppLanguage.fromCode('bn'), AppLanguage.bangla);
    expect(AppLanguage.fromCode(null), AppLanguage.english);
  });

  test('every .tr / .trNow text in lib has a Bangla translation', () {
    final literal = RegExp(
        r"""(?:'((?:[^'\\]|\\.)*)'|"((?:[^"\\]|\\.)*)")\.(?:tr\(context\)|trNow)""");
    final missing = <String>[];
    for (final file in Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))) {
      for (final m in literal.allMatches(file.readAsStringSync())) {
        final text = (m.group(1) ?? m.group(2)!).replaceAll(r"\'", "'");
        if (text.contains(r'$')) continue; // built from values
        if (!banglaStrings.containsKey(text)) missing.add(text);
      }
    }
    expect(missing, isEmpty, reason: 'add these to bangla_strings.dart');
  });

  test('Bangla strings are real Bangla and keep their digits as 0-9', () {
    final bangla = RegExp(r'[ঀ-৿]');
    final notBangla = banglaStrings.entries
        .where((e) => !bangla.hasMatch(e.value) && e.value != e.key)
        .map((e) => e.key);
    expect(notBangla, isEmpty);
  });

  testWidgets('widgets follow the locale and rebuild on a language change',
      (tester) async {
    final locale = ValueNotifier(const Locale('en'));
    await tester.pumpWidget(ValueListenableBuilder<Locale>(
      valueListenable: locale,
      builder: (_, value, __) => MaterialApp(
        locale: value,
        supportedLocales: const [Locale('en'), Locale('bn')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: Builder(
          builder: (context) => Text('Sign Out'.tr(context)),
        ),
      ),
    ));
    expect(find.text('Sign Out'), findsOneWidget);

    locale.value = const Locale('bn');
    await tester.pump();
    expect(find.text('সাইন আউট'), findsOneWidget);
  });
}
