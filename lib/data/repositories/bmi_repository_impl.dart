import '../../domain/entities/bmi_record_entity.dart';
import '../../domain/repositories/bmi_repository.dart';
import '../datasources/bmi_remote_datasource.dart';
import '../models/bmi_models.dart';

class BmiRepositoryImpl implements BmiRepository {
  final BmiRemoteDatasource _datasource;
  BmiRepositoryImpl(this._datasource);

  @override
  Future<BmiOverviewEntity> getOverview() async =>
      (await _datasource.getOverview()).toEntity();

  @override
  Future<BmiOverviewEntity> save({
    required double heightCm,
    required double weightKg,
    required String gender,
  }) async =>
      (await _datasource.save(SaveBmiRequestModel(
        heightCm: heightCm,
        weightKg: weightKg,
        gender: gender,
      )))
          .toEntity();
}
