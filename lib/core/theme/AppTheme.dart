import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBg,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.purple,
      surface: AppColors.darkSurface,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    useMaterial3: true,
  );

  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBg,
    colorScheme: const ColorScheme.light(
      primary: AppColors.purple,
      surface: AppColors.lightSurface,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
    useMaterial3: true,
  );
}