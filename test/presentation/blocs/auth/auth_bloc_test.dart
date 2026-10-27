import 'package:fitness_pro/core/network/api_exception.dart';
import 'package:fitness_pro/domain/usecases/signin_usecase.dart';
import 'package:fitness_pro/domain/usecases/signout_usecase.dart';
import 'package:fitness_pro/domain/usecases/signup_usecase.dart';
import 'package:fitness_pro/presentation/blocs/auth/auth_bloc.dart';
import 'package:fitness_pro/presentation/blocs/auth/auth_event.dart';
import 'package:fitness_pro/presentation/blocs/auth/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_repositories.dart';

void main() {
  late FakeAuthRepository repo;
  late AuthBloc bloc;

  setUp(() {
    repo = FakeAuthRepository();
    bloc = AuthBloc(SignupUseCase(repo), SigninUseCase(repo), SignoutUseCase(repo));
  });

  tearDown(() => bloc.close());

  test('starts in AuthInitial', () {
    expect(bloc.state, isA<AuthInitial>());
  });

  test('SigninSubmitted → loading, then SigninSuccess with the user', () async {
    bloc.add(SigninSubmitted(username: 'alim', password: 'secret'));

    await expectLater(bloc.stream, emitsInOrder([
      isA<AuthLoading>(),
      isA<SigninSuccess>().having((s) => s.user, 'user', same(testUser)),
    ]));
  });

  test('SigninSubmitted failure → AuthFailure with the API message', () async {
    repo.error = const ApiException('Invalid username or password.');
    bloc.add(SigninSubmitted(username: 'alim', password: 'wrong'));

    await expectLater(bloc.stream, emitsInOrder([
      isA<AuthLoading>(),
      isA<AuthFailure>().having(
          (s) => s.message, 'message', 'Invalid username or password.'),
    ]));
  });

  test('unexpected errors never leak their raw text', () async {
    repo.error = StateError('internal detail');
    bloc.add(SigninSubmitted(username: 'alim', password: 'secret'));

    await expectLater(bloc.stream, emitsInOrder([
      isA<AuthLoading>(),
      isA<AuthFailure>().having((s) => s.message, 'message',
          'Something went wrong. Please try again.'),
    ]));
  });

  test('SignupSubmitted → loading, then SignupSuccess', () async {
    bloc.add(SignupSubmitted(
      username: 'alim',
      email: 'alim@gmail.com',
      password: 'secret',
      role: ['member'],
    ));

    await expectLater(bloc.stream, emitsInOrder([
      isA<AuthLoading>(),
      isA<SignupSuccess>(),
    ]));
  });

  test('SignoutRequested clears the session → SignoutSuccess', () async {
    bloc.add(SignoutRequested());

    await expectLater(bloc.stream, emits(isA<SignoutSuccess>()));
    expect(repo.calls, ['signout']);
  });
}
