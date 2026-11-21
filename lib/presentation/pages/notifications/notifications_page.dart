import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/format/formatters.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_palette.dart';
import '../../../domain/entities/app_notification_entity.dart';
import '../../blocs/notifications/notifications_cubit.dart';
import '../../widgets/app_back_button.dart';
import '../../widgets/dashboard/dashboard_cards.dart';
import '../../../core/l10n/app_strings.dart';

/// The signed-in user's notifications, newest first. Needs a [NotificationsCubit].
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () => context.read<NotificationsCubit>().load(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                children: [
                  ResponsiveCenter(
                    maxWidth: Breakpoints.formMaxWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const AppBackButton(),
                            Expanded(
                              child: Text('Notifications'.tr(context),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700,
                                  color: palette.textPrimary,
                                  letterSpacing: AppStrings.spacing(-0.3),
                                ),
                              ),
                            ),
                            // Same width as the back button keeps the title centred.
                            const SizedBox(width: 38),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (state.unreadCount > 0)
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => context
                                  .read<NotificationsCubit>()
                                  .markAllRead(),
                              child: Text('Mark all as read'.tr(context)),
                            ),
                          ),
                        _Body(state: state),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final NotificationsState state;
  const _Body({required this.state});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    if (state.status == NotificationsStatus.loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (state.items.isEmpty) {
      final failed = state.status == NotificationsStatus.failure;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            Icon(
              failed
                  ? Icons.cloud_off_rounded
                  : Icons.notifications_none_rounded,
              size: 44, color: palette.textMuted,
            ),
            const SizedBox(height: 12),
            Text(
              failed ? state.message ?? 'Could not load notifications.'.tr(context)
                     : 'No notifications yet'.tr(context),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: palette.textMuted),
            ),
            if (failed)
              TextButton(
                onPressed: () => context.read<NotificationsCubit>().load(),
                child: Text('Try again'.tr(context)),
              ),
          ],
        ),
      );
    }
    return Column(
      children: [
        for (final n in state.items) _NotificationTile(notification: n),
      ],
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final AppNotificationEntity notification;
  const _NotificationTile({required this.notification});

  (IconData, Color) get _icon => switch (notification.type) {
        'SUBSCRIPTION_ACTIVATED' =>
          (Icons.check_circle_outline_rounded, AppColors.success),
        'SUBSCRIPTION_EXPIRING' =>
          (Icons.schedule_rounded, AppColors.warning),
        'SUBSCRIPTION_EXPIRED' =>
          (Icons.error_outline_rounded, AppColors.danger),
        _ => (Icons.notifications_none_rounded, AppColors.purple),
      };

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final (icon, color) = _icon;
    final unread = !notification.read;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: unread ? AppColors.purple : palette.border,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: unread
              ? () => context
                  .read<NotificationsCubit>()
                  .markRead(notification.id)
              : null,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconBadge(icon: icon, color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: unread ? FontWeight.w800 : FontWeight.w600,
                          color: palette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(notification.message,
                        style: TextStyle(
                          fontSize: 12, color: palette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(formatDateTime(notification.createdAt),
                        style: TextStyle(
                          fontSize: 10, color: palette.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                if (unread) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 8, height: 8,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: const BoxDecoration(
                      color: AppColors.purple, shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
