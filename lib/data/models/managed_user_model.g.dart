// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'managed_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ManagedUserModelImpl _$$ManagedUserModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ManagedUserModelImpl(
      userId: (json['userId'] as num).toInt(),
      username: json['username'] as String,
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      status: json['status'] as String? ?? 'ACTIVE',
      gymsId: (json['gymsId'] as num?)?.toInt(),
      gymName: json['gymName'] as String?,
      roles:
          (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$$ManagedUserModelImplToJson(
        _$ManagedUserModelImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'email': instance.email,
      'phone': instance.phone,
      'status': instance.status,
      'gymsId': instance.gymsId,
      'gymName': instance.gymName,
      'roles': instance.roles,
    };
