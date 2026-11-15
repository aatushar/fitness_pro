import '../repositories/notification_repository.dart';

/// Marks one notification read, or all of them when [id] is null.
class MarkNotificationsReadUseCase {
  final NotificationRepository _repo;
  MarkNotificationsReadUseCase(this._repo);

  Future<void> call({int? id}) =>
      id == null ? _repo.markAllRead() : _repo.markRead(id);
}
