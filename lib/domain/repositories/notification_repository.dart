import '../entities/app_notification_entity.dart';

abstract class NotificationRepository {
  Future<List<AppNotificationEntity>> getNotifications();
  Future<void> markRead(int id);
  Future<void> markAllRead();
}
