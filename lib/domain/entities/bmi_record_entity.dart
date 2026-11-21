import 'bmi_category.dart';

/// One saved BMI reading.
class BmiRecordEntity {
  final int id;
  final double heightCm;
  final double weightKg;
  final double bmi;
  final String gender;

  /// Age when the reading was saved; null if the user had no birth date then.
  final int? ageYears;
  final DateTime createdAt;

  const BmiRecordEntity({
    required this.id,
    required this.heightCm,
    required this.weightKg,
    required this.bmi,
    required this.gender,
    this.ageYears,
    required this.createdAt,
  });

  BmiCategory get category => BmiCategory.fromBmi(bmi);
}

/// The newest reading plus recent history (oldest first, for the graph).
class BmiOverviewEntity {
  final BmiRecordEntity? latest;
  final List<BmiRecordEntity> history;

  const BmiOverviewEntity({this.latest, this.history = const []});
}
