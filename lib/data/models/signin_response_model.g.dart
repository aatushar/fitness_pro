// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signin_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SigninResponseModelImpl _$$SigninResponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SigninResponseModelImpl(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
      jwtToken: json['jwtToken'] as String,
    );

Map<String, dynamic> _$$SigninResponseModelImplToJson(
        _$SigninResponseModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'roles': instance.roles,
      'jwtToken': instance.jwtToken,
    };
