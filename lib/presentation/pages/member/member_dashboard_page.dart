import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_palette.dart';
import '../../blocs/age/age_cubit.dart';
import '../../blocs/bmi/bmi_cubit.dart';
import '../../blocs/notifications/notifications_cubit.dart';
import '../../blocs/subscription/my_subscription_cubit.dart';
import '../../widgets/age/age_calculator_card.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/bmi/bmi_card.dart';
import '../../widgets/dashboard/dashboard_cards.dart';
import '../../widgets/dashboard/dashboard_header.dart';
import '../../widgets/dashboard/dashboard_scaffold.dart';
import '../../widgets/subscription/member_subscription_card.dart';
import '../../widgets/section_title.dart';
import '../../../core/l10n/app_strings.dart';

// ── Sample data — later API থেকে আসবে ─────────────────────────

const double _height     = 175;
const double _weight     = 68;
const double _goalWeight = 65;

class _WeightPoint {
  final String month;
  final double weight;
  const _WeightPoint(this.month, this.weight);
}

const _weightHistory = [
  _WeightPoint('May', 74.0),
  _WeightPoint('Jun', 73.0),
  _WeightPoint('Jul', 71.5),
  _WeightPoint('Aug', 70.0),
  _WeightPoint('Sep', 69.0),
  _WeightPoint('Oct', 68.0),
];

class _Workout {
  final String icon;
  final Color color;
  final String name;
  final String detail;
  final bool done;
  const _Workout(this.icon, this.color, this.name, this.detail, this.done);
}

const _workouts = [
  _Workout('🏋️', AppColors.purple,  'Bench Press', '4 sets · 12 reps · 60 kg', true),
  _Workout('🏃', AppColors.success, 'Treadmill',   '30 mins · 6 km/h',         true),
  _Workout('💪', AppColors.info,    'Bicep Curls', '3 sets · 15 reps · 15 kg', false),
  _Workout('🧘', AppColors.warning, 'Stretching',  '15 mins cool down',        false),
];

enum _DayStatus { done, today, rest }

const _weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
const _weekStatus = [
  _DayStatus.done, _DayStatus.done, _DayStatus.done, _DayStatus.today,
  _DayStatus.rest, _DayStatus.rest, _DayStatus.rest,
];

const _navItems = [
  AppNavItem(Icons.grid_view_rounded, 'Home'),
  AppNavItem(Icons.fitness_center_rounded, 'Workout'),
  AppNavItem(Icons.calendar_month_outlined, 'Schedule'),
  AppNavItem(Icons.person_outline_rounded, 'Profile'),
];
const _trainerName = 'Johir Hasan';

// ── Page ──────────────────────────────────────────────────────

/// Member (ROLE_USER) dashboard: membership, body stats, progress
/// (T_STRENGTH_LOG), today's workout and the assigned trainer (T_TRAINER_USERS).
class MemberDashboardPage extends StatelessWidget {
  const MemberDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      navItems: _navItems,
      // Pull down to pick up a renewal the admin just recorded.
      onRefresh: () => Future.wait([
        context.read<MySubscriptionCubit>().load(),
        context.read<NotificationsCubit>().load(),
        context.read<AgeCubit>().load(),
        context.read<BmiCubit>().load(),
      ]),
      children: [
        DashboardHeader(roleLabel: 'Gym Member'.tr(context), fallbackName: 'Member'.tr(context)),
        SizedBox(height: 20),
        MemberSubscriptionCard(),
        SizedBox(height: 20),
        AgeCalculatorCard(),
        SizedBox(height: 20),
        BmiCard(),
        SizedBox(height: 20),
        SectionTitle('My Trainer'.tr(context)),
        SizedBox(height: 10),
        _MyTrainerCard(),
        SizedBox(height: 20),
        SectionTitle('Body Stats'.tr(context)),
        SizedBox(height: 10),
        _BodyStatsRow(),
        SizedBox(height: 20),
        SectionTitle('Weight Progress'.tr(context)),
        SizedBox(height: 10),
        _WeightGraphCard(),
        SizedBox(height: 20),
        SectionTitle("Today's Workout".tr(context)),
        SizedBox(height: 10),
        _WorkoutCard(),
        SizedBox(height: 10),
      ],
    );
  }
}

// ── My Trainer ─────────────────────────────────────────────────

class _MyTrainerCard extends StatelessWidget {
  const _MyTrainerCard();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return SurfaceCard(
      child: Row(
        children: [
          const InitialsAvatar(initials: 'JH', color: AppColors.info),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_trainerName,
                  style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w700,
                    color: palette.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text('Strength coach · assigned since Oct 1'.tr(context),
                  style: TextStyle(fontSize: 11, color: palette.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: StatusChip(label: 'Beginner plan'.tr(context), tone: ChipTone.info),
          ),
        ],
      ),
    );
  }
}

// ── Body Stats Row ─────────────────────────────────────────────

class _BodyStatsRow extends StatelessWidget {
  const _BodyStatsRow();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final stats = [
      ('📏', '${_height.toInt()}', 'cm'.tr(context), 'Height'.tr(context)),
      ('⚖️', '${_weight.toInt()}', 'kg'.tr(context), 'Weight'.tr(context)),
      ('🎯', '${_goalWeight.toInt()}', 'kg'.tr(context), 'Goal'.tr(context)),
    ];

    return Row(
      children: [
        for (var i = 0; i < stats.length; i++)
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i < stats.length - 1 ? 8 : 0),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: palette.border),
              ),
              child: Column(children: [
                Text(stats[i].$1, style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 6),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: stats[i].$2,
                        style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w800,
                          color: palette.textPrimary,
                        ),
                      ),
                      TextSpan(text: ' ${stats[i].$3}',
                        style: TextStyle(fontSize: 10, color: palette.textMuted),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(stats[i].$4,
                  style: TextStyle(fontSize: 9, color: palette.textMuted),
                ),
              ]),
            ),
          ),
      ],
    );
  }
}

