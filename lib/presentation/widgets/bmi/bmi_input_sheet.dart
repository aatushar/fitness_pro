import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_palette.dart';
import '../../../domain/entities/bmi_category.dart';
import '../../../domain/entities/bmi_record_entity.dart';
import 'bmi_card.dart' show bmiColor;
import '../../../core/l10n/app_strings.dart';

class BmiInput {
  final double heightCm;
  final double weightKg;
  final String gender; // MALE | FEMALE
  const BmiInput(this.heightCm, this.weightKg, this.gender);
}

/// Bottom sheet to enter height (feet + inches), weight and gender.
/// Returns null when dismissed.
Future<BmiInput?> showBmiInputSheet(BuildContext context,
    {BmiRecordEntity? previous}) {
  return showModalBottomSheet<BmiInput>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _BmiInputSheet(previous: previous),
  );
}

class _BmiInputSheet extends StatefulWidget {
  final BmiRecordEntity? previous;
  const _BmiInputSheet({this.previous});

  @override
  State<_BmiInputSheet> createState() => _BmiInputSheetState();
}

class _BmiInputSheetState extends State<_BmiInputSheet> {
  late final TextEditingController _feet;
  late final TextEditingController _inches;
  late final TextEditingController _weight;
  late String _gender;

  @override
  void initState() {
    super.initState();
    final p = widget.previous;
    final totalInches = p == null ? null : p.heightCm / 2.54;
    _feet = TextEditingController(
        text: totalInches == null ? '' : '${totalInches ~/ 12}');
    _inches = TextEditingController(
        text: totalInches == null
            ? ''
            : (totalInches % 12).toStringAsFixed(0));
    _weight = TextEditingController(
        text: p == null ? '' : p.weightKg.toStringAsFixed(1));
    _gender = p?.gender ?? 'MALE';
    for (final c in [_feet, _inches, _weight]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _feet.dispose();
    _inches.dispose();
    _weight.dispose();
    super.dispose();
  }

  double? get _heightCm {
    final feet = double.tryParse(_feet.text) ?? 0;
    final inches = double.tryParse(_inches.text) ?? 0;
    final cm = (feet * 12 + inches) * 2.54;
    return cm >= 50 && cm <= 260 ? cm : null;
  }

  double? get _weightKg {
    final kg = double.tryParse(_weight.text);
    return kg != null && kg >= 10 && kg <= 400 ? kg : null;
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final height = _heightCm;
    final weight = _weightKg;
    final bmi = height != null && weight != null
        ? BmiCategory.bmiOf(heightCm: height, weightKg: weight)
        : null;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Calculate BMI'.tr(context),
            style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w800,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(children: [
            for (final g in [('MALE', 'Male'.tr(context), Icons.male),
                                   ('FEMALE', 'Female'.tr(context), Icons.female)])
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: g.$1 == 'MALE' ? 8 : 0),
                  child: ChoiceChip(
                    selected: _gender == g.$1,
                    onSelected: (_) => setState(() => _gender = g.$1),
                    avatar: Icon(g.$3, size: 18),
                    label: FittedBox(
                      fit: BoxFit.scaleDown, child: Text(g.$2)),
                  ),
                ),
              ),
          ]),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: _field(_feet, 'Feet'.tr(context))),
            const SizedBox(width: 12),
            Expanded(child: _field(_inches, 'Inches'.tr(context))),
          ]),
          const SizedBox(height: 12),
          _field(_weight, 'Weight (kg)'.tr(context), decimal: true),
          const SizedBox(height: 16),
          if (bmi != null)
            Text.rich(
              TextSpan(children: [
                TextSpan(text: 'BMI '.tr(context)),
                TextSpan(
                  text: bmi.toStringAsFixed(1),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: bmiColor(BmiCategory.fromBmi(bmi)),
                  ),
                ),
                TextSpan(text: ' · ${BmiCategory.fromBmi(bmi).label}'),
              ]),
              style: TextStyle(fontSize: 14, color: palette.textPrimary),
            )
          else
            Text('Enter height 50–260 cm and weight 10–400 kg.'.tr(context),
              style: TextStyle(fontSize: 12, color: palette.textMuted)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.purple,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: height == null || weight == null
                  ? null
                  : () => Navigator.pop(
                      context, BmiInput(height, weight, _gender)),
              child: FittedBox(
                fit: BoxFit.scaleDown, child: Text('Save BMI'.tr(context))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(TextEditingController c, String label, {bool decimal = false}) =>
      TextField(
        controller: c,
        keyboardType: TextInputType.numberWithOptions(decimal: decimal),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
}
