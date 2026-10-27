import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Purple rounded square with the dumbbell icon.
class AppLogoMark extends StatelessWidget {
  final double size;
  const AppLogoMark({super.key, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        color: AppColors.purple,
        borderRadius: BorderRadius.circular(size * 0.29),
        boxShadow: [
          BoxShadow(
            color: AppColors.purpleGlow,
            blurRadius: size / 3,
            offset: Offset(0, size / 8),
          ),
        ],
      ),
      child: Icon(
        Icons.fitness_center_rounded,
        color: Colors.white, size: size * 0.46,
      ),
    );
  }
}
