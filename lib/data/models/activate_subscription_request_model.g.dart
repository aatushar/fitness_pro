// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activate_subscription_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActivateSubscriptionRequestModelImpl
    _$$ActivateSubscriptionRequestModelImplFromJson(
            Map<String, dynamic> json) =>
        _$ActivateSubscriptionRequestModelImpl(
          userId: (json['userId'] as num).toInt(),
          months: (json['months'] as num?)?.toInt(),
          testMinutes: (json['testMinutes'] as num?)?.toInt(),
          amount: (json['amount'] as num).toDouble(),
          paymentMethod: json['paymentMethod'] as String,
          note: json['note'] as String?,
        );

Map<String, dynamic> _$$ActivateSubscriptionRequestModelImplToJson(
        _$ActivateSubscriptionRequestModelImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      if (instance.months case final value?) 'months': value,
      if (instance.testMinutes case final value?) 'testMinutes': value,
      'amount': instance.amount,
      'paymentMethod': instance.paymentMethod,
      'note': instance.note,
    };
