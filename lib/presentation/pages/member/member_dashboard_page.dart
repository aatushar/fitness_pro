import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_palette.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/dashboard/dashboard_cards.dart';
import '../../widgets/dashboard/dashboard_header.dart';
import '../../widgets/dashboard/dashboard_scaffold.dart';
import '../../widgets/section_title.dart';

// ── Sample data — later API থেকে আসবে ─────────────────────────

const double _height     = 175;
const double _weight     = 68;
const double _goalWeight = 65;
const double _bmi        = 22.4;
const double _bodyFat    = 18.5;
const int    _daysLeft   = 23;
const int    _totalDays  = 90;
const String _planName   = 'Premium · 3 Months';
const String _startDate  = 'Oct 1, 2025';
const String _endDate    = 'Dec 31, 2025';

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

double get _progressPercent => (_totalDays - _daysLeft) / _totalDays;

// ── Page ──────────────────────────────────────────────────────

/// Member (ROLE_USER) dashboard: membership, body stats, progress
/// (T_STRENGTH_LOG), today's workout and the assigned trainer (T_TRAINER_USERS).
class MemberDashboardPage extends StatelessWidget {
  const MemberDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardScaffold(
      navItems: _navItems,
      children: [
        DashboardHeader(roleLabel: 'Premium Member', fallbackName: 'Member'),
        SizedBox(height: 20),
        _SubscriptionCard(),
        SizedBox(height: 20),
        SectionTitle('My Trainer'),
        SizedBox(height: 10),
        _MyTrainerCard(),
        SizedBox(height: 20),
        SectionTitle('Body Stats'),
        SizedBox(height: 10),
        _BmiRow(),
        SizedBox(height: 10),
        _BodyStatsRow(),
        SizedBox(height: 20),
        SectionTitle('Weight Progress'),
        SizedBox(height: 10),
        _WeightGraphCard(),
        SizedBox(height: 20),
        SectionTitle("Today's Workout"),
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
                Text('Strength coach · assigned since Oct 1',
                  style: TextStyle(fontSize: 11, color: palette.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Flexible(
            child: StatusChip(label: 'Beginner plan', tone: ChipTone.info),
          ),
        ],
      ),
    );
  }
}

// ── Subscription Card ──────────────────────────────────────────

class _SubscriptionCard extends StatelessWidget {
  const _SubscriptionCard();

  @override
  Widget build(BuildContext context) {
    const smallWhite = TextStyle(fontSize: 10, color: Colors.white54);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.planGradientStart, AppColors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(
          color: AppColors.purple.withValues(alpha: 0.3),
          blurRadius: 20, offset: const Offset(0, 8),
        )],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('MEMBERSHIP PLAN',
                    style: TextStyle(
                      fontSize: 10, fontWeight: FontWeight.w600,
                      color: Colors.white60, letterSpacing: 0.08,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(_planName,
                    style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ]),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('✓ Active',
                    style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Text.rich(TextSpan(
            children: [
              TextSpan(
                text: '$_daysLeft ',
                style: TextStyle(
                  fontSize: 32, fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              TextSpan(
                text: 'days left',
                style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w500,
                  color: Colors.white60,
                ),
              ),
            ],
          )),

          const SizedBox(height: 12),

          // Progress bar
          const Row(
            children: [
              Expanded(child: Text(_startDate, style: smallWhite)),
              Expanded(
                child: Text(_endDate,
                    textAlign: TextAlign.end, style: smallWhite),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: _progressPercent,
              minHeight: 7,
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text('${(_progressPercent * 100).toInt()}% completed',
                  style: smallWhite,
                ),
              ),
              const Expanded(
                child: Text('Renew now →',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 10, fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── BMI Row ────────────────────────────────────────────────────

class _BmiRow extends StatelessWidget {
  const _BmiRow();

  (String, Color) get _bmiStatus {
    if (_bmi < 18.5) return ('Underweight', AppColors.info);
    if (_bmi < 25)   return ('Normal', AppColors.success);
    if (_bmi < 30)   return ('Overweight', AppColors.warning);
    return ('Obese', AppColors.danger);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final (bmiText, bmiColor) = _bmiStatus;
    return IntrinsicHeight(
      child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(child: _StatCard(
          emoji: '⚖️',
          emojiBg: palette.tintPurple,
          value: _bmi.toStringAsFixed(1),
          label: 'BMI Index',
          statusText: bmiText,
          statusColor: bmiColor,
        )),
        const SizedBox(width: 10),
        Expanded(child: _StatCard(
          emoji: '💪',
          emojiBg: palette.tintGreen,
          value: '${_bodyFat.toStringAsFixed(1)}%',
          label: 'Body Fat',
          statusText: 'Healthy',
          statusColor: AppColors.success,
        )),
      ]),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String emoji;
  final Color emojiBg;
  final String value;
  final String label;
  final String statusText;
  final Color statusColor;

  const _StatCard({
    required this.emoji,
    required this.emojiBg,
    required this.value,
    required this.label,
    required this.statusText,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: emojiBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Text(emoji,
              style: const TextStyle(fontSize: 16))),
        ),
        const SizedBox(height: 10),
        Text(value,
          style: TextStyle(
            fontSize: 22, fontWeight: FontWeight.w800,
            color: palette.textPrimary, letterSpacing: -0.3,
          ),
        ),
        Text(label,
          style: TextStyle(fontSize: 11, color: palette.textMuted),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(statusText,
            style: TextStyle(
              fontSize: 9, fontWeight: FontWeight.w700,
              color: statusColor,
            ),
          ),
        ),
      ]),
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
      ('📏', '${_height.toInt()}', 'cm', 'Height'),
      ('⚖️', '${_weight.toInt()}', 'kg', 'Weight'),
      ('🎯', '${_goalWeight.toInt()}', 'kg', 'Goal'),
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
                child: Text('Last 6 Months',
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
                child: const Text('Weight (kg)',
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
                    child: Text(e.month,
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
              _GraphStat(label: 'Start', value: '74 kg', color: palette.textMuted),
              const _GraphStat(label: 'Lost', value: '↓ 6 kg', color: AppColors.success),
              const _GraphStat(label: 'Current', value: '68 kg', color: AppColors.purple),
              const _GraphStat(label: 'Goal', value: '65 kg', color: AppColors.warning),
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
                  Text(_workouts[i].name,
                    style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600,
                      color: palette.textPrimary,
                    ),
                  ),
                  Text(_workouts[i].detail,
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
