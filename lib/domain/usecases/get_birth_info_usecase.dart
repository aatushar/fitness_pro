import '../entities/birth_info_entity.dart';
import '../repositories/age_repository.dart';

class GetBirthInfoUseCase {
  final AgeRepository _repo;
  GetBirthInfoUseCase(this._repo);

  Future<BirthInfoEntity> call() => _repo.getBirthInfo();
}
