import 'package:fitness_pro/presentation/blocs/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('loadTheme defaults to dark when nothing is saved', () async {
    SharedPreferences.setMockInitialValues({});
    final cubit = ThemeCubit();

    await cubit.loadTheme();

    expect(cubit.state, ThemeMode.dark);
    await cubit.close();
  });

  test('loadTheme restores a saved light theme', () async {
    SharedPreferences.setMockInitialValues({'is_dark': false});
    final cubit = ThemeCubit();

    await cubit.loadTheme();

    expect(cubit.state, ThemeMode.light);
    await cubit.close();
  });

  test('toggleTheme flips the mode and persists it', () async {
    SharedPreferences.setMockInitialValues({});
    final cubit = ThemeCubit();

    await cubit.toggleTheme();

    expect(cubit.state, ThemeMode.light);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('is_dark'), isFalse);
    await cubit.close();
  });
}
