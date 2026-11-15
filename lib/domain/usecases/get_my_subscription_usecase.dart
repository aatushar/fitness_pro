import '../entities/subscription_entity.dart';
import '../repositories/subscription_repository.dart';

class GetMySubscriptionUseCase {
  final SubscriptionRepository _repo;
  GetMySubscriptionUseCase(this._repo);

  Future<SubscriptionEntity> call() => _repo.getMySubscription();
}
