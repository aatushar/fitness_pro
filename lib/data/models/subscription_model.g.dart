// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubscriptionModelImpl _$$SubscriptionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SubscriptionModelImpl(
      status: json['status'] as String,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      daysLeft: (json['daysLeft'] as num?)?.toInt() ?? 0,
      totalDays: (json['totalDays'] as num?)?.toInt() ?? 0,
      planMonths: (json['planMonths'] as num?)?.toInt(),
      planMinutes: (json['planMinutes'] as num?)?.toInt(),
      expiresAt: json['expiresAt'] as String?,
      lastAmount: (json['lastAmount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$SubscriptionModelImplToJson(
        _$SubscriptionModelImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'daysLeft': instance.daysLeft,
      'totalDays': instance.totalDays,
      'planMonths': instance.planMonths,
      'planMinutes': instance.planMinutes,
      'expiresAt': instance.expiresAt,
      'lastAmount': instance.lastAmount,
    };
