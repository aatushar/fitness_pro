import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Light or dark theme. Light is the default; the user's choice (made in the
/// profile settings) is saved and kept across restarts and sign-outs.
class ThemeCubit extends Cubit<ThemeMode> {
  static const _isDarkKey = 'is_dark';

  ThemeCubit() : super(ThemeMode.light);

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_isDarkKey) ?? false;
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final isDark = mode == ThemeMode.dark;
    if (state == (isDark ? ThemeMode.dark : ThemeMode.light)) return;
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDarkKey, isDark);
  }
}
