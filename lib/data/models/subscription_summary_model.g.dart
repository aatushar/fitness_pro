// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubscriptionSummaryModelImpl _$$SubscriptionSummaryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SubscriptionSummaryModelImpl(
      totalMembers: (json['totalMembers'] as num?)?.toInt() ?? 0,
      active: (json['active'] as num?)?.toInt() ?? 0,
      expiringSoon: (json['expiringSoon'] as num?)?.toInt() ?? 0,
      expired: (json['expired'] as num?)?.toInt() ?? 0,
      notSubscribed: (json['notSubscribed'] as num?)?.toInt() ?? 0,
      collectedThisMonth: (json['collectedThisMonth'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$$SubscriptionSummaryModelImplToJson(
        _$SubscriptionSummaryModelImpl instance) =>
    <String, dynamic>{
      'totalMembers': instance.totalMembers,
      'active': instance.active,
      'expiringSoon': instance.expiringSoon,
      'expired': instance.expired,
      'notSubscribed': instance.notSubscribed,
      'collectedThisMonth': instance.collectedThisMonth,
    };
