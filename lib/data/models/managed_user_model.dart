import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/managed_user_entity.dart';
part 'managed_user_model.freezed.dart';
part 'managed_user_model.g.dart';

@freezed
class ManagedUserModel with _$ManagedUserModel {
  const factory ManagedUserModel({
    required int userId,
    required String username,
    @Default('') String email,
    String? phone,
    @Default('ACTIVE') String status,
    int? gymsId,
    String? gymName,
    @Default([]) List<String> roles,
  }) = _ManagedUserModel;

  factory ManagedUserModel.fromJson(Map<String, dynamic> json) =>
      _$ManagedUserModelFromJson(json);
}

extension ManagedUserModelMapper on ManagedUserModel {
  ManagedUserEntity toEntity() => ManagedUserEntity(
        userId: userId,
        username: username,
        email: email,
        phone: phone,
        status: status,
        gymsId: gymsId,
        gymName: gymName,
        roles: roles,
      );
}
