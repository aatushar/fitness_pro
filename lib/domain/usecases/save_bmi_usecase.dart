import '../entities/bmi_record_entity.dart';
import '../repositories/bmi_repository.dart';

class SaveBmiUseCase {
  final BmiRepository _repo;
  SaveBmiUseCase(this._repo);

  Future<BmiOverviewEntity> call({
    required double heightCm,
    required double weightKg,
    required String gender,
  }) =>
      _repo.save(heightCm: heightCm, weightKg: weightKg, gender: gender);
}
