import 'package:fitness_pro/domain/usecases/get_saved_username_usecase.dart';
import 'package:fitness_pro/presentation/blocs/current_user/current_user_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_repositories.dart';

void main() {
  late FakeAuthRepository repo;
  late CurrentUserCubit cubit;

  setUp(() {
    repo = FakeAuthRepository();
    cubit = CurrentUserCubit(GetSavedUsernameUseCase(repo));
  });

  tearDown(() => cubit.close());

  test('starts with no username', () {
    expect(cubit.state, isNull);
  });

  test('load emits the saved username', () async {
    repo.savedUsername = 'rakib';
    await cubit.load();
    expect(cubit.state, 'rakib');
  });

  test('load stays null when reading storage fails', () async {
    repo.error = StateError('prefs unavailable');
    await cubit.load();
    expect(cubit.state, isNull);
  });
}
