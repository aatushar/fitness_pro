import 'package:fitness_pro/domain/usecases/get_saved_username_usecase.dart';
import 'package:fitness_pro/domain/usecases/signin_usecase.dart';
import 'package:fitness_pro/domain/usecases/signout_usecase.dart';
import 'package:fitness_pro/domain/usecases/signup_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_repositories.dart';

void main() {
  late FakeAuthRepository repo;

  setUp(() => repo = FakeAuthRepository());

  test('SignupUseCase forwards every field to the repository', () async {
    await SignupUseCase(repo)(
      username: 'alim',
      email: 'alim@gmail.com',
      password: 'secret',
      role: ['member'],
    );

    expect(repo.calls, ['signup']);
    expect(repo.lastArgs, {
      'username': 'alim',
      'email': 'alim@gmail.com',
      'password': 'secret',
      'role': ['member'],
    });
  });

  test('SigninUseCase returns the repository user', () async {
    final user = await SigninUseCase(repo)(username: 'alim', password: 'secret');

    expect(user, same(testUser));
    expect(repo.lastArgs, {'username': 'alim', 'password': 'secret'});
  });

  test('SignoutUseCase clears the session via the repository', () async {
    await SignoutUseCase(repo)();
    expect(repo.calls, ['signout']);
  });

  test('GetSavedUsernameUseCase returns the saved name', () async {
    repo.savedUsername = 'rakib';
    expect(await GetSavedUsernameUseCase(repo)(), 'rakib');
  });
}
