import 'package:fitness_pro/domain/entities/bmi_category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('category boundaries', () {
    expect(BmiCategory.fromBmi(18.4), BmiCategory.underweight);
    expect(BmiCategory.fromBmi(18.5), BmiCategory.normal);
    expect(BmiCategory.fromBmi(24.9), BmiCategory.normal);
    expect(BmiCategory.fromBmi(25), BmiCategory.overweight);
    expect(BmiCategory.fromBmi(30), BmiCategory.obese);
  });

  test('bmiOf rounds to one decimal', () {
    expect(BmiCategory.bmiOf(heightCm: 175, weightKg: 68), 22.2);
    expect(BmiCategory.bmiOf(heightCm: 160, weightKg: 90), 35.2);
  });

  test('healthy weight range for 175 cm', () {
    final (lo, hi) = BmiCategory.healthyWeightRange(175);
    expect(lo, closeTo(56.7, 0.1));
    expect(hi, closeTo(76.3, 0.1));
  });
}
