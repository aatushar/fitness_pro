import '../entities/member_subscription_entity.dart';
import '../entities/subscription_entity.dart';
import '../entities/subscription_summary_entity.dart';

abstract class SubscriptionRepository {
  /// The signed-in member's own subscription.
  Future<SubscriptionEntity> getMySubscription();

  /// Admin: every member of the gym with their subscription status.
  Future<List<MemberSubscriptionEntity>> getMembers();

  /// Admin: counts and this month's collected fees.
  Future<SubscriptionSummaryEntity> getSummary();

  /// Admin: records a received fee and gives the member access, for [months]
  /// months or - to try the reminders quickly - for [testMinutes] minutes
  /// (pass exactly one of the two).
  Future<SubscriptionEntity> activate({
    required int userId,
    int? months,
    int? testMinutes,
    required double amount,
    required String paymentMethod,
    String? note,
  });
}
