import '../entities/bmi_record_entity.dart';
import '../repositories/bmi_repository.dart';

class GetBmiUseCase {
  final BmiRepository _repo;
  GetBmiUseCase(this._repo);

  Future<BmiOverviewEntity> call() => _repo.getOverview();
}
