import 'package:fitness_pro/core/l10n/app_strings.dart';
import 'package:fitness_pro/presentation/blocs/locale/locale_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late LocaleCubit cubit;

  setUp(() => SharedPreferences.setMockInitialValues({}));
  tearDown(() {
    cubit.close();
    AppStrings.current = AppLanguage.english;
  });

  test('starts in English', () async {
    cubit = LocaleCubit();
    await cubit.loadLanguage();
    expect(cubit.state, AppLanguage.english);
    expect(AppStrings.current, AppLanguage.english);
  });

  test('choosing Bangla switches the app and is remembered', () async {
    cubit = LocaleCubit();
    await cubit.setLanguage(AppLanguage.bangla);
    expect(cubit.state, AppLanguage.bangla);
    expect(AppStrings.current, AppLanguage.bangla);
    expect((await SharedPreferences.getInstance()).getString('language'), 'bn');
  });

  test('a saved Bangla choice is restored on the next launch', () async {
    SharedPreferences.setMockInitialValues({'language': 'bn'});
    cubit = LocaleCubit();
    await cubit.loadLanguage();
    expect(cubit.state, AppLanguage.bangla);
    expect(AppStrings.current, AppLanguage.bangla);
  });

  test('back to English', () async {
    cubit = LocaleCubit();
    await cubit.setLanguage(AppLanguage.bangla);
    await cubit.setLanguage(AppLanguage.english);
    expect(cubit.state, AppLanguage.english);
    expect(AppStrings.current, AppLanguage.english);
  });
}
