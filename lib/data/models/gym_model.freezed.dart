// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gym_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GymModel _$GymModelFromJson(Map<String, dynamic> json) {
  return _GymModel.fromJson(json);
}

/// @nodoc
mixin _$GymModel {
  int get gymsId => throw _privateConstructorUsedError;
  String get gymName => throw _privateConstructorUsedError;
  String? get gymEmail => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  /// Serializes this GymModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GymModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GymModelCopyWith<GymModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GymModelCopyWith<$Res> {
  factory $GymModelCopyWith(GymModel value, $Res Function(GymModel) then) =
      _$GymModelCopyWithImpl<$Res, GymModel>;
  @useResult
  $Res call(
      {int gymsId,
      String gymName,
      String? gymEmail,
      String? city,
      String? phoneNumber,
      String status});
}

/// @nodoc
class _$GymModelCopyWithImpl<$Res, $Val extends GymModel>
    implements $GymModelCopyWith<$Res> {
  _$GymModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GymModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gymsId = null,
    Object? gymName = null,
    Object? gymEmail = freezed,
    Object? city = freezed,
    Object? phoneNumber = freezed,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      gymsId: null == gymsId
          ? _value.gymsId
          : gymsId // ignore: cast_nullable_to_non_nullable
              as int,
      gymName: null == gymName
          ? _value.gymName
          : gymName // ignore: cast_nullable_to_non_nullable
              as String,
      gymEmail: freezed == gymEmail
          ? _value.gymEmail
          : gymEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GymModelImplCopyWith<$Res>
    implements $GymModelCopyWith<$Res> {
  factory _$$GymModelImplCopyWith(
          _$GymModelImpl value, $Res Function(_$GymModelImpl) then) =
      __$$GymModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int gymsId,
      String gymName,
      String? gymEmail,
      String? city,
      String? phoneNumber,
      String status});
}

/// @nodoc
class __$$GymModelImplCopyWithImpl<$Res>
    extends _$GymModelCopyWithImpl<$Res, _$GymModelImpl>
    implements _$$GymModelImplCopyWith<$Res> {
  __$$GymModelImplCopyWithImpl(
      _$GymModelImpl _value, $Res Function(_$GymModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of GymModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gymsId = null,
    Object? gymName = null,
    Object? gymEmail = freezed,
    Object? city = freezed,
    Object? phoneNumber = freezed,
    Object? status = null,
  }) {
    return _then(_$GymModelImpl(
      gymsId: null == gymsId
          ? _value.gymsId
          : gymsId // ignore: cast_nullable_to_non_nullable
              as int,
      gymName: null == gymName
          ? _value.gymName
          : gymName // ignore: cast_nullable_to_non_nullable
              as String,
      gymEmail: freezed == gymEmail
          ? _value.gymEmail
          : gymEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GymModelImpl implements _GymModel {
  const _$GymModelImpl(
      {required this.gymsId,
      required this.gymName,
      this.gymEmail,
      this.city,
      this.phoneNumber,
      this.status = 'ACTIVE'});

  factory _$GymModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GymModelImplFromJson(json);

  @override
  final int gymsId;
  @override
  final String gymName;
  @override
  final String? gymEmail;
  @override
  final String? city;
  @override
  final String? phoneNumber;
  @override
  @JsonKey()
  final String status;

  @override
  String toString() {
    return 'GymModel(gymsId: $gymsId, gymName: $gymName, gymEmail: $gymEmail, city: $city, phoneNumber: $phoneNumber, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GymModelImpl &&
            (identical(other.gymsId, gymsId) || other.gymsId == gymsId) &&
            (identical(other.gymName, gymName) || other.gymName == gymName) &&
            (identical(other.gymEmail, gymEmail) ||
                other.gymEmail == gymEmail) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, gymsId, gymName, gymEmail, city, phoneNumber, status);

  /// Create a copy of GymModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GymModelImplCopyWith<_$GymModelImpl> get copyWith =>
      __$$GymModelImplCopyWithImpl<_$GymModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GymModelImplToJson(
      this,
    );
  }
}

abstract class _GymModel implements GymModel {
  const factory _GymModel(
      {required final int gymsId,
      required final String gymName,
      final String? gymEmail,
      final String? city,
      final String? phoneNumber,
      final String status}) = _$GymModelImpl;

  factory _GymModel.fromJson(Map<String, dynamic> json) =
      _$GymModelImpl.fromJson;

  @override
  int get gymsId;
  @override
  String get gymName;
  @override
  String? get gymEmail;
  @override
  String? get city;
  @override
  String? get phoneNumber;
  @override
  String get status;

  /// Create a copy of GymModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GymModelImplCopyWith<_$GymModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
