// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileModelImpl _$$UserProfileModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserProfileModelImpl(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
      email: json['email'] as String?,
      jwtToken: json['jwtToken'] as String?,
    );

Map<String, dynamic> _$$UserProfileModelImplToJson(
        _$UserProfileModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'roles': instance.roles,
      'email': instance.email,
      'jwtToken': instance.jwtToken,
    };
