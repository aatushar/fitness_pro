import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/member_subscription_entity.dart';
import 'subscription_model.dart';
part 'member_subscription_model.freezed.dart';
part 'member_subscription_model.g.dart';

@freezed
class MemberSubscriptionModel with _$MemberSubscriptionModel {
  const factory MemberSubscriptionModel({
    required int userId,
    required String username,
    required String email,
    String? phone,
    required String status,
    String? endDate,
    String? expiresAt,
    @Default(0) int daysLeft,
    double? lastAmount,
  }) = _MemberSubscriptionModel;

  factory MemberSubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$MemberSubscriptionModelFromJson(json);
}

extension MemberSubscriptionModelMapper on MemberSubscriptionModel {
  MemberSubscriptionEntity toEntity() => MemberSubscriptionEntity(
        userId: userId,
        username: username,
        email: email,
        phone: phone,
        status: subscriptionStatusFromString(status),
        endDate: parseServerDate(endDate),
        expiresAt: parseServerDateTime(expiresAt),
        daysLeft: daysLeft,
        lastAmount: lastAmount,
      );
}
