import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// The post-login hero: a glowing progress ring around a barbell that is
/// pressed up and down while a new plate slides on with every rep, and a
/// heartbeat line racing underneath.
///
/// * [press] 0 (bar low) → 1 (bar locked out overhead).
/// * [progress] 0 → 1 over the whole welcome; fills the ring.
/// * [plates] pairs of plates on the bar (1–4); the newest slides in by
///   [plateIn] (0 → 1).
/// Everything is drawn in a unit square and scaled by the painted width.
class LifterPainter extends CustomPainter {
  final double press;
  final double progress;
  final int plates;
  final double plateIn;

  const LifterPainter({
    required this.press,
    required this.progress,
    required this.plates,
    required this.plateIn,
  });

  static const _plateColors = [
    AppColors.purpleDeep,
    AppColors.purple,
    AppColors.purpleLight,
    AppColors.metalLight,
  ];
  static const _plateHeights = [0.34, 0.29, 0.24, 0.19];

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width);
    _ring(canvas);
    _disc(canvas);
    _burst(canvas);
    _heartbeat(canvas);
    _barbell(canvas);
    canvas.restore();
  }

  // ── Ring and disc ────────────────────────────────────────────────────

  void _ring(Canvas canvas) {
    const c = Offset(0.5, 0.5);
    final rect = Rect.fromCircle(center: c, radius: 0.47);
    canvas.drawCircle(
      c, 0.47,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.018
        ..color = Colors.white.withValues(alpha: 0.08),
    );
    if (progress <= 0) return;
    final sweep = 2 * math.pi * progress.clamp(0.0, 1.0);
    final shader = const SweepGradient(
      colors: [AppColors.purple, AppColors.purpleLight, AppColors.purple],
      transform: GradientRotation(-math.pi / 2),
    ).createShader(rect);
    // Soft glow under the arc, then the crisp arc on top.
    canvas.drawArc(
      rect, -math.pi / 2, sweep, false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.03
        ..strokeCap = StrokeCap.round
        ..shader = shader
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.014),
    );
    canvas.drawArc(
      rect, -math.pi / 2, sweep, false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.018
        ..strokeCap = StrokeCap.round
        ..shader = shader,
    );
  }

  void _disc(Canvas canvas) {
    final r = Rect.fromCircle(center: const Offset(0.5, 0.5), radius: 0.425);
    canvas.drawCircle(
      const Offset(0.5, 0.5), 0.425,
      Paint()
        ..shader = RadialGradient(colors: [
          AppColors.gymBgTop.withValues(alpha: 0.95),
          AppColors.gymBgBottom.withValues(alpha: 0.95),
        ]).createShader(r),
    );
    canvas.drawCircle(
      const Offset(0.5, 0.5), 0.425,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.004
        ..color = Colors.white.withValues(alpha: 0.12),
    );
  }

  /// A flash behind the bar when it locks out overhead.
  void _burst(Canvas canvas) {
    final k = ((press - 0.85) / 0.15).clamp(0.0, 1.0);
    if (k <= 0) return;
    final c = Offset(0.5, _barY);
    final r = Rect.fromCircle(center: c, radius: 0.34);
    canvas.drawCircle(
      c, 0.34,
      Paint()
        ..shader = RadialGradient(colors: [
          AppColors.purpleLight.withValues(alpha: 0.5 * k),
          AppColors.purpleLight.withValues(alpha: 0),
        ]).createShader(r),
    );
  }

  // ── Heartbeat ────────────────────────────────────────────────────────

  void _heartbeat(Canvas canvas) {
    const base = 0.83;
    const left = 0.2;
    const right = 0.8;
    const period = 0.2;
    final phase = progress * 1.6;
    final path = Path();
    for (var x = left; x <= right; x += 0.004) {
      final u = (((x - phase) % period) + period) % period / period;
      final y = base - 0.07 * _beat(u);
      x == left ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.007
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..shader = LinearGradient(colors: [
          AppColors.purpleLight.withValues(alpha: 0),
          AppColors.purpleLight,
          AppColors.purpleLight.withValues(alpha: 0),
        ]).createShader(const Rect.fromLTRB(left, 0.7, right, 0.9)),
    );
  }

  /// One ECG beat over u in 0..1: flat, small dip, tall spike, undershoot.
  static double _beat(double u) {
    if (u < 0.30) return 0;
    if (u < 0.34) return -0.25 * ((u - 0.30) / 0.04);
    if (u < 0.40) return -0.25 + 1.25 * ((u - 0.34) / 0.06);
    if (u < 0.46) return 1.0 - 1.5 * ((u - 0.40) / 0.06);
    if (u < 0.52) return -0.5 + 0.5 * ((u - 0.46) / 0.06);
    return 0;
  }

  // ── Barbell ──────────────────────────────────────────────────────────

  double get _barY => 0.62 - 0.26 * press;

  void _barbell(Canvas canvas) {
    final y = _barY;
    final count = plates.clamp(0, 4);

    // Bar and sleeves.
    _chrome(canvas, Rect.fromLTRB(0.13, y - 0.011, 0.87, y + 0.011), 0.011);
    for (final side in [-1.0, 1.0]) {
      final a = 0.5 + side * 0.31;
      final b = 0.5 + side * 0.40;
      _chrome(
        canvas,
        Rect.fromLTRB(math.min(a, b), y - 0.019, math.max(a, b), y + 0.019),
        0.012,
      );
    }

    // Plates, innermost first; the newest slides in from the outside.
    for (var i = 0; i < count; i++) {
      final isNew = i == count - 1;
      final t = isNew ? Curves.easeOutCubic.transform(plateIn) : 1.0;
      for (final side in [-1.0, 1.0]) {
        final cx = 0.5 + side * (0.285 + i * 0.037 + (1 - t) * 0.16);
        _plate(canvas, Offset(cx, y), i, t);
      }
    }
    // Collars.
    for (final side in [-1.0, 1.0]) {
      final cx = 0.5 + side * (0.285 + count * 0.037 + 0.012);
      _chrome(
        canvas,
        Rect.fromCenter(center: Offset(cx, y), width: 0.016, height: 0.044),
        0.006,
      );
    }
  }

  void _plate(Canvas canvas, Offset c, int index, double alpha) {
    final h = _plateHeights[index];
    final color = _plateColors[index];
    final r = RRect.fromRectAndRadius(
      Rect.fromCenter(center: c, width: 0.032, height: h),
      const Radius.circular(0.012),
    );
    canvas.drawRRect(
      r,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(color, Colors.white, 0.35)!.withValues(alpha: alpha),
            color.withValues(alpha: alpha),
            Color.lerp(color, Colors.black, 0.45)!.withValues(alpha: alpha),
          ],
        ).createShader(r.outerRect),
    );
    canvas.drawRRect(
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.003
        ..color = Colors.white.withValues(alpha: 0.35 * alpha),
    );
    // Shine stripe.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(c.dx - 0.011, c.dy - h * 0.4, 0.004, h * 0.8),
        const Radius.circular(0.002),
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.28 * alpha),
    );
    // Hub.
    canvas.drawCircle(
      c, 0.008,
      Paint()..color = AppColors.metalDark.withValues(alpha: alpha),
    );
  }

  void _chrome(Canvas canvas, Rect r, double radius) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(r, Radius.circular(radius)),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.metalLight,
            AppColors.barMetal,
            AppColors.metalDark,
          ],
        ).createShader(r),
    );
  }

  @override
  bool shouldRepaint(LifterPainter old) =>
      old.press != press ||
      old.progress != progress ||
      old.plates != plates ||
      old.plateIn != plateIn;
}
