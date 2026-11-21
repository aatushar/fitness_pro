import '../entities/birth_info_entity.dart';
import '../repositories/age_repository.dart';

class SaveBirthInfoUseCase {
  final AgeRepository _repo;
  SaveBirthInfoUseCase(this._repo);

  Future<BirthInfoEntity> call(DateTime birthDateTime) =>
      _repo.saveBirthInfo(birthDateTime);
}
