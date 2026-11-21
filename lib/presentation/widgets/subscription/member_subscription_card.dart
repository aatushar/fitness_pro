import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/format/formatters.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/subscription_entity.dart';
import '../../blocs/subscription/my_subscription_cubit.dart';
import '../../../core/l10n/app_strings.dart';

/// The member dashboard's hero card: how long the gym subscription lasts, or
/// that it has expired and the fee must be paid. Needs a [MySubscriptionCubit].
class MemberSubscriptionCard extends StatelessWidget {
  const MemberSubscriptionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MySubscriptionCubit, MySubscriptionState>(
      builder: (context, state) => switch (state) {
        MySubscriptionLoading() => const _CardShell(
            gradient: _activeGradient,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 28),
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          ),
        MySubscriptionFailure(:final message) => _CardShell(
            gradient: _activeGradient,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('MEMBERSHIP PLAN'.tr(context), style: _captionStyle),
                const SizedBox(height: 8),
                Text(message,
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => context.read<MySubscriptionCubit>().load(),
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  child: Text('Try again'.tr(context)),
                ),
              ],
            ),
          ),
        MySubscriptionLoaded(:final subscription) =>
          _SubscriptionDetails(subscription: subscription),
      },
    );
  }
}

const _activeGradient = [AppColors.planGradientStart, AppColors.purple];
const _expiredGradient = [AppColors.expiredGradientStart, AppColors.danger];

TextStyle get _captionStyle => TextStyle(
  fontSize: 10, fontWeight: FontWeight.w600,
  color: Colors.white60, letterSpacing: AppStrings.spacing(0.08),
);
const _smallWhite = TextStyle(fontSize: 10, color: Colors.white54);

class _CardShell extends StatelessWidget {
  final List<Color> gradient;
  final Widget child;
  const _CardShell({required this.gradient, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(
          color: gradient.last.withValues(alpha: 0.3),
          blurRadius: 20, offset: const Offset(0, 8),
        )],
      ),
      child: child,
    );
  }
}

class _SubscriptionDetails extends StatefulWidget {
  final SubscriptionEntity subscription;
  const _SubscriptionDetails({required this.subscription});

  @override
  State<_SubscriptionDetails> createState() => _SubscriptionDetailsState();
}

class _SubscriptionDetailsState extends State<_SubscriptionDetails> {
  Timer? _ticker;
  DateTime _now = DateTime.now();

  SubscriptionEntity get subscription => widget.subscription;

  @override
  void initState() {
    super.initState();
    _startTickerIfNeeded();
  }

  @override
  void didUpdateWidget(_SubscriptionDetails old) {
    super.didUpdateWidget(old);
    _ticker?.cancel();
    _startTickerIfNeeded();
  }

  /// A minute-long test plan counts down live; when time is up, ask the server
  /// again so the card flips to "expired".
  void _startTickerIfNeeded() {
    final end = subscription.expiresAt;
    if (end == null || !subscription.hasAccess) return;
    _now = DateTime.now();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      final now = DateTime.now();
      if (!now.isBefore(end)) {
        timer.cancel();
        context.read<MySubscriptionCubit>().load();
        return;
      }
      setState(() => _now = now);
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  String get _countdown {
    final left = subscription.expiresAt!.difference(_now);
    final seconds = left.isNegative ? 0 : left.inSeconds + 1;
    final m = seconds ~/ 60;
    final sec = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$sec';
  }

  String get _planName {
    final minutes = subscription.planMinutes;
    if (minutes != null) {
      return AppStrings.t(
          context,
          minutes == 1 ? '1 minute test plan' : '$minutes minutes test plan',
          '$minutes মিনিটের টেস্ট প্ল্যান');
    }
    final months = subscription.planMonths;
    if (months == null) return 'No plan yet'.tr(context);
    return AppStrings.t(context,
        months == 1 ? '1 Month plan' : '$months Months plan', '$months মাসের প্ল্যান');
  }

  String get _badge => switch (subscription.status) {
        SubscriptionStatus.active => '✓ Active'.tr(context),
        SubscriptionStatus.expiringSoon => '⚠ Ending soon'.tr(context),
        SubscriptionStatus.expired => '✕ Expired'.tr(context),
        SubscriptionStatus.none => 'Not subscribed'.tr(context),
      };

  @override
  Widget build(BuildContext context) {
    final s = subscription;
    final bad = !s.hasAccess;

    return _CardShell(
      gradient: bad ? _expiredGradient : _activeGradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('MEMBERSHIP PLAN'.tr(context), style: _captionStyle),
                    const SizedBox(height: 3),
                    Text(_planName,
                      style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
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
                  child: Text(_badge,
                    style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (s.hasAccess) ...[
            Text.rich(TextSpan(children: [
              TextSpan(
                text: s.isTestPlan ? '$_countdown ' : '${s.daysLeft} ',
                style: const TextStyle(
                  fontSize: 32, fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              TextSpan(
                text: s.isTestPlan
                    ? AppStrings.t(context, 'min left', 'মিনিট বাকি')
                    : AppStrings.t(context, s.daysLeft == 1 ? 'day left' : 'days left', 'দিন বাকি'),
                style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w500,
                  color: Colors.white60,
                ),
              ),
            ])),
            if (s.status == SubscriptionStatus.expiringSoon) ...[
              const SizedBox(height: 6),
              Text('Please pay your Gym subscription fee.'.tr(context),
                  style: TextStyle(fontSize: 12, color: Colors.white)),
            ],
          ] else ...[
            Text(
              s.status == SubscriptionStatus.expired
                  ? 'Subscription expired'.tr(context)
                  : 'No active subscription'.tr(context),
              style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              s.status == SubscriptionStatus.expired
                  ? 'Please pay your Gym subscription fee to keep your access.'.tr(context)
                  : 'Pay your Gym subscription fee at the front desk and your access will be activated.'.tr(context),
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ],

          if (s.isTestPlan) ...[
            const SizedBox(height: 12),
            Text(
              bad
                  ? AppStrings.t(context, 'Ended ${formatDateTime(s.expiresAt!)}', '${formatDateTime(s.expiresAt!)}-এ শেষ হয়েছে')
                  : AppStrings.t(context, 'Ends ${formatDateTime(s.expiresAt!)}', '${formatDateTime(s.expiresAt!)}-এ শেষ হবে'),
              style: _smallWhite,
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: bad ? 1 : s.testProgress(_now),
                minHeight: 7,
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ] else if (s.startDate != null && s.endDate != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(formatDate(s.startDate!), style: _smallWhite),
                ),
                Expanded(
                  child: Text(
                    bad ? AppStrings.t(context, 'Ended ${formatDate(s.endDate!)}', '${formatDate(s.endDate!)}-এ শেষ হয়েছে')
                        : AppStrings.t(context, 'Until ${formatDate(s.endDate!)}', '${formatDate(s.endDate!)} পর্যন্ত'),
                    textAlign: TextAlign.end,
                    style: _smallWhite,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: bad ? 1 : s.progress,
                minHeight: 7,
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              bad
                  ? AppStrings.t(context, '100% used', '100% ব্যবহৃত')
                  : AppStrings.t(context, '${(s.progress * 100).toInt()}% used', '${(s.progress * 100).toInt()}% ব্যবহৃত'),
              style: _smallWhite,
            ),
          ],
        ],
      ),
    );
  }
}
