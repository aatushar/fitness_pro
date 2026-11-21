import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/format/formatters.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_palette.dart';
import '../../../domain/entities/member_subscription_entity.dart';
import '../../../domain/entities/subscription_entity.dart';
import '../../blocs/subscription/member_fees_cubit.dart';
import '../../../core/l10n/app_strings.dart';

/// Payment methods the backend accepts, with their display names.
const _methods = [
  ('CASH', 'Cash'),
  ('BKASH', 'bKash'),
  ('NAGAD', 'Nagad'),
  ('CARD', 'Card'),
  ('BANK', 'Bank'),
  ('OTHER', 'Other'),
];

const _durations = [1, 3, 6, 12];

/// Quick plans (minutes) for trying the reminders without waiting a month.
const _testMinutesOptions = [1, 2, 3];

/// Bottom sheet where the admin enters the received fee for [member].
/// Shows a snackbar on the page behind it once the subscription is active.
Future<void> showActivateSubscriptionSheet(
  BuildContext context,
  MemberSubscriptionEntity member,
) {
  final cubit = context.read<MemberFeesCubit>();
  final messenger = ScaffoldMessenger.of(context);

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    constraints: const BoxConstraints(maxWidth: 560),
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: _ActivateSheet(member: member, messenger: messenger),
    ),
  );
}

class _ActivateSheet extends StatefulWidget {
  final MemberSubscriptionEntity member;
  final ScaffoldMessengerState messenger;
  const _ActivateSheet({required this.member, required this.messenger});

  @override
  State<_ActivateSheet> createState() => _ActivateSheetState();
}

class _ActivateSheetState extends State<_ActivateSheet> {
  late final TextEditingController _amountCtrl = TextEditingController(
    text: widget.member.lastAmount == null
        ? ''
        : _plain(widget.member.lastAmount!),
  );
  final _noteCtrl = TextEditingController();
  int _months = 1;

  /// When set, a minutes-long test plan is given instead of [_months].
  int? _testMinutes;
  String _method = 'CASH';
  bool _saving = false;
  String? _error;

