import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_palette.dart';
import '../../../domain/entities/age_breakdown.dart';
import '../../../domain/entities/bmi_category.dart';
import '../../../domain/entities/bmi_record_entity.dart';
import '../../blocs/age/age_cubit.dart';
import '../../blocs/bmi/bmi_cubit.dart';
import '../dashboard/dashboard_cards.dart';
import 'bmi_gauge.dart';
import 'bmi_graph.dart';
import 'bmi_input_sheet.dart';
import '../../../core/l10n/app_strings.dart';

Color bmiColor(BmiCategory c) => switch (c) {
      BmiCategory.underweight => AppColors.info,
      BmiCategory.normal => AppColors.success,
      BmiCategory.overweight => AppColors.warning,
      BmiCategory.obese => AppColors.danger,
    };

/// Dashboard card: latest BMI with a gauge, the user's age (from the Age
/// Calculator), healthy weight range and a graph of saved readings.
/// Needs a [BmiCubit] and an [AgeCubit] above it.
class BmiCard extends StatelessWidget {
  const BmiCard({super.key});

  Future<void> _openSheet(BuildContext context, BmiRecordEntity? latest) async {
    final cubit = context.read<BmiCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final savedText = 'BMI saved'.tr(context);
    final input = await showBmiInputSheet(context, previous: latest);
    if (input == null) return;
    final error = await cubit.save(
      heightCm: input.heightCm,
      weightKg: input.weightKg,
      gender: input.gender,
    );
    messenger.showSnackBar(SnackBar(
      content: Text(error ?? savedText),
      backgroundColor: error == null ? AppColors.success : AppColors.danger,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return BlocBuilder<BmiCubit, BmiState>(
      builder: (context, state) {
        final latest = state.overview?.latest;
        final history = state.overview?.history ?? const <BmiRecordEntity>[];
        final busy = state.status == BmiStatus.loading ||
            state.status == BmiStatus.saving;

        return SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Icon(Icons.monitor_weight_rounded,
                    color: AppColors.purple, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'BMI'.tr(context),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: palette.textPrimary,
                    ),
                  ),
                ),
                if (busy)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else if (state.status != BmiStatus.failure)
                  Flexible(
                    child: TextButton(
                      onPressed: () => _openSheet(context, latest),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(latest == null
                            ? 'Calculate'.tr(context)
                            : 'Update'.tr(context)),
                      ),
                    ),
                  ),
              ]),
              const SizedBox(height: 12),
              if (state.status == BmiStatus.failure)
                Row(children: [
                  Expanded(
                      child: Text(
                          state.message ?? 'Could not load.'.tr(context),
                          style: TextStyle(color: palette.textMuted))),
                  TextButton(
                    onPressed: () => context.read<BmiCubit>().load(),
                    child: Text('Try again'.tr(context)),
                  ),
                ])
              else if (latest == null && state.status == BmiStatus.loading)
                const SizedBox(height: 60)
              else if (latest == null)
                Text(
                  'Enter your height and weight to see your BMI and track it over time.'
                      .tr(context),
                  style: TextStyle(fontSize: 12, color: palette.textMuted),
                )
              else
                _BmiDetails(latest: latest, history: history),
            ],
          ),
        );
      },
    );
  }
}

class _BmiDetails extends StatelessWidget {
  final BmiRecordEntity latest;
  final List<BmiRecordEntity> history;

  const _BmiDetails({required this.latest, required this.history});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final category = latest.category;
    final color = bmiColor(category);
    final (minKg, maxKg) = BmiCategory.healthyWeightRange(latest.heightCm);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Flexible(
            child: Text.rich(
              TextSpan(children: [
                TextSpan(
                  text: AppStrings.digits(latest.bmi.toStringAsFixed(1)),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                TextSpan(
                  text: '  kg/m²',
                  style: TextStyle(fontSize: 11, color: palette.textMuted),
                ),
              ]),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              category.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ]),
        const SizedBox(height: 8),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: AspectRatio(
              aspectRatio: 2,
              child: CustomPaint(
                painter: BmiGaugePainter(
                  bmi: latest.bmi,
                  trackColor: palette.surfaceAlt,
                  needleColor: palette.textPrimary,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _AgeLine(fallbackYears: latest.ageYears),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(
              child: _InfoBox(
                  '${latest.heightCm.toStringAsFixed(0)} ${'cm'.tr(context)}',
                  'Height'.tr(context))),
          const SizedBox(width: 8),
          Expanded(
              child: _InfoBox(
                  '${latest.weightKg.toStringAsFixed(1)} ${'kg'.tr(context)}',
                  'Weight'.tr(context))),
          const SizedBox(width: 8),
          Expanded(
              child: _InfoBox(
                  '${minKg.toStringAsFixed(0)}–${maxKg.toStringAsFixed(0)} kg',
                  'Healthy range'.tr(context))),
        ]),
        const SizedBox(height: 16),
        Text(
          'BMI progress'.tr(context),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        if (history.length < 2)
          Text('Save another reading later to see your BMI graph.'.tr(context),
              style: TextStyle(fontSize: 11, color: palette.textMuted))
        else
          BmiGraph(history: history),
      ],
    );
  }
}

/// Age comes from the Age Calculator's birth date; older readings fall back to
/// the age stored with the reading.
class _AgeLine extends StatelessWidget {
  final int? fallbackYears;
  const _AgeLine({this.fallbackYears});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return BlocBuilder<AgeCubit, AgeState>(
      builder: (context, state) {
        final birth = state.info?.birthDateTime;
        final years = birth != null
            ? AgeBreakdown.between(birth, DateTime.now()).years
            : fallbackYears;
        return Row(children: [
          Icon(Icons.cake_outlined, size: 14, color: palette.textMuted),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              years == null
                  ? 'Age: set your birth date in the Age Calculator'.tr(context)
                  : AppStrings.t(
                      context, 'Age: $years years', 'বয়স: $years বছর'),
              style: TextStyle(fontSize: 11, color: palette.textMuted),
            ),
          ),
        ]);
      },
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String value;
  final String label;
  const _InfoBox(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: palette.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.border),
      ),
      child: Column(children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            AppStrings.digits(value),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: palette.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(label,
              style: TextStyle(fontSize: 10, color: palette.textMuted)),
        ),
      ]),
    );
  }
}
