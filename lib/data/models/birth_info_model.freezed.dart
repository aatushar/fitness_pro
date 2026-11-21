// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'birth_info_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BirthInfoModel _$BirthInfoModelFromJson(Map<String, dynamic> json) {
  return _BirthInfoModel.fromJson(json);
}

/// @nodoc
mixin _$BirthInfoModel {
  String? get birthDateTime => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this BirthInfoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BirthInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BirthInfoModelCopyWith<BirthInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BirthInfoModelCopyWith<$Res> {
  factory $BirthInfoModelCopyWith(
          BirthInfoModel value, $Res Function(BirthInfoModel) then) =
      _$BirthInfoModelCopyWithImpl<$Res, BirthInfoModel>;
  @useResult
  $Res call({String? birthDateTime, String? updatedAt});
}

/// @nodoc
class _$BirthInfoModelCopyWithImpl<$Res, $Val extends BirthInfoModel>
    implements $BirthInfoModelCopyWith<$Res> {
  _$BirthInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BirthInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? birthDateTime = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      birthDateTime: freezed == birthDateTime
          ? _value.birthDateTime
          : birthDateTime // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BirthInfoModelImplCopyWith<$Res>
    implements $BirthInfoModelCopyWith<$Res> {
  factory _$$BirthInfoModelImplCopyWith(_$BirthInfoModelImpl value,
          $Res Function(_$BirthInfoModelImpl) then) =
      __$$BirthInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? birthDateTime, String? updatedAt});
}

/// @nodoc
class __$$BirthInfoModelImplCopyWithImpl<$Res>
    extends _$BirthInfoModelCopyWithImpl<$Res, _$BirthInfoModelImpl>
    implements _$$BirthInfoModelImplCopyWith<$Res> {
  __$$BirthInfoModelImplCopyWithImpl(
      _$BirthInfoModelImpl _value, $Res Function(_$BirthInfoModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of BirthInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? birthDateTime = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$BirthInfoModelImpl(
      birthDateTime: freezed == birthDateTime
          ? _value.birthDateTime
          : birthDateTime // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BirthInfoModelImpl implements _BirthInfoModel {
  const _$BirthInfoModelImpl({this.birthDateTime, this.updatedAt});

  factory _$BirthInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BirthInfoModelImplFromJson(json);

  @override
  final String? birthDateTime;
  @override
  final String? updatedAt;

  @override
  String toString() {
    return 'BirthInfoModel(birthDateTime: $birthDateTime, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BirthInfoModelImpl &&
            (identical(other.birthDateTime, birthDateTime) ||
                other.birthDateTime == birthDateTime) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, birthDateTime, updatedAt);

  /// Create a copy of BirthInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BirthInfoModelImplCopyWith<_$BirthInfoModelImpl> get copyWith =>
      __$$BirthInfoModelImplCopyWithImpl<_$BirthInfoModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BirthInfoModelImplToJson(
      this,
    );
  }
}

abstract class _BirthInfoModel implements BirthInfoModel {
  const factory _BirthInfoModel(
      {final String? birthDateTime,
      final String? updatedAt}) = _$BirthInfoModelImpl;

  factory _BirthInfoModel.fromJson(Map<String, dynamic> json) =
      _$BirthInfoModelImpl.fromJson;

  @override
  String? get birthDateTime;
  @override
  String? get updatedAt;

  /// Create a copy of BirthInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BirthInfoModelImplCopyWith<_$BirthInfoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
