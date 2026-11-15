import '../entities/app_notification_entity.dart';
import '../repositories/notification_repository.dart';

class GetNotificationsUseCase {
  final NotificationRepository _repo;
  GetNotificationsUseCase(this._repo);

  Future<List<AppNotificationEntity>> call() => _repo.getNotifications();
}
