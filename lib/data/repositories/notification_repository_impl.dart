import '../../domain/entities/app_notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_datasource.dart';
import '../models/notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDatasource _datasource;
  NotificationRepositoryImpl(this._datasource);

  @override
  Future<List<AppNotificationEntity>> getNotifications() async =>
      (await _datasource.getNotifications()).map((n) => n.toEntity()).toList();

  @override
  Future<void> markRead(int id) => _datasource.markRead(id);

  @override
  Future<void> markAllRead() => _datasource.markAllRead();
}
