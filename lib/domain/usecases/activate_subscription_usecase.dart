import '../entities/subscription_entity.dart';
import '../repositories/subscription_repository.dart';

/// Admin records a received fee; the member gets access for [months] months,
/// or for [testMinutes] minutes (a quick test plan). Pass exactly one.
class ActivateSubscriptionUseCase {
  final SubscriptionRepository _repo;
  ActivateSubscriptionUseCase(this._repo);

  Future<SubscriptionEntity> call({
    required int userId,
    int? months,
    int? testMinutes,
    required double amount,
    required String paymentMethod,
    String? note,
  }) =>
      _repo.activate(
        userId: userId,
        months: months,
        testMinutes: testMinutes,
        amount: amount,
        paymentMethod: paymentMethod,
        note: note,
      );
}
