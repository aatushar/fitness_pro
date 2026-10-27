// ignore_for_file: file_names — kept as AppTheme.dart per CLAUDE.md; rename in its own change.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_palette.dart';

class AppTheme {
  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBg,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.purple,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrim,
      outline: AppColors.darkBorder,
      error: AppColors.danger,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    extensions: const [AppPalette.dark],
    useMaterial3: true,
  );

  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBg,
    colorScheme: const ColorScheme.light(
      primary: AppColors.purple,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrim,
      outline: AppColors.lightBorder,
      error: AppColors.danger,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
    extensions: const [AppPalette.light],
    useMaterial3: true,
  );
}
