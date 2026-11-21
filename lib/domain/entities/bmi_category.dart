import '../../core/l10n/app_strings.dart';

enum BmiCategory {
  underweight('Underweight'),
  normal('Normal'),
  overweight('Overweight'),
  obese('Obese');

  final String _label;

  /// Shown to the user, in the app's current language.
  String get label => _label.trNow;
  const BmiCategory(this._label);

  static BmiCategory fromBmi(double bmi) {
    if (bmi < 18.5) return underweight;
    if (bmi < 25) return normal;
    if (bmi < 30) return overweight;
    return obese;
  }

  /// BMI = kg / m², rounded to one decimal like the server does.
  static double bmiOf({required double heightCm, required double weightKg}) {
    final m = heightCm / 100;
    return (weightKg / (m * m) * 10).roundToDouble() / 10;
  }

  /// Weight range (kg) that keeps BMI in the normal band for [heightCm].
  static (double, double) healthyWeightRange(double heightCm) {
    final m = heightCm / 100;
    return (18.5 * m * m, 24.9 * m * m);
  }
}
