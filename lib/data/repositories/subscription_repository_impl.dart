import '../../domain/entities/member_subscription_entity.dart';
import '../../domain/entities/subscription_entity.dart';
import '../../domain/entities/subscription_summary_entity.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../datasources/subscription_remote_datasource.dart';
import '../models/activate_subscription_request_model.dart';
import '../models/member_subscription_model.dart';
import '../models/subscription_model.dart';
import '../models/subscription_summary_model.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionRemoteDatasource _datasource;
  SubscriptionRepositoryImpl(this._datasource);

  @override
  Future<SubscriptionEntity> getMySubscription() async =>
      (await _datasource.getMySubscription()).toEntity();

  @override
  Future<List<MemberSubscriptionEntity>> getMembers() async =>
      (await _datasource.getMembers()).map((m) => m.toEntity()).toList();

  @override
  Future<SubscriptionSummaryEntity> getSummary() async =>
      (await _datasource.getSummary()).toEntity();

  @override
  Future<SubscriptionEntity> activate({
    required int userId,
    int? months,
    int? testMinutes,
    required double amount,
    required String paymentMethod,
    String? note,
  }) async =>
      (await _datasource.activate(ActivateSubscriptionRequestModel(
        userId: userId,
        months: months,
        testMinutes: testMinutes,
        amount: amount,
        paymentMethod: paymentMethod,
        note: note,
      )))
          .toEntity();
}