// ── Weight Graph ───────────────────────────────────────────────

class _WeightGraphCard extends StatelessWidget {
  const _WeightGraphCard();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final weights = _weightHistory.map((e) => e.weight).toList();
    final maxW = weights.reduce(math.max);
    final minW = weights.reduce(math.min);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Last 6 Months'.tr(context),
                  style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700,
                    color: palette.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.purple.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('Weight (kg)'.tr(context),
                  style: TextStyle(
                    fontSize: 10, fontWeight: FontWeight.w600,
                    color: AppColors.purple,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Graph
          SizedBox(
            height: 100,
            width: double.infinity,
            child: CustomPaint(
              painter: _WeightGraphPainter(
                data: weights,
                minVal: minW - 2,
                maxVal: maxW + 2,
                lineColor: AppColors.purple,
                fillColor: AppColors.purple.withValues(
                  alpha: context.isDarkTheme ? 0.2 : 0.1,
                ),
                dotBorderColor: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Month labels
          Row(
            children: [
              for (final e in _weightHistory)
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(e.month.tr(context),
                      style: TextStyle(fontSize: 9, color: palette.textMuted),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Summary
          Row(
            children: [
              _GraphStat(label: 'Start'.tr(context), value: '74 kg'.tr(context), color: palette.textMuted),
              _GraphStat(label: 'Lost'.tr(context), value: '↓ 6 kg'.tr(context), color: AppColors.success),
              _GraphStat(label: 'Current'.tr(context), value: '68 kg'.tr(context), color: AppColors.purple),
              _GraphStat(label: 'Goal'.tr(context), value: '65 kg'.tr(context), color: AppColors.warning),
            ],
          ),
        ],
      ),
    );
  }
}

class _GraphStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _GraphStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: [
        Text(value,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13, fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 9, color: context.palette.textMuted),
        ),
      ]),
    );
  }
}

// ── Workout Card ───────────────────────────────────────────────

class _WorkoutCard extends StatelessWidget {
  const _WorkoutCard();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isDark = context.isDarkTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.border),
      ),
      child: Column(children: [
        // Day chips
        Row(
          children: List.generate(_weekDays.length, (i) {
            final (bg, fg) = switch (_weekStatus[i]) {
              _DayStatus.today => (AppColors.purple, Colors.white),
              _DayStatus.done  => (palette.tintPurple, AppColors.purple),
              _DayStatus.rest  => (palette.surfaceAlt, palette.textMuted),
            };
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i < _weekDays.length - 1 ? 5 : 0),
                padding: const EdgeInsets.symmetric(vertical: 7),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_weekDays[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w700,
                    color: fg,
                  ),
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 14),

        // Workout items
        for (var i = 0; i < _workouts.length; i++) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: _workouts[i].color.withValues(
                    alpha: isDark ? 0.2 : 0.12,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(_workouts[i].icon,
                      style: const TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_workouts[i].name.tr(context),
                    style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600,
                      color: palette.textPrimary,
                    ),
                  ),
                  Text(_workouts[i].detail.tr(context),
                    style: TextStyle(fontSize: 10, color: palette.textMuted),
                  ),
                ],
              )),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  _workouts[i].done ? '✅' : '⏳',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ]),
          ),
          if (i < _workouts.length - 1)
            Divider(height: 1, color: palette.border),
        ],
      ]),
    );
  }
}

// ── Custom Graph Painter ───────────────────────────────────────

class _WeightGraphPainter extends CustomPainter {
  final List<double> data;
  final double minVal;
  final double maxVal;
  final Color lineColor;
  final Color fillColor;
  final Color dotBorderColor;

  _WeightGraphPainter({
    required this.data,
    required this.minVal,
    required this.maxVal,
    required this.lineColor,
    required this.fillColor,
    required this.dotBorderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    // Stroke and dot sizes were designed for a 100px-tall graph.
    final scale = size.shortestSide / 100;
    final range = maxVal - minVal;
    final points = <Offset>[
      for (var i = 0; i < data.length; i++)
        Offset(
          i / (data.length - 1) * size.width,
          size.height - ((data[i] - minVal) / range * size.height),
        ),
    ];

    // Fill
    final fillPath = Path()..moveTo(points.first.dx, size.height);
    for (final p in points) {
      fillPath.lineTo(p.dx, p.dy);
    }
    fillPath
      ..lineTo(points.last.dx, size.height)
      ..close();
    canvas.drawPath(fillPath, Paint()..color = fillColor);

    // Line
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.5 * scale
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final midX = (points[i - 1].dx + points[i].dx) / 2;
      linePath.cubicTo(
        midX, points[i - 1].dy, midX, points[i].dy,
        points[i].dx, points[i].dy,
      );
    }
    canvas.drawPath(linePath, linePaint);

    // Dots
    final dotRadius = 3.5 * scale;
    final dotFill = Paint()..color = lineColor;
    final dotBorder = Paint()
      ..color = dotBorderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * scale;
    for (final p in points) {
      canvas.drawCircle(p, dotRadius, dotFill);
      canvas.drawCircle(p, dotRadius, dotBorder);
    }
  }

  @override
  bool shouldRepaint(_WeightGraphPainter old) =>
      old.data != data ||
      old.lineColor != lineColor ||
      old.fillColor != fillColor ||
      old.dotBorderColor != dotBorderColor;
}
