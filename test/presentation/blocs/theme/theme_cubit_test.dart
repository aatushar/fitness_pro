import 'package:fitness_pro/presentation/blocs/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('light is the default when nothing is saved', () async {
    SharedPreferences.setMockInitialValues({});
    final cubit = ThemeCubit();
    expect(cubit.state, ThemeMode.light);

    await cubit.loadTheme();

    expect(cubit.state, ThemeMode.light);
    await cubit.close();
  });

  test('loadTheme restores a saved dark theme', () async {
    SharedPreferences.setMockInitialValues({'is_dark': true});
    final cubit = ThemeCubit();

    await cubit.loadTheme();

    expect(cubit.state, ThemeMode.dark);
    await cubit.close();
  });

  test('choosing dark switches the app and is saved', () async {
    SharedPreferences.setMockInitialValues({});
    final cubit = ThemeCubit();

    await cubit.setThemeMode(ThemeMode.dark);

    expect(cubit.state, ThemeMode.dark);
    expect((await SharedPreferences.getInstance()).getBool('is_dark'), isTrue);
    await cubit.close();
  });

  test('choosing light again switches back and is saved', () async {
    SharedPreferences.setMockInitialValues({'is_dark': true});
    final cubit = ThemeCubit();
    await cubit.loadTheme();

    await cubit.setThemeMode(ThemeMode.light);

    expect(cubit.state, ThemeMode.light);
    expect((await SharedPreferences.getInstance()).getBool('is_dark'), isFalse);
    await cubit.close();
  });

  test('the choice survives a fresh start (sign-out clears only the login)',
      () async {
    SharedPreferences.setMockInitialValues({});
    final first = ThemeCubit();
    await first.setThemeMode(ThemeMode.dark);
    await first.close();

    final second = ThemeCubit();
    await second.loadTheme();

    expect(second.state, ThemeMode.dark);
    await second.close();
  });
}
