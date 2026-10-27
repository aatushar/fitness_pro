import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_palette.dart';
import '../blocs/theme/theme_cubit.dart';

/// Pill-shaped dark/light switch. The only widget that calls toggleTheme().
class ThemeToggleSwitch extends StatelessWidget {
  final double width;
  final double height;

  const ThemeToggleSwitch({super.key, this.width = 52, this.height = 28});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isDark = context.isDarkTheme;
    final knob = height - 6;

    return Semantics(
      button: true,
      label: isDark ? 'Switch to light mode' : 'Switch to dark mode',
      child: GestureDetector(
        onTap: () => context.read<ThemeCubit>().toggleTheme(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: width, height: height,
          decoration: BoxDecoration(
            color: palette.surfaceAlt,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: palette.border),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            alignment: isDark ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: knob, height: knob,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: const BoxDecoration(
                color: AppColors.purple,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                color: Colors.white, size: knob * 0.58,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
