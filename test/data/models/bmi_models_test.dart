import 'package:fitness_pro/data/models/bmi_models.dart';
import 'package:fitness_pro/domain/entities/bmi_category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('overview fromJson parses latest and history', () {
    final record = {
      'id': 3,
      'heightCm': 175.0,
      'weightKg': 68,
      'bmi': 22.2,
      'category': 'NORMAL',
      'gender': 'FEMALE',
      'ageYears': 28,
      'createdAt': '2026-11-16T10:00:00',
    };
    final overview = BmiOverviewModel.fromJson({
      'latest': record,
      'history': [record],
    }).toEntity();

    expect(overview.latest!.bmi, 22.2);
    expect(overview.latest!.weightKg, 68.0);
    expect(overview.latest!.ageYears, 28);
    expect(overview.latest!.category, BmiCategory.normal);
    expect(overview.history, hasLength(1));
  });

  test('overview with nothing saved', () {
    final overview =
        BmiOverviewModel.fromJson({'latest': null, 'history': []}).toEntity();
    expect(overview.latest, isNull);
    expect(overview.history, isEmpty);
  });

  test('request toJson', () {
    expect(
      const SaveBmiRequestModel(heightCm: 175, weightKg: 68, gender: 'MALE')
          .toJson(),
      {'heightCm': 175.0, 'weightKg': 68.0, 'gender': 'MALE'},
    );
  });
}
