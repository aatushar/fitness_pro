import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/api_exception.dart';
import '../../../domain/entities/app_notification_entity.dart';
import '../../../domain/usecases/get_notifications_usecase.dart';
import '../../../domain/usecases/mark_notifications_read_usecase.dart';

enum NotificationsStatus { loading, loaded, failure }

class NotificationsState {
  final NotificationsStatus status;
  final List<AppNotificationEntity> items;
  final String? message;

  const NotificationsState({
    this.status = NotificationsStatus.loading,
    this.items = const [],
    this.message,
  });

  int get unreadCount => items.where((n) => !n.read).length;
}

/// The signed-in user's notification list and unread count (the bell badge).
class NotificationsCubit extends Cubit<NotificationsState> {
  final GetNotificationsUseCase _getNotifications;
  final MarkNotificationsReadUseCase _markRead;

  NotificationsCubit(this._getNotifications, this._markRead)
      : super(const NotificationsState());

  Future<void> load() async {
    try {
      emit(NotificationsState(
        status: NotificationsStatus.loaded,
        items: await _getNotifications(),
      ));
    } catch (e) {
      // Keep what we had; the bell must not turn into an error.
      emit(NotificationsState(
        status: NotificationsStatus.failure,
        items: state.items,
        message: ApiException.messageOf(e),
      ));
    }
  }

  Future<void> markRead(int id) async {
    _setRead((n) => n.id == id);
    try {
      await _markRead(id: id);
    } catch (_) {
      // Not saved on the server; it shows as unread again on the next load.
    }
  }

  Future<void> markAllRead() async {
    _setRead((_) => true);
    try {
      await _markRead();
    } catch (_) {}
  }

  void _setRead(bool Function(AppNotificationEntity) test) => emit(
        NotificationsState(
          status: state.status,
          message: state.message,
          items: [
            for (final n in state.items) test(n) ? n.copyWith(read: true) : n,
          ],
        ),
      );
}
