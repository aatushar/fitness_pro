import '../../domain/entities/birth_info_entity.dart';
import '../../domain/repositories/age_repository.dart';
import '../datasources/age_remote_datasource.dart';
import '../models/birth_info_model.dart';
import '../models/save_birth_info_request_model.dart';

class AgeRepositoryImpl implements AgeRepository {
  final AgeRemoteDatasource _datasource;
  AgeRepositoryImpl(this._datasource);

  @override
  Future<BirthInfoEntity> getBirthInfo() async =>
      (await _datasource.getBirthInfo()).toEntity();

  @override
  Future<BirthInfoEntity> saveBirthInfo(DateTime birthDateTime) async =>
      (await _datasource.saveBirthInfo(SaveBirthInfoRequestModel(
        birthDateTime: birthDateTime.toIso8601String(),
      )))
          .toEntity();
}
