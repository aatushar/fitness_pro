import 'subscription_entity.dart';

/// One row of the admin's member list: who the member is and where their
/// subscription stands.
class MemberSubscriptionEntity {
  final int userId;
  final String username;
  final String email;
  final String? phone;
  final SubscriptionStatus status;
  final DateTime? endDate;

  /// Exact end of a minute-long test plan; null for monthly plans.
  final DateTime? expiresAt;
  final int daysLeft;
  final double? lastAmount;

  const MemberSubscriptionEntity({
    required this.userId,
    required this.username,
    required this.email,
    this.phone,
    required this.status,
    this.endDate,
    this.expiresAt,
    this.daysLeft = 0,
    this.lastAmount,
  });
}
