import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_palette.dart';
import '../../../domain/entities/age_breakdown.dart';
import '../../blocs/age/age_cubit.dart';
import '../dashboard/dashboard_cards.dart';
import '../../../core/l10n/app_strings.dart';

/// Dashboard card: the user's saved birth date/time, their age with a live
/// seconds counter, and totals since birth. Needs an [AgeCubit] above it.
class AgeCalculatorCard extends StatefulWidget {
  const AgeCalculatorCard({super.key});

  @override
  State<AgeCalculatorCard> createState() => _AgeCalculatorCardState();
}

class _AgeCalculatorCardState extends State<AgeCalculatorCard> {
  Timer? _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _pick(DateTime? current) async {
    final cubit = context.read<AgeCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final savedText = 'Birth date saved'.tr(context);
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: 'Date of birth'.tr(context),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: current == null
          ? const TimeOfDay(hour: 12, minute: 0)
          : TimeOfDay.fromDateTime(current),
      helpText: 'Time of birth'.tr(context),
    );
    if (time == null) return;

    final picked =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    final error = await cubit.save(picked.isAfter(now) ? now : picked);
    messenger.showSnackBar(SnackBar(
      content: Text(error ?? savedText),
      backgroundColor: error == null ? AppColors.success : AppColors.danger,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return BlocBuilder<AgeCubit, AgeState>(
      builder: (context, state) {
        final birth = state.info?.birthDateTime;
        final saving = state.status == AgeStatus.saving;

        return SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Icon(Icons.cake_rounded,
                    color: AppColors.purple, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Age Calculator'.tr(context),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: palette.textPrimary,
                    ),
                  ),
                ),
                if (state.status == AgeStatus.loading || saving)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else if (state.status != AgeStatus.failure)
                  Flexible(
                    child: TextButton(
                      onPressed: () => _pick(birth),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(birth == null
                            ? 'Set birth date'.tr(context)
                            : 'Change'.tr(context)),
                      ),
                    ),
                  ),
              ]),
              const SizedBox(height: 12),
              if (state.status == AgeStatus.failure)
                Row(children: [
                  Expanded(
                      child: Text(
                          state.message ?? 'Could not load.'.tr(context),
                          style: TextStyle(color: palette.textMuted))),
                  TextButton(
                    onPressed: () => context.read<AgeCubit>().load(),
                    child: Text('Try again'.tr(context)),
                  ),
                ])
              else if (state.status == AgeStatus.loading && birth == null)
                const SizedBox(height: 60)
              else if (birth == null)
                Text(
                  'Add your birth date and time to see your exact age, live to the second.'
                      .tr(context),
                  style: TextStyle(fontSize: 12, color: palette.textMuted),
                )
              else
                _AgeDetails(
                  birth: birth,
                  age: AgeBreakdown.between(birth, _now),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _AgeDetails extends StatelessWidget {
  final DateTime birth;
  final AgeBreakdown age;

  const _AgeDetails({required this.birth, required this.age});

  static String _two(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final born = '${birth.day}/${birth.month}/${birth.year}  '
        '${_two(birth.hour)}:${_two(birth.minute)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.t(context, 'Born $born', 'জন্ম: $born'),
            style: TextStyle(fontSize: 11, color: palette.textMuted)),
        const SizedBox(height: 10),
        GradientHeroCard(
          child: Row(children: [
            Expanded(child: _BigNumber('${age.years}', 'Years'.tr(context))),
            Expanded(child: _BigNumber('${age.months}', 'Months'.tr(context))),
            Expanded(child: _BigNumber('${age.days}', 'Days'.tr(context))),
          ]),
        ),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(
              child: _LiveBox(
                  _two(age.hours), 'Hours'.tr(context), AppColors.info)),
          const SizedBox(width: 8),
          Expanded(
              child: _LiveBox(
                  _two(age.minutes), 'Minutes'.tr(context), AppColors.success)),
          const SizedBox(width: 8),
          Expanded(
              child: _LiveBox(
                  _two(age.seconds), 'Seconds'.tr(context), AppColors.purple)),
        ]),
        const SizedBox(height: 14),
        Text(
          'Since birth'.tr(context),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: _TotalBox('${age.totalDays}', 'days'.tr(context))),
          const SizedBox(width: 8),
          Expanded(child: _TotalBox('${age.totalHours}', 'hours'.tr(context))),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(
              child: _TotalBox('${age.totalMinutes}', 'minutes'.tr(context))),
          const SizedBox(width: 8),
          Expanded(
              child: _TotalBox('${age.totalSeconds}', 'seconds'.tr(context))),
        ]),
      ],
    );
  }
}

class _BigNumber extends StatelessWidget {
  final String value;
  final String label;
  const _BigNumber(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          AppStrings.digits(value),
          style: const TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
      Text(label, style: const TextStyle(fontSize: 11, color: Colors.white70)),
    ]);
  }
}

class _LiveBox extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _LiveBox(this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            AppStrings.digits(value),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ),
        Text(label, style: TextStyle(fontSize: 10, color: color)),
      ]),
    );
  }
}

class _TotalBox extends StatelessWidget {
  final String value;
  final String label;
  const _TotalBox(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
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
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: palette.textPrimary,
            ),
          ),
        ),
        Text(label, style: TextStyle(fontSize: 10, color: palette.textMuted)),
      ]),
    );
  }
}
