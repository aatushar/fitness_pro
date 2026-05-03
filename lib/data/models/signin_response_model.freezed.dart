// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'signin_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SigninResponseModel _$SigninResponseModelFromJson(Map<String, dynamic> json) {
  return _SigninResponseModel.fromJson(json);
}

/// @nodoc
mixin _$SigninResponseModel {
  int get id => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  List<String> get roles => throw _privateConstructorUsedError;
  String get jwtToken => throw _privateConstructorUsedError;

  /// Serializes this SigninResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SigninResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SigninResponseModelCopyWith<SigninResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SigninResponseModelCopyWith<$Res> {
  factory $SigninResponseModelCopyWith(
          SigninResponseModel value, $Res Function(SigninResponseModel) then) =
      _$SigninResponseModelCopyWithImpl<$Res, SigninResponseModel>;
  @useResult
  $Res call({int id, String username, List<String> roles, String jwtToken});
}

/// @nodoc
class _$SigninResponseModelCopyWithImpl<$Res, $Val extends SigninResponseModel>
    implements $SigninResponseModelCopyWith<$Res> {
  _$SigninResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SigninResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? roles = null,
    Object? jwtToken = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      roles: null == roles
          ? _value.roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      jwtToken: null == jwtToken
          ? _value.jwtToken
          : jwtToken // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SigninResponseModelImplCopyWith<$Res>
    implements $SigninResponseModelCopyWith<$Res> {
  factory _$$SigninResponseModelImplCopyWith(_$SigninResponseModelImpl value,
          $Res Function(_$SigninResponseModelImpl) then) =
      __$$SigninResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String username, List<String> roles, String jwtToken});
}

/// @nodoc
class __$$SigninResponseModelImplCopyWithImpl<$Res>
    extends _$SigninResponseModelCopyWithImpl<$Res, _$SigninResponseModelImpl>
    implements _$$SigninResponseModelImplCopyWith<$Res> {
  __$$SigninResponseModelImplCopyWithImpl(_$SigninResponseModelImpl _value,
      $Res Function(_$SigninResponseModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SigninResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? roles = null,
    Object? jwtToken = null,
  }) {
    return _then(_$SigninResponseModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      roles: null == roles
          ? _value._roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      jwtToken: null == jwtToken
          ? _value.jwtToken
          : jwtToken // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SigninResponseModelImpl implements _SigninResponseModel {
  const _$SigninResponseModelImpl(
      {required this.id,
      required this.username,
      required final List<String> roles,
      required this.jwtToken})
      : _roles = roles;

  factory _$SigninResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SigninResponseModelImplFromJson(json);

  @override
  final int id;
  @override
  final String username;
  final List<String> _roles;
  @override
  List<String> get roles {
    if (_roles is EqualUnmodifiableListView) return _roles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roles);
  }

  @override
  final String jwtToken;

  @override
  String toString() {
    return 'SigninResponseModel(id: $id, username: $username, roles: $roles, jwtToken: $jwtToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SigninResponseModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            const DeepCollectionEquality().equals(other._roles, _roles) &&
            (identical(other.jwtToken, jwtToken) ||
                other.jwtToken == jwtToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, username,
      const DeepCollectionEquality().hash(_roles), jwtToken);

  /// Create a copy of SigninResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SigninResponseModelImplCopyWith<_$SigninResponseModelImpl> get copyWith =>
      __$$SigninResponseModelImplCopyWithImpl<_$SigninResponseModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SigninResponseModelImplToJson(
      this,
    );
  }
}

abstract class _SigninResponseModel implements SigninResponseModel {
  const factory _SigninResponseModel(
      {required final int id,
      required final String username,
      required final List<String> roles,
      required final String jwtToken}) = _$SigninResponseModelImpl;

  factory _SigninResponseModel.fromJson(Map<String, dynamic> json) =
      _$SigninResponseModelImpl.fromJson;

  @override
  int get id;
  @override
  String get username;
  @override
  List<String> get roles;
  @override
  String get jwtToken;

  /// Create a copy of SigninResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SigninResponseModelImplCopyWith<_$SigninResponseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
