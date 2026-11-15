import 'package:fitness_pro/presentation/blocs/account/account_cubit.dart';
import 'package:fitness_pro/presentation/blocs/admin/admin_gyms_cubit.dart';
import 'package:fitness_pro/presentation/blocs/admin/admin_users_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../helpers/fake_repositories.dart';

void main() {
  group('AdminUsersCubit', () {
    test('load lists users and filters by role and search', () async {
      final cubit = AdminUsersCubit(FakeAdminRepository());
      await cubit.load();
      expect(cubit.state.status, LoadStatus.loaded);
      expect(cubit.state.visibleUsers.length, 2);
      cubit.setRoleFilter('Trainer');
      expect(cubit.state.visibleUsers.single.username, 'sadia');
      cubit.setRoleFilter(null);
      cubit.setSearch('RAK');
      expect(cubit.state.visibleUsers.single.username, 'rakib');
    });

    test('a failing load becomes a failure state with a message', () async {
      final cubit = AdminUsersCubit(FakeAdminRepository()..error = StateError('x'));
      await cubit.load();
      expect(cubit.state.status, LoadStatus.failure);
      expect(cubit.state.message, isNotNull);
    });

    test('setStatus calls the repository and reloads', () async {
      final repo = FakeAdminRepository();
      final cubit = AdminUsersCubit(repo);
      expect(await cubit.setStatus(1, 'INACTIVE'), isNull);
      expect(repo.calls, containsAllInOrder(['status:1:INACTIVE', 'users']));
    });
  });

  test('AdminGymsCubit save then reload', () async {
    final repo = FakeAdminRepository();
    final cubit = AdminGymsCubit(repo);
    expect(
        await cubit.save(name: 'G', email: 'g@x.com', city: 'Dhaka', phone: '1'),
        isNull);
    expect(repo.calls, containsAllInOrder(['saveGym:null:G', 'gyms']));
    expect(cubit.state.gyms.length, 1);
  });

  test('AccountCubit returns the error message when a save fails', () async {
    final cubit = AccountCubit(FakeAccountRepository()..error = StateError('x'));
    expect(await cubit.changePassword('a', 'b'), isNotNull);
  });
}
