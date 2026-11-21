import 'package:fitness_pro/core/network/api_exception.dart';
import 'package:fitness_pro/domain/entities/birth_info_entity.dart';
import 'package:fitness_pro/domain/usecases/get_birth_info_usecase.dart';
import 'package:fitness_pro/domain/usecases/save_birth_info_usecase.dart';
import 'package:fitness_pro/presentation/blocs/age/age_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_repositories.dart';

void main() {
  late FakeAgeRepository repo;
  late AgeCubit cubit;

  setUp(() {
    repo = FakeAgeRepository();
    cubit = AgeCubit(GetBirthInfoUseCase(repo), SaveBirthInfoUseCase(repo));
  });

  tearDown(() => cubit.close());

  test('load with nothing saved → ready, not set', () async {
    await cubit.load();
    expect(cubit.state.status, AgeStatus.ready);
    expect(cubit.state.info!.isSet, isFalse);
  });

  test('load → the saved birth date', () async {
    repo.info = BirthInfoEntity(birthDateTime: DateTime(1995, 5, 17, 8));
    await cubit.load();
    expect(cubit.state.info!.birthDateTime, DateTime(1995, 5, 17, 8));
  });

  test('save → stored, state shows the new date, returns null', () async {
    final error = await cubit.save(DateTime(2000, 1, 2, 3, 4));
    expect(error, isNull);
    expect(repo.saved, [DateTime(2000, 1, 2, 3, 4)]);
    expect(cubit.state.status, AgeStatus.ready);
    expect(cubit.state.info!.birthDateTime, DateTime(2000, 1, 2, 3, 4));
  });

  test('save failure → message returned, previous value kept', () async {
    repo.info = BirthInfoEntity(birthDateTime: DateTime(1995, 5, 17));
    await cubit.load();
    repo.error = const ApiException('Birth date cannot be in the future.');

    final error = await cubit.save(DateTime(2030));

    expect(error, 'Birth date cannot be in the future.');
    expect(cubit.state.info!.birthDateTime, DateTime(1995, 5, 17));
  });

  test('load failure → failure state with a safe message', () async {
    repo.error = StateError('boom');
    await cubit.load();
    expect(cubit.state.status, AgeStatus.failure);
    expect(cubit.state.message, 'Something went wrong. Please try again.');
  });
}
