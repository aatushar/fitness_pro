// ignore_for_file: invalid_annotation_target
// (freezed copies @JsonKey onto the generated field; the lint cannot see that.)
import 'package:freezed_annotation/freezed_annotation.dart';
part 'activate_subscription_request_model.freezed.dart';
part 'activate_subscription_request_model.g.dart';

/// Exactly one of [months] and [testMinutes] is set: a normal monthly plan, or
/// a 1-3 minute test plan for trying the reminders.
@freezed
class ActivateSubscriptionRequestModel with _$ActivateSubscriptionRequestModel {
  const factory ActivateSubscriptionRequestModel({
    required int userId,
    @JsonKey(includeIfNull: false) int? months,
    @JsonKey(includeIfNull: false) int? testMinutes,
    required double amount,
    required String paymentMethod,
    String? note,
  }) = _ActivateSubscriptionRequestModel;

  factory ActivateSubscriptionRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ActivateSubscriptionRequestModelFromJson(json);
}
