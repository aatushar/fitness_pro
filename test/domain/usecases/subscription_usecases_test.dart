import 'package:fitness_pro/domain/usecases/activate_subscription_usecase.dart';
import 'package:fitness_pro/domain/usecases/get_member_subscriptions_usecase.dart';
import 'package:fitness_pro/domain/usecases/get_my_subscription_usecase.dart';
import 'package:fitness_pro/domain/usecases/get_notifications_usecase.dart';
import 'package:fitness_pro/domain/usecases/mark_notifications_read_usecase.dart';
import 'package:fitness_pro/domain/usecases/signout_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_repositories.dart';

void main() {
  late FakeSubscriptionRepository subs;
  late FakeNotificationRepository notifications;

  setUp(() {
    subs = FakeSubscriptionRepository();
    notifications = FakeNotificationRepository();
  });

  test('GetMySubscriptionUseCase returns the member subscription', () async {
    expect(await GetMySubscriptionUseCase(subs)(), same(activeSubscription));
  });

  test('GetMemberSubscriptionsUseCase returns the list together with the summary',
      () async {
    subs.members = [testMember];

    final result = await GetMemberSubscriptionsUseCase(subs)();

    expect(result.members, [testMember]);
    expect(result.summary, same(testSummary));
  });

  test('ActivateSubscriptionUseCase passes every field to the repository',
      () async {
    await ActivateSubscriptionUseCase(subs)(
      userId: 12,
      months: 3,
      amount: 4500,
      paymentMethod: 'CASH',
      note: 'first fee',
    );

    expect(subs.lastActivation, {
      'userId': 12,
      'months': 3,
      'testMinutes': null,
      'amount': 4500.0,
      'paymentMethod': 'CASH',
      'note': 'first fee',
    });
  });

  test('ActivateSubscriptionUseCase can start a minutes-long test plan', () async {
    await ActivateSubscriptionUseCase(subs)(
      userId: 12,
      testMinutes: 2,
      amount: 1,
      paymentMethod: 'CASH',
    );

    expect(subs.lastActivation['testMinutes'], 2);
    expect(subs.lastActivation['months'], isNull);
  });

  test('ActivateSubscriptionUseCase lets repository errors through', () {
    subs.error = StateError('server said no');
    expect(
      ActivateSubscriptionUseCase(subs)(
          userId: 1, months: 1, amount: 1, paymentMethod: 'CASH'),
      throwsStateError,
    );
  });

  test('GetNotificationsUseCase returns the notifications', () async {
    expect(await GetNotificationsUseCase(notifications)(), isEmpty);
  });

  test('MarkNotificationsReadUseCase marks one, or all when no id is given',
      () async {
    final useCase = MarkNotificationsReadUseCase(notifications);

    await useCase(id: 5);
    await useCase();

    expect(notifications.calls, ['markRead:5', 'markAllRead']);
  });

  group('SignoutUseCase', () {
    test('cancels the scheduled fee reminders', () async {
      final reminders = FakeReminderScheduler();

      await SignoutUseCase(FakeAuthRepository(), reminders)();

      expect(reminders.cancelAllCalls, 1);
    });

    test('still succeeds when cancelling reminders fails', () async {
      final auth = FakeAuthRepository();
      final reminders = FakeReminderScheduler()..error = StateError('no alarms');

      await SignoutUseCase(auth, reminders)();

      expect(auth.calls, ['signout']);
    });
  });
}
