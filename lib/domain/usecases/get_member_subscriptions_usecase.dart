import '../entities/member_subscription_entity.dart';
import '../entities/subscription_summary_entity.dart';
import '../repositories/subscription_repository.dart';

/// Everything the admin's fee page shows: the member list and the summary.
class MemberSubscriptions {
  final List<MemberSubscriptionEntity> members;
  final SubscriptionSummaryEntity summary;
  const MemberSubscriptions(this.members, this.summary);
}

class GetMemberSubscriptionsUseCase {
  final SubscriptionRepository _repo;
  GetMemberSubscriptionsUseCase(this._repo);

  Future<MemberSubscriptions> call() async {
    final members = await _repo.getMembers();
    final summary = await _repo.getSummary();
    return MemberSubscriptions(members, summary);
  }
}
