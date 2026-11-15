import 'package:fitness_pro/core/network/api_exception.dart';
import 'package:fitness_pro/domain/entities/app_notification_entity.dart';
import 'package:fitness_pro/domain/usecases/get_notifications_usecase.dart';
import 'package:fitness_pro/domain/usecases/mark_notifications_read_usecase.dart';
import 'package:fitness_pro/presentation/blocs/notifications/notifications_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_repositories.dart';

AppNotificationEntity _n(int id, {bool read = false}) => AppNotificationEntity(
      id: id,
      title: 'Subscription expired',
      message: 'Please pay your Gym subscription fee.',
      type: 'SUBSCRIPTION_EXPIRED',
      read: read,
      createdAt: DateTime(2026, 11, 11, 9),
    );

void main() {
  late FakeNotificationRepository repo;
  late NotificationsCubit cubit;

  setUp(() {
    repo = FakeNotificationRepository()
      ..items = [_n(1), _n(2), _n(3, read: true)];
    cubit = NotificationsCubit(
      GetNotificationsUseCase(repo),
      MarkNotificationsReadUseCase(repo),
    );
  });

  tearDown(() => cubit.close());

  test('load → the notifications and the unread count', () async {
    await cubit.load();

    expect(cubit.state.status, NotificationsStatus.loaded);
    expect(cubit.state.items, hasLength(3));
    expect(cubit.state.unreadCount, 2);
  });

  test('load failure keeps the old list and reports the message', () async {
    await cubit.load();
    repo.error = const ApiException('Cannot connect to server.');

    await cubit.load();

    expect(cubit.state.status, NotificationsStatus.failure);
    expect(cubit.state.message, 'Cannot connect to server.');
    expect(cubit.state.items, hasLength(3));
  });

  test('markRead updates the list at once and tells the server', () async {
    await cubit.load();

    await cubit.markRead(1);

    expect(cubit.state.unreadCount, 1);
    expect(repo.calls, ['markRead:1']);
  });

  test('markAllRead clears the unread count', () async {
    await cubit.load();

    await cubit.markAllRead();

    expect(cubit.state.unreadCount, 0);
    expect(repo.calls, ['markAllRead']);
  });
}
