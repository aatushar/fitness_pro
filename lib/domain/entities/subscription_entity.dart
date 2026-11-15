enum SubscriptionStatus { none, active, expiringSoon, expired }

/// A member's current gym subscription. [startDate]/[endDate] are null while
/// [status] is [SubscriptionStatus.none]. [endDate] is the first day that is
/// no longer covered, i.e. the expiry date.
class SubscriptionEntity {
  final SubscriptionStatus status;
  final DateTime? startDate;
  final DateTime? endDate;
  final int daysLeft;
  final int totalDays;
  final int? planMonths;
  final double? lastAmount;

  /// Only for the quick 1-3 minute test plans: the exact moment access ends.
  final DateTime? expiresAt;

  /// Length of a test plan in minutes; null for monthly plans.
  final int? planMinutes;

  const SubscriptionEntity({
    required this.status,
    this.startDate,
    this.endDate,
    this.daysLeft = 0,
    this.totalDays = 0,
    this.planMonths,
    this.lastAmount,
    this.expiresAt,
    this.planMinutes,
  });

  /// A minute-long test plan (to try the reminders) rather than a monthly one.
  bool get isTestPlan => expiresAt != null;

  /// Whether the member may use the gym right now.
  bool get hasAccess =>
      status == SubscriptionStatus.active ||
      status == SubscriptionStatus.expiringSoon;

  /// Share of the paid period already used, 0..1 (for the progress bar).
  double get progress =>
      totalDays <= 0 ? 0 : ((totalDays - daysLeft) / totalDays).clamp(0.0, 1.0);

  /// Share of a test plan used at [now], 0..1.
  double testProgress(DateTime now) {
    final end = expiresAt;
    final minutes = planMinutes;
    if (end == null || minutes == null || minutes <= 0) return 0;
    final left = end.difference(now).inMilliseconds;
    return (1 - left / Duration(minutes: minutes).inMilliseconds)
        .clamp(0.0, 1.0);
  }
}
