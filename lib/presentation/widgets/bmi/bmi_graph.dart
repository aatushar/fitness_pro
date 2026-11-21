import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_palette.dart';
import '../../../domain/entities/bmi_category.dart';
import '../../../domain/entities/bmi_record_entity.dart';
import 'bmi_card.dart' show bmiColor;
import '../../../core/l10n/app_strings.dart';

/// Line graph of saved BMI readings (oldest first). The healthy band
/// (18.5–25) is shaded and each dot takes the colour of its BMI category.
class BmiGraph extends StatelessWidget {
  final List<BmiRecordEntity> history;
  const BmiGraph({super.key, required this.history});

  static String _date(DateTime d) => '${d.day}/${d.month}/${d.year % 100}';

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final values = [for (final r in history) r.bmi];
    final dotColors = [for (final r in history) bmiColor(r.category)];

    return Column(children: [
      SizedBox(
        height: 120,
        width: double.infinity,
        child: CustomPaint(
          painter: _BmiGraphPainter(
            values: values,
            dotColors: dotColors,
            lineColor: AppColors.purple,
            bandColor: AppColors.success.withValues(alpha: 0.12),
            gridColor: palette.border,
            dotBorderColor: Theme.of(context).colorScheme.surface,
          ),
        ),
      ),
      const SizedBox(height: 6),
      Row(children: [
        Expanded(
          child: Text(_date(history.first.createdAt),
            style: TextStyle(fontSize: 10, color: palette.textMuted)),
        ),
        Expanded(
          child: Text(_date(history.last.createdAt),
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 10, color: palette.textMuted)),
        ),
      ]),
      const SizedBox(height: 6),
      Row(children: [
        _Stat('First'.tr(context), values.first.toStringAsFixed(1), palette.textMuted),
        _Stat(
          'Change'.tr(context),
          '${values.last - values.first >= 0 ? '+' : ''}'
              '${(values.last - values.first).toStringAsFixed(1)}',
          AppColors.purple,
        ),
        _Stat('Latest'.tr(context), values.last.toStringAsFixed(1),
            bmiColor(BmiCategory.fromBmi(values.last))),
      ]),
    ]);
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _Stat(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: [
        Text(value,
          style: TextStyle(
            fontSize: 13, fontWeight: FontWeight.w700, color: color,
          ),
        ),
        Text(label,
          style: TextStyle(fontSize: 9, color: context.palette.textMuted)),
      ]),
    );
  }
}

class _BmiGraphPainter extends CustomPainter {
  final List<double> values;
  final List<Color> dotColors;
  final Color lineColor;
  final Color bandColor;
  final Color gridColor;
  final Color dotBorderColor;

  _BmiGraphPainter({
    required this.values,
    required this.dotColors,
    required this.lineColor,
    required this.bandColor,
    required this.gridColor,
    required this.dotBorderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;

    final scale = size.height / 120;
    var lo = values.reduce((a, b) => a < b ? a : b);
    var hi = values.reduce((a, b) => a > b ? a : b);
    // Always keep the healthy band and a little margin in view.
    lo = (lo < 17 ? lo : 17) - 1;
    hi = (hi > 26 ? hi : 26) + 1;
    double y(double v) => size.height - (v - lo) / (hi - lo) * size.height;

    // Healthy band 18.5–25.
    canvas.drawRect(
      Rect.fromLTRB(0, y(25), size.width, y(18.5)),
      Paint()..color = bandColor,
    );
    final grid = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (final level in [18.5, 25.0, 30.0]) {
      if (level > lo && level < hi) {
        canvas.drawLine(Offset(0, y(level)), Offset(size.width, y(level)), grid);
      }
    }

    final points = [
      for (var i = 0; i < values.length; i++)
        Offset(i / (values.length - 1) * size.width, y(values[i])),
    ];

    final line = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final midX = (points[i - 1].dx + points[i].dx) / 2;
      line.cubicTo(midX, points[i - 1].dy, midX, points[i].dy,
          points[i].dx, points[i].dy);
    }
    canvas.drawPath(
      line,
      Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5 * scale
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    final radius = 4 * scale;
    for (var i = 0; i < points.length; i++) {
      canvas.drawCircle(points[i], radius, Paint()..color = dotColors[i]);
      canvas.drawCircle(
        points[i],
        radius,
        Paint()
          ..color = dotBorderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5 * scale,
      );
    }
  }

  @override
  bool shouldRepaint(_BmiGraphPainter old) =>
      old.values != values ||
      old.dotColors != dotColors ||
      old.lineColor != lineColor ||
      old.bandColor != bandColor ||
      old.gridColor != gridColor ||
      old.dotBorderColor != dotBorderColor;
}
