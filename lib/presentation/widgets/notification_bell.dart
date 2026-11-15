import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_palette.dart';
import '../blocs/notifications/notifications_cubit.dart';

/// Bell icon in a bordered square. Shows a dot while there are unread
/// notifications and opens the notifications page. Needs a
/// [NotificationsCubit] above it (provided at the dashboard route).
class NotificationBell extends StatelessWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final unread = context.select<NotificationsCubit, int>(
      (cubit) => cubit.state.unreadCount,
    );

    return Semantics(
      button: true,
      label: unread > 0 ? 'Notifications, $unread unread' : 'Notifications',
      child: GestureDetector(
        onTap: () async {
          final cubit = context.read<NotificationsCubit>();
          await context.push(AppRoutes.notifications);
          // Whatever was read on that page should clear the dot here.
          cubit.load();
        },
        child: Container(
          width: 38, height: 38,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: palette.border),
          ),
          child: Stack(alignment: Alignment.center, children: [
            const Icon(Icons.notifications_none_rounded,
                color: AppColors.purple, size: 20),
            if (unread > 0)
              Positioned(
                top: 8, right: 8,
                child: Container(
                  width: 7, height: 7,
                  decoration: const BoxDecoration(
                    color: AppColors.danger,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}
