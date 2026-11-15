import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/subscription_entity.dart';
part 'subscription_model.freezed.dart';
part 'subscription_model.g.dart';

/// Server status text -> [SubscriptionStatus]. Unknown text is treated as
/// "none" so a new server value can never crash the app.
SubscriptionStatus subscriptionStatusFromString(String? value) =>
    switch (value) {
      'ACTIVE' => SubscriptionStatus.active,
      'EXPIRING_SOON' => SubscriptionStatus.expiringSoon,
      'EXPIRED' => SubscriptionStatus.expired,
      _ => SubscriptionStatus.none,
    };

/// Server dates look like `2026-12-11`; null stays null.
DateTime? parseServerDate(String? value) =>
    value == null ? null : DateTime.tryParse(value);

/// Server moments look like `2026-11-11T00:25:00+06:00`; the offset makes it
/// the same instant on any phone. Null stays null.
DateTime? parseServerDateTime(String? value) =>
    value == null ? null : DateTime.tryParse(value);

@freezed
class SubscriptionModel with _$SubscriptionModel {
  const factory SubscriptionModel({
    required String status,
    String? startDate,
    String? endDate,
    @Default(0) int daysLeft,
    @Default(0) int totalDays,
    int? planMonths,
    int? planMinutes,
    String? expiresAt,
    double? lastAmount,
  }) = _SubscriptionModel;

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);
}

extension SubscriptionModelMapper on SubscriptionModel {
  SubscriptionEntity toEntity() => SubscriptionEntity(
        status: subscriptionStatusFromString(status),
        startDate: parseServerDate(startDate),
        endDate: parseServerDate(endDate),
        daysLeft: daysLeft,
        totalDays: totalDays,
        planMonths: planMonths,
        planMinutes: planMinutes,
        expiresAt: parseServerDateTime(expiresAt),
        lastAmount: lastAmount,
      );
}
