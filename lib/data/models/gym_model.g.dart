// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gym_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GymModelImpl _$$GymModelImplFromJson(Map<String, dynamic> json) =>
    _$GymModelImpl(
      gymsId: (json['gymsId'] as num).toInt(),
      gymName: json['gymName'] as String,
      gymEmail: json['gymEmail'] as String?,
      city: json['city'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      status: json['status'] as String? ?? 'ACTIVE',
    );

Map<String, dynamic> _$$GymModelImplToJson(_$GymModelImpl instance) =>
    <String, dynamic>{
      'gymsId': instance.gymsId,
      'gymName': instance.gymName,
      'gymEmail': instance.gymEmail,
      'city': instance.city,
      'phoneNumber': instance.phoneNumber,
      'status': instance.status,
    };
