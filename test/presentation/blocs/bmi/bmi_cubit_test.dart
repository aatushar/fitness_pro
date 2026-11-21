import 'package:fitness_pro/core/network/api_exception.dart';
import 'package:fitness_pro/domain/entities/bmi_category.dart';
import 'package:fitness_pro/domain/usecases/get_bmi_usecase.dart';
import 'package:fitness_pro/domain/usecases/save_bmi_usecase.dart';
import 'package:fitness_pro/presentation/blocs/bmi/bmi_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_repositories.dart';

void main() {
  late FakeBmiRepository repo;
  late BmiCubit cubit;

  setUp(() {
    repo = FakeBmiRepository();
    cubit = BmiCubit(GetBmiUseCase(repo), SaveBmiUseCase(repo));
  });

  tearDown(() => cubit.close());

  test('load with nothing saved → ready, no latest', () async {
    await cubit.load();
    expect(cubit.state.status, BmiStatus.ready);
    expect(cubit.state.overview!.latest, isNull);
    expect(cubit.state.overview!.history, isEmpty);
  });

  test('save → latest and history updated, returns null', () async {
    final error = await cubit.save(heightCm: 175, weightKg: 68, gender: 'MALE');
    expect(error, isNull);
    final overview = cubit.state.overview!;
    expect(overview.latest!.bmi, 22.2);
    expect(overview.latest!.category, BmiCategory.normal);
    expect(overview.history, hasLength(1));

    await cubit.save(heightCm: 175, weightKg: 80, gender: 'MALE');
    expect(cubit.state.overview!.history, hasLength(2));
    expect(cubit.state.overview!.latest!.category, BmiCategory.overweight);
  });

  test('save failure → message returned, previous overview kept', () async {
    await cubit.save(heightCm: 175, weightKg: 68, gender: 'MALE');
    repo.error = const ApiException('Weight must be between 10 and 400 kg.');

    final error =
        await cubit.save(heightCm: 175, weightKg: 500, gender: 'MALE');

    expect(error, 'Weight must be between 10 and 400 kg.');
    expect(cubit.state.overview!.history, hasLength(1));
  });

  test('load failure → failure state with a safe message', () async {
    repo.error = StateError('boom');
    await cubit.load();
    expect(cubit.state.status, BmiStatus.failure);
    expect(cubit.state.message, 'Something went wrong. Please try again.');
  });
}
