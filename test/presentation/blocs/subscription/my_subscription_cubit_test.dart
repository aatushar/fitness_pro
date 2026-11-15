import 'package:fitness_pro/core/network/api_exception.dart';
import 'package:fitness_pro/domain/usecases/get_my_subscription_usecase.dart';
import 'package:fitness_pro/presentation/blocs/subscription/my_subscription_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_repositories.dart';

void main() {
  late FakeSubscriptionRepository repo;
  late FakeReminderScheduler reminders;
  late MySubscriptionCubit cubit;

  setUp(() {
    repo = FakeSubscriptionRepository();
    reminders = FakeReminderScheduler();
    cubit = MySubscriptionCubit(GetMySubscriptionUseCase(repo), reminders);
  });

  tearDown(() => cubit.close());

  test('starts loading', () {
    expect(cubit.state, isA<MySubscriptionLoading>());
  });

  test('load → loaded subscription, and the phone reminders are set', () async {
    final states = <MySubscriptionState>[];
    final sub = cubit.stream.listen(states.add);

    await cubit.load();
    await sub.cancel();

    expect(states.first, isA<MySubscriptionLoading>());
    final loaded = states.last as MySubscriptionLoaded;
    expect(loaded.subscription, same(activeSubscription));
    expect(reminders.scheduled, [activeSubscription]);
  });

  test('load → failure with the user-facing message, no reminders', () async {
    repo.error = const ApiException('Cannot connect to server.');

    await cubit.load();

    final failed = cubit.state as MySubscriptionFailure;
    expect(failed.message, 'Cannot connect to server.');
    expect(reminders.scheduled, isEmpty);
  });

  test('a raw exception never reaches the UI', () async {
    repo.error = StateError('boom');

    await cubit.load();

    expect((cubit.state as MySubscriptionFailure).message,
        'Something went wrong. Please try again.');
  });

  test('a reminder problem does not turn a loaded card into an error', () async {
    reminders.error = StateError('notifications blocked');

    await cubit.load();

    expect(cubit.state, isA<MySubscriptionLoaded>());
  });
}
