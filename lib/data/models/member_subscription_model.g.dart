// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MemberSubscriptionModelImpl _$$MemberSubscriptionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$MemberSubscriptionModelImpl(
      userId: (json['userId'] as num).toInt(),
      username: json['username'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      status: json['status'] as String,
      endDate: json['endDate'] as String?,
      expiresAt: json['expiresAt'] as String?,
      daysLeft: (json['daysLeft'] as num?)?.toInt() ?? 0,
      lastAmount: (json['lastAmount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$MemberSubscriptionModelImplToJson(
        _$MemberSubscriptionModelImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'email': instance.email,
      'phone': instance.phone,
      'status': instance.status,
      'endDate': instance.endDate,
      'expiresAt': instance.expiresAt,
      'daysLeft': instance.daysLeft,
      'lastAmount': instance.lastAmount,
    };
