import 'package:fitness_pro/core/network/api_exception.dart';
import 'package:fitness_pro/domain/usecases/get_profile_usecase.dart';
import 'package:fitness_pro/presentation/blocs/profile/profile_bloc.dart';
import 'package:fitness_pro/presentation/blocs/profile/profile_event.dart';
import 'package:fitness_pro/presentation/blocs/profile/profile_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_repositories.dart';

void main() {
  late FakeProfileRepository repo;
  late ProfileBloc bloc;

  setUp(() {
    repo = FakeProfileRepository();
    bloc = ProfileBloc(GetProfileUseCase(repo));
  });

  tearDown(() => bloc.close());

  test('LoadProfile → loading, then ProfileLoaded', () async {
    bloc.add(LoadProfile());

    await expectLater(bloc.stream, emitsInOrder([
      isA<ProfileLoading>(),
      isA<ProfileLoaded>().having((s) => s.profile, 'profile', same(testProfile)),
    ]));
  });

  test('LoadProfile failure → ProfileFailure with the API message', () async {
    repo.error = const ApiException('Session expired. Please sign in again.');
    bloc.add(LoadProfile());

    await expectLater(bloc.stream, emitsInOrder([
      isA<ProfileLoading>(),
      isA<ProfileFailure>().having((s) => s.message, 'message',
          'Session expired. Please sign in again.'),
    ]));
  });
}
