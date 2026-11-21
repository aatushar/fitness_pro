import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Semicircle gauge: underweight / normal / overweight / obese bands and a
/// needle at [bmi]. Everything scales with the painted size.
class BmiGaugePainter extends CustomPainter {
  static const double _minBmi = 15;
  static const double _maxBmi = 40;

  final double bmi;
  final Color trackColor;
  final Color needleColor;

  const BmiGaugePainter({
    required this.bmi,
    required this.trackColor,
    required this.needleColor,
  });

  /// Angle for a BMI value: pi (left) .. 2*pi (right).
  static double _angle(double value) {
    final t = ((value - _minBmi) / (_maxBmi - _minBmi)).clamp(0.0, 1.0);
    return math.pi + t * math.pi;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 300;
    final stroke = 22 * scale;
    final center = Offset(size.width / 2, size.height - 8 * scale);
    final radius = size.width / 2 - stroke / 2 - 4 * scale;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final bands = [
      (_minBmi, 18.5, AppColors.info),
      (18.5, 25.0, AppColors.success),
      (25.0, 30.0, AppColors.warning),
      (30.0, _maxBmi, AppColors.danger),
    ];
    for (final (from, to, color) in bands) {
      final start = _angle(from);
      canvas.drawArc(
        rect,
        start,
        _angle(to) - start - 0.02, // thin gap between bands
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke,
      );
    }

    final needleAngle = _angle(bmi);
    final tip = Offset(
      center.dx + (radius - stroke / 2 - 4 * scale) * math.cos(needleAngle),
      center.dy + (radius - stroke / 2 - 4 * scale) * math.sin(needleAngle),
    );
    canvas.drawLine(
      center,
      tip,
      Paint()
        ..color = needleColor
        ..strokeWidth = 3 * scale
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(center, 7 * scale, Paint()..color = needleColor);
    canvas.drawCircle(center, 3.5 * scale, Paint()..color = trackColor);
  }

  @override
  bool shouldRepaint(BmiGaugePainter old) =>
      old.bmi != bmi ||
      old.trackColor != trackColor ||
      old.needleColor != needleColor;
}
