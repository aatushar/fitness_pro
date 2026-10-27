import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_palette.dart';
import '../../blocs/current_user/current_user_cubit.dart';
import '../notification_bell.dart';
import '../theme_toggle_switch.dart';

/// Avatar + role line + signed-in user's name, with theme toggle and bell.
/// Needs a [CurrentUserCubit] above it (provided at the route).
class DashboardHeader extends StatelessWidget {
  final String roleLabel;
  final String fallbackName;

  const DashboardHeader({
    super.key,
    required this.roleLabel,
    required this.fallbackName,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final saved = context.watch<CurrentUserCubit>().state;
    final name = (saved == null || saved.isEmpty) ? fallbackName : saved;

    return Row(
      children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.purple, AppColors.purpleLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Center(
            child: Text(name[0].toUpperCase(),
              style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(roleLabel,
              style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w500,
                color: palette.textMuted,
              ),
            ),
            const SizedBox(height: 2),
            Text(name,
              style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w800,
                color: palette.textPrimary, letterSpacing: -0.4,
              ),
            ),
          ]),
        ),
        const SizedBox(width: 12),
        const ThemeToggleSwitch(width: 46, height: 26),
        const SizedBox(width: 10),
        const NotificationBell(),
      ],
    );
  }
}
