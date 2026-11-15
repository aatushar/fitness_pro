import 'subscription_summary_entity.dart';

/// Headline numbers on the admin dashboard.
class AdminDashboardEntity {
  final int totalMembers;
  final int totalTrainers;
  final int totalManagers;
  final int totalGyms;
  final SubscriptionSummaryEntity subscriptions;

  const AdminDashboardEntity({
    required this.totalMembers,
    required this.totalTrainers,
    required this.totalManagers,
    required this.totalGyms,
    required this.subscriptions,
  });
}
