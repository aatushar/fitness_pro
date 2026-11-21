import '../entities/bmi_record_entity.dart';

abstract class BmiRepository {
  Future<BmiOverviewEntity> getOverview();
  Future<BmiOverviewEntity> save({
    required double heightCm,
    required double weightKg,
    required String gender,
  });
}
