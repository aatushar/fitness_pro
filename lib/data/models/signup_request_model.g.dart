// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SignupRequestModelImpl _$$SignupRequestModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SignupRequestModelImpl(
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      role: (json['role'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$SignupRequestModelImplToJson(
        _$SignupRequestModelImpl instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
      'role': instance.role,
    };