  static String _plain(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(2);

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  /// The date access will run until, using the same rule as the server: a
  /// member with time left keeps it, otherwise counting starts today.
  String get _previewText {
    final minutes = _testMinutes;
    if (minutes != null) {
      final until = DateTime.now().add(Duration(minutes: minutes));
      return AppStrings.t(
          context,
          'Test plan: access for $minutes ${minutes == 1 ? 'minute' : 'minutes'} (until ${formatDateTime(until)})',
          'টেস্ট প্ল্যান: $minutes মিনিটের প্রবেশাধিকার (${formatDateTime(until)} পর্যন্ত)');
    }
    final renew = widget.member.status != SubscriptionStatus.none;
    return AppStrings.t(
        context,
        'Access until ${formatDate(_accessUntil)}${renew ? ' (added after the current period)' : ''}',
        '${formatDate(_accessUntil)} পর্যন্ত প্রবেশাধিকার${renew ? ' (বর্তমান মেয়াদের পরে যোগ হবে)' : ''}');
  }

  DateTime get _accessUntil {
    final today = DateTime.now();
    final base = DateTime(today.year, today.month, today.day);
    final end = widget.member.endDate;
    final start = (end != null && end.isAfter(base)) ? end : base;
    return addMonths(start, _months);
  }

  Future<void> _submit() async {
    final amount = double.tryParse(_amountCtrl.text.trim());
    if (amount == null || amount <= 0) {
      setState(() => _error = 'Enter the amount received.'.tr(context));
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });

    final until = _accessUntil;
    final testMinutes = _testMinutes;
    final error = await context.read<MemberFeesCubit>().activate(
          userId: widget.member.userId,
          months: testMinutes == null ? _months : null,
          testMinutes: testMinutes,
          amount: amount,
          paymentMethod: _method,
          note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
        );
    if (!mounted) return;

    if (error != null) {
      setState(() {
        _saving = false;
        _error = error;
      });
      return;
    }
    Navigator.of(context).pop();
    widget.messenger.showSnackBar(SnackBar(
      content: Text(testMinutes != null
          ? AppStrings.t(
              context,
              '${widget.member.username} has a $testMinutes-minute test plan. Open the member app to see the reminders.',
              '${widget.member.username}-এর $testMinutes মিনিটের টেস্ট প্ল্যান চালু হয়েছে। রিমাইন্ডার দেখতে সদস্যের অ্যাপটি খুলুন।')
          : AppStrings.t(
              context,
              '${widget.member.username} can now use the gym until ${formatDate(until)}.',
              '${widget.member.username} এখন ${formatDate(until)} পর্যন্ত জিম ব্যবহার করতে পারবেন।')),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final renew = widget.member.status != SubscriptionStatus.none;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        20, 20, 20, 20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(renew ? 'Renew subscription'.tr(context) : 'Activate subscription'.tr(context),
            style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w800,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(widget.member.username,
            style: TextStyle(fontSize: 13, color: palette.textMuted),
          ),
          const SizedBox(height: 20),

          _label(palette, 'DURATION'.tr(context)),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final m in _durations)
                ChoiceChip(
                  label: Text(m == 1 ? '1 month'.tr(context) : AppStrings.t(context, '$m months', '$m মাস')),
                  selected: _testMinutes == null && _months == m,
                  selectedColor: AppColors.purple,
                  labelStyle: TextStyle(
                    color: _testMinutes == null && _months == m
                        ? Colors.white
                        : palette.textPrimary,
                  ),
                  onSelected: _saving
                      ? null
                      : (_) => setState(() {
                            _months = m;
                            _testMinutes = null;
                          }),
                ),
            ],
          ),
          // Only in debug builds, so a real gym can never pick it by accident.
          if (kDebugMode) ...[
            const SizedBox(height: 12),
            _label(palette, 'TEST PLAN (TRY THE REMINDERS)'.tr(context)),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final m in _testMinutesOptions)
                  ChoiceChip(
                    label: Text(m == 1 ? '1 minute'.tr(context) : AppStrings.t(context, '$m minutes', '$m মিনিট')),
                    selected: _testMinutes == m,
                    selectedColor: AppColors.warning,
                    labelStyle: TextStyle(
                      color: _testMinutes == m ? Colors.black : palette.textPrimary,
                    ),
                    onSelected: _saving
                        ? null
                        : (_) => setState(() => _testMinutes = m),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 18),

          _label(palette, 'AMOUNT RECEIVED (৳)'.tr(context)),
          TextField(
            controller: _amountCtrl,
            enabled: !_saving,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: _inputDecoration(context, '0'),
          ),
          const SizedBox(height: 18),

          _label(palette, 'PAYMENT METHOD'.tr(context)),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (value, name) in _methods)
                ChoiceChip(
                  label: Text(name.tr(context)),
                  selected: _method == value,
                  selectedColor: AppColors.purple,
                  labelStyle: TextStyle(
                    color: _method == value ? Colors.white : palette.textPrimary,
                  ),
                  onSelected: _saving ? null : (_) => setState(() => _method = value),
                ),
            ],
          ),
          const SizedBox(height: 18),

          _label(palette, 'NOTE (OPTIONAL)'.tr(context)),
          TextField(
            controller: _noteCtrl,
            enabled: !_saving,
            maxLength: 255,
            decoration: _inputDecoration(context, 'e.g. paid by the member\'s brother'.tr(context)),
          ),
          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: palette.tintPurple,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _previewText,
              style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600,
                color: palette.roleText,
              ),
            ),
          ),

          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!,
              style: const TextStyle(fontSize: 13, color: AppColors.danger),
            ),
          ],

          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: _saving ? null : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.purple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _saving
                  ? const SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white,
                      ),
                    )
                  : FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Confirm & give access'.tr(context)),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(AppPalette palette, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
          style: TextStyle(
            fontSize: 11, fontWeight: FontWeight.w700,
            color: palette.label, letterSpacing: AppStrings.spacing(0.09),
          ),
        ),
      );

  InputDecoration _inputDecoration(BuildContext context, String hint) {
    final palette = context.palette;
    OutlineInputBorder outline(Color c) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c),
        );
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 13, color: palette.textMuted),
      filled: true,
      fillColor: Theme.of(context).colorScheme.surface,
      border: outline(palette.border),
      enabledBorder: outline(palette.border),
      focusedBorder: outline(AppColors.purple),
    );
  }
}
