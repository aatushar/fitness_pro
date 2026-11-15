// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'managed_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ManagedUserModel _$ManagedUserModelFromJson(Map<String, dynamic> json) {
  return _ManagedUserModel.fromJson(json);
}

/// @nodoc
mixin _$ManagedUserModel {
  int get userId => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  int? get gymsId => throw _privateConstructorUsedError;
  String? get gymName => throw _privateConstructorUsedError;
  List<String> get roles => throw _privateConstructorUsedError;

  /// Serializes this ManagedUserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ManagedUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ManagedUserModelCopyWith<ManagedUserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManagedUserModelCopyWith<$Res> {
  factory $ManagedUserModelCopyWith(
          ManagedUserModel value, $Res Function(ManagedUserModel) then) =
      _$ManagedUserModelCopyWithImpl<$Res, ManagedUserModel>;
  @useResult
  $Res call(
      {int userId,
      String username,
      String email,
      String? phone,
      String status,
      int? gymsId,
      String? gymName,
      List<String> roles});
}

/// @nodoc
class _$ManagedUserModelCopyWithImpl<$Res, $Val extends ManagedUserModel>
    implements $ManagedUserModelCopyWith<$Res> {
  _$ManagedUserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ManagedUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? username = null,
    Object? email = null,
    Object? phone = freezed,
    Object? status = null,
    Object? gymsId = freezed,
    Object? gymName = freezed,
    Object? roles = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      gymsId: freezed == gymsId
          ? _value.gymsId
          : gymsId // ignore: cast_nullable_to_non_nullable
              as int?,
      gymName: freezed == gymName
          ? _value.gymName
          : gymName // ignore: cast_nullable_to_non_nullable
              as String?,
      roles: null == roles
          ? _value.roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ManagedUserModelImplCopyWith<$Res>
    implements $ManagedUserModelCopyWith<$Res> {
  factory _$$ManagedUserModelImplCopyWith(_$ManagedUserModelImpl value,
          $Res Function(_$ManagedUserModelImpl) then) =
      __$$ManagedUserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int userId,
      String username,
      String email,
      String? phone,
      String status,
      int? gymsId,
      String? gymName,
      List<String> roles});
}

/// @nodoc
class __$$ManagedUserModelImplCopyWithImpl<$Res>
    extends _$ManagedUserModelCopyWithImpl<$Res, _$ManagedUserModelImpl>
    implements _$$ManagedUserModelImplCopyWith<$Res> {
  __$$ManagedUserModelImplCopyWithImpl(_$ManagedUserModelImpl _value,
      $Res Function(_$ManagedUserModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ManagedUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? username = null,
    Object? email = null,
    Object? phone = freezed,
    Object? status = null,
    Object? gymsId = freezed,
    Object? gymName = freezed,
    Object? roles = null,
  }) {
    return _then(_$ManagedUserModelImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      gymsId: freezed == gymsId
          ? _value.gymsId
          : gymsId // ignore: cast_nullable_to_non_nullable
              as int?,
      gymName: freezed == gymName
          ? _value.gymName
          : gymName // ignore: cast_nullable_to_non_nullable
              as String?,
      roles: null == roles
          ? _value._roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ManagedUserModelImpl implements _ManagedUserModel {
  const _$ManagedUserModelImpl(
      {required this.userId,
      required this.username,
      this.email = '',
      this.phone,
      this.status = 'ACTIVE',
      this.gymsId,
      this.gymName,
      final List<String> roles = const []})
      : _roles = roles;

  factory _$ManagedUserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ManagedUserModelImplFromJson(json);

  @override
  final int userId;
  @override
  final String username;
  @override
  @JsonKey()
  final String email;
  @override
  final String? phone;
  @override
  @JsonKey()
  final String status;
  @override
  final int? gymsId;
  @override
  final String? gymName;
  final List<String> _roles;
  @override
  @JsonKey()
  List<String> get roles {
    if (_roles is EqualUnmodifiableListView) return _roles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roles);
  }

  @override
  String toString() {
    return 'ManagedUserModel(userId: $userId, username: $username, email: $email, phone: $phone, status: $status, gymsId: $gymsId, gymName: $gymName, roles: $roles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManagedUserModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.gymsId, gymsId) || other.gymsId == gymsId) &&
            (identical(other.gymName, gymName) || other.gymName == gymName) &&
            const DeepCollectionEquality().equals(other._roles, _roles));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, username, email, phone,
      status, gymsId, gymName, const DeepCollectionEquality().hash(_roles));

  /// Create a copy of ManagedUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ManagedUserModelImplCopyWith<_$ManagedUserModelImpl> get copyWith =>
      __$$ManagedUserModelImplCopyWithImpl<_$ManagedUserModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ManagedUserModelImplToJson(
      this,
    );
  }
}

abstract class _ManagedUserModel implements ManagedUserModel {
  const factory _ManagedUserModel(
      {required final int userId,
      required final String username,
      final String email,
      final String? phone,
      final String status,
      final int? gymsId,
      final String? gymName,
      final List<String> roles}) = _$ManagedUserModelImpl;

  factory _ManagedUserModel.fromJson(Map<String, dynamic> json) =
      _$ManagedUserModelImpl.fromJson;

  @override
  int get userId;
  @override
  String get username;
  @override
  String get email;
  @override
  String? get phone;
  @override
  String get status;
  @override
  int? get gymsId;
  @override
  String? get gymName;
  @override
  List<String> get roles;

  /// Create a copy of ManagedUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ManagedUserModelImplCopyWith<_$ManagedUserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
