import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/subscription_summary_entity.dart';
part 'subscription_summary_model.freezed.dart';
part 'subscription_summary_model.g.dart';

@freezed
class SubscriptionSummaryModel with _$SubscriptionSummaryModel {
  const factory SubscriptionSummaryModel({
    @Default(0) int totalMembers,
    @Default(0) int active,
    @Default(0) int expiringSoon,
    @Default(0) int expired,
    @Default(0) int notSubscribed,
    @Default(0) double collectedThisMonth,
  }) = _SubscriptionSummaryModel;

  factory SubscriptionSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionSummaryModelFromJson(json);
}

extension SubscriptionSummaryModelMapper on SubscriptionSummaryModel {
  SubscriptionSummaryEntity toEntity() => SubscriptionSummaryEntity(
        totalMembers: totalMembers,
        active: active,
        expiringSoon: expiringSoon,
        expired: expired,
        notSubscribed: notSubscribed,
        collectedThisMonth: collectedThisMonth,
      );
}
