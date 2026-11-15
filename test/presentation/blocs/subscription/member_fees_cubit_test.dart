import 'package:fitness_pro/core/network/api_exception.dart';
import 'package:fitness_pro/domain/entities/member_subscription_entity.dart';
import 'package:fitness_pro/domain/entities/subscription_entity.dart';
import 'package:fitness_pro/domain/usecases/activate_subscription_usecase.dart';
import 'package:fitness_pro/domain/usecases/get_member_subscriptions_usecase.dart';
import 'package:fitness_pro/presentation/blocs/subscription/member_fees_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_repositories.dart';

MemberSubscriptionEntity _member(
  int id,
  String name,
  SubscriptionStatus status, {
  String? phone,
}) =>
    MemberSubscriptionEntity(
      userId: id,
      username: name,
      email: '$name@gym.test',
      phone: phone,
      status: status,
    );

void main() {
  late FakeSubscriptionRepository repo;
  late MemberFeesCubit cubit;

  setUp(() {
    repo = FakeSubscriptionRepository()
      ..members = [
        _member(1, 'rakib', SubscriptionStatus.expired, phone: '01711111111'),
        _member(2, 'sadia', SubscriptionStatus.active),
        _member(3, 'mehedi', SubscriptionStatus.none),
      ];
    cubit = MemberFeesCubit(
      GetMemberSubscriptionsUseCase(repo),
      ActivateSubscriptionUseCase(repo),
    );
  });

  tearDown(() => cubit.close());

  test('starts loading with nothing listed', () {
    expect(cubit.state.status, MemberFeesStatus.loading);
    expect(cubit.state.members, isEmpty);
  });

  test('load → loaded members and summary', () async {
    await cubit.load();

    expect(cubit.state.status, MemberFeesStatus.loaded);
    expect(cubit.state.members, hasLength(3));
    expect(cubit.state.summary, same(testSummary));
  });

  test('load failure → failure state with the message', () async {
    repo.error = const ApiException('Access denied.');

    await cubit.load();

    expect(cubit.state.status, MemberFeesStatus.failure);
    expect(cubit.state.message, 'Access denied.');
  });

  test('a failed refresh keeps the members already on screen', () async {
    await cubit.load();
    repo.error = const ApiException('Cannot connect to server.');

    await cubit.load();

    expect(cubit.state.status, MemberFeesStatus.failure);
    expect(cubit.state.members, hasLength(3));
  });

  test('filter shows only members in that status; null shows all', () async {
    await cubit.load();

    cubit.setFilter(SubscriptionStatus.expired);
    expect(cubit.state.visibleMembers.map((m) => m.username), ['rakib']);

    cubit.setFilter(null);
    expect(cubit.state.visibleMembers, hasLength(3));
  });

  test('search matches username, email and phone, ignoring case', () async {
    await cubit.load();

    cubit.setSearch('SAD');
    expect(cubit.state.visibleMembers.map((m) => m.username), ['sadia']);

    cubit.setSearch('01711');
    expect(cubit.state.visibleMembers.map((m) => m.username), ['rakib']);

    cubit.setSearch('@gym.test');
    expect(cubit.state.visibleMembers, hasLength(3));

    cubit.setSearch('nobody');
    expect(cubit.state.visibleMembers, isEmpty);
  });

  test('filter and search combine', () async {
    await cubit.load();

    cubit.setFilter(SubscriptionStatus.active);
    cubit.setSearch('rakib');

    expect(cubit.state.visibleMembers, isEmpty);
  });

  test('activate → null (success) and the list is reloaded', () async {
    await cubit.load();
    final callsBefore = repo.membersCalls;

    final error = await cubit.activate(
      userId: 1,
      months: 1,
      amount: 1500,
      paymentMethod: 'CASH',
    );

    expect(error, isNull);
    expect(repo.lastActivation['userId'], 1);
    expect(repo.membersCalls, callsBefore + 1);
  });

  test('activate failure → the message, and the list is not reloaded', () async {
    await cubit.load();
    final callsBefore = repo.membersCalls;
    repo.error = const ApiException('This member belongs to a different gym.');

    final error = await cubit.activate(
      userId: 1,
      months: 1,
      amount: 1500,
      paymentMethod: 'CASH',
    );

    expect(error, 'This member belongs to a different gym.');
    expect(repo.membersCalls, callsBefore);
  });
}
