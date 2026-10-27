import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Theme tokens that [ColorScheme] has no slot for.
/// Read them with `context.palette` so widgets follow light/dark automatically.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  final Color surfaceAlt;
  final Color border;
  final Color textPrimary;
  final Color textMuted;
  final Color label;
  final Color strengthFill;
  final Color tintPurple;
  final Color tintGreen;
  final Color tintAmber;
  final Color tintRed;
  final Color avatarFill;
  final Color roleText;
  final Color dangerBg;

  const AppPalette({
    required this.surfaceAlt,
    required this.border,
    required this.textPrimary,
    required this.textMuted,
    required this.label,
    required this.strengthFill,
    required this.tintPurple,
    required this.tintGreen,
    required this.tintAmber,
    required this.tintRed,
    required this.avatarFill,
    required this.roleText,
    required this.dangerBg,
  });

  static const dark = AppPalette(
    surfaceAlt:   AppColors.darkSurfaceAlt,
    border:       AppColors.darkBorder,
    textPrimary:  AppColors.darkTextPrim,
    textMuted:    AppColors.darkTextMuted,
    label:        AppColors.darkLabel,
    strengthFill: AppColors.darkStrFill,
    tintPurple:   AppColors.darkTintPurple,
    tintGreen:    AppColors.darkTintGreen,
    tintAmber:    AppColors.darkTintAmber,
    tintRed:      AppColors.darkTintRed,
    avatarFill:   AppColors.darkAvatarFill,
    roleText:     AppColors.darkRoleText,
    dangerBg:     AppColors.darkDangerBg,
  );

  static const light = AppPalette(
    surfaceAlt:   AppColors.lightSurfaceAlt,
    border:       AppColors.lightBorder,
    textPrimary:  AppColors.lightTextPrim,
    textMuted:    AppColors.lightTextMuted,
    label:        AppColors.lightLabel,
    strengthFill: AppColors.lightStrFill,
    tintPurple:   AppColors.lightTintPurple,
    tintGreen:    AppColors.lightTintGreen,
    tintAmber:    AppColors.lightTintAmber,
    tintRed:      AppColors.lightTintRed,
    avatarFill:   AppColors.lightAvatarFill,
    roleText:     AppColors.lightRoleText,
    dangerBg:     AppColors.lightDangerBg,
  );

  @override
  AppPalette copyWith({
    Color? surfaceAlt,
    Color? border,
    Color? textPrimary,
    Color? textMuted,
    Color? label,
    Color? strengthFill,
    Color? tintPurple,
    Color? tintGreen,
    Color? tintAmber,
    Color? tintRed,
    Color? avatarFill,
    Color? roleText,
    Color? dangerBg,
  }) {
    return AppPalette(
      surfaceAlt:   surfaceAlt ?? this.surfaceAlt,
      border:       border ?? this.border,
      textPrimary:  textPrimary ?? this.textPrimary,
      textMuted:    textMuted ?? this.textMuted,
      label:        label ?? this.label,
      strengthFill: strengthFill ?? this.strengthFill,
      tintPurple:   tintPurple ?? this.tintPurple,
      tintGreen:    tintGreen ?? this.tintGreen,
      tintAmber:    tintAmber ?? this.tintAmber,
      tintRed:      tintRed ?? this.tintRed,
      avatarFill:   avatarFill ?? this.avatarFill,
      roleText:     roleText ?? this.roleText,
      dangerBg:     dangerBg ?? this.dangerBg,
    );
  }

  @override
  AppPalette lerp(AppPalette? other, double t) {
    if (other == null) return this;
    return AppPalette(
      surfaceAlt:   Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      border:       Color.lerp(border, other.border, t)!,
      textPrimary:  Color.lerp(textPrimary, other.textPrimary, t)!,
      textMuted:    Color.lerp(textMuted, other.textMuted, t)!,
      label:        Color.lerp(label, other.label, t)!,
      strengthFill: Color.lerp(strengthFill, other.strengthFill, t)!,
      tintPurple:   Color.lerp(tintPurple, other.tintPurple, t)!,
      tintGreen:    Color.lerp(tintGreen, other.tintGreen, t)!,
      tintAmber:    Color.lerp(tintAmber, other.tintAmber, t)!,
      tintRed:      Color.lerp(tintRed, other.tintRed, t)!,
      avatarFill:   Color.lerp(avatarFill, other.avatarFill, t)!,
      roleText:     Color.lerp(roleText, other.roleText, t)!,
      dangerBg:     Color.lerp(dangerBg, other.dangerBg, t)!,
    );
  }
}

extension AppPaletteX on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;

  bool get isDarkTheme => Theme.of(this).brightness == Brightness.dark;
}
