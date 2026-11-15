/// Counts for the admin's fee-collection header.
class SubscriptionSummaryEntity {
  final int totalMembers;
  final int active;
  final int expiringSoon;
  final int expired;
  final int notSubscribed;
  final double collectedThisMonth;

  const SubscriptionSummaryEntity({
    required this.totalMembers,
    required this.active,
    required this.expiringSoon,
    required this.expired,
    required this.notSubscribed,
    required this.collectedThisMonth,
  });
}
