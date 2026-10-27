import 'package:fitness_pro/domain/usecases/get_profile_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_repositories.dart';

void main() {
  test('GetProfileUseCase returns the repository profile', () async {
    final repo = FakeProfileRepository();

    final profile = await GetProfileUseCase(repo)();

    expect(profile, same(testProfile));
    expect(repo.calls, 1);
  });
}
