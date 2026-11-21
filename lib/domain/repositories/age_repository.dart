import '../entities/birth_info_entity.dart';

abstract class AgeRepository {
  Future<BirthInfoEntity> getBirthInfo();
  Future<BirthInfoEntity> saveBirthInfo(DateTime birthDateTime);
}
