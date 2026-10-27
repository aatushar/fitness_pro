import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_palette.dart';

/// Bell icon in a bordered square, with an unread dot.
class NotificationBell extends StatelessWidget {
  final bool hasUnread;
  const NotificationBell({super.key, this.hasUnread = true});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      width: 38, height: 38,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: palette.border),
      ),
      child: Stack(alignment: Alignment.center, children: [
        const Icon(Icons.notifications_none_rounded,
            color: AppColors.purple, size: 20),
        if (hasUnread)
          Positioned(
            top: 8, right: 8,
            child: Container(
              width: 7, height: 7,
              decoration: const BoxDecoration(
                color: AppColors.purple,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ]),
    );
  }
}
