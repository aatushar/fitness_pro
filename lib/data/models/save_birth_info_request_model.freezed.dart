// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'save_birth_info_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SaveBirthInfoRequestModel _$SaveBirthInfoRequestModelFromJson(
    Map<String, dynamic> json) {
  return _SaveBirthInfoRequestModel.fromJson(json);
}

/// @nodoc
mixin _$SaveBirthInfoRequestModel {
  /// Local date-time without zone, e.g. "2000-05-17T15:27:00".
  String get birthDateTime => throw _privateConstructorUsedError;

  /// Serializes this SaveBirthInfoRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SaveBirthInfoRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SaveBirthInfoRequestModelCopyWith<SaveBirthInfoRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaveBirthInfoRequestModelCopyWith<$Res> {
  factory $SaveBirthInfoRequestModelCopyWith(SaveBirthInfoRequestModel value,
          $Res Function(SaveBirthInfoRequestModel) then) =
      _$SaveBirthInfoRequestModelCopyWithImpl<$Res, SaveBirthInfoRequestModel>;
  @useResult
  $Res call({String birthDateTime});
}

/// @nodoc
class _$SaveBirthInfoRequestModelCopyWithImpl<$Res,
        $Val extends SaveBirthInfoRequestModel>
    implements $SaveBirthInfoRequestModelCopyWith<$Res> {
  _$SaveBirthInfoRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SaveBirthInfoRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? birthDateTime = null,
  }) {
    return _then(_value.copyWith(
      birthDateTime: null == birthDateTime
          ? _value.birthDateTime
          : birthDateTime // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SaveBirthInfoRequestModelImplCopyWith<$Res>
    implements $SaveBirthInfoRequestModelCopyWith<$Res> {
  factory _$$SaveBirthInfoRequestModelImplCopyWith(
          _$SaveBirthInfoRequestModelImpl value,
          $Res Function(_$SaveBirthInfoRequestModelImpl) then) =
      __$$SaveBirthInfoRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String birthDateTime});
}

/// @nodoc
class __$$SaveBirthInfoRequestModelImplCopyWithImpl<$Res>
    extends _$SaveBirthInfoRequestModelCopyWithImpl<$Res,
        _$SaveBirthInfoRequestModelImpl>
    implements _$$SaveBirthInfoRequestModelImplCopyWith<$Res> {
  __$$SaveBirthInfoRequestModelImplCopyWithImpl(
      _$SaveBirthInfoRequestModelImpl _value,
      $Res Function(_$SaveBirthInfoRequestModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SaveBirthInfoRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? birthDateTime = null,
  }) {
    return _then(_$SaveBirthInfoRequestModelImpl(
      birthDateTime: null == birthDateTime
          ? _value.birthDateTime
          : birthDateTime // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SaveBirthInfoRequestModelImpl implements _SaveBirthInfoRequestModel {
  const _$SaveBirthInfoRequestModelImpl({required this.birthDateTime});

  factory _$SaveBirthInfoRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SaveBirthInfoRequestModelImplFromJson(json);

  /// Local date-time without zone, e.g. "2000-05-17T15:27:00".
  @override
  final String birthDateTime;

  @override
  String toString() {
    return 'SaveBirthInfoRequestModel(birthDateTime: $birthDateTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaveBirthInfoRequestModelImpl &&
            (identical(other.birthDateTime, birthDateTime) ||
                other.birthDateTime == birthDateTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, birthDateTime);

  /// Create a copy of SaveBirthInfoRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SaveBirthInfoRequestModelImplCopyWith<_$SaveBirthInfoRequestModelImpl>
      get copyWith => __$$SaveBirthInfoRequestModelImplCopyWithImpl<
          _$SaveBirthInfoRequestModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SaveBirthInfoRequestModelImplToJson(
      this,
    );
  }
}

abstract class _SaveBirthInfoRequestModel implements SaveBirthInfoRequestModel {
  const factory _SaveBirthInfoRequestModel(
      {required final String birthDateTime}) = _$SaveBirthInfoRequestModelImpl;

  factory _SaveBirthInfoRequestModel.fromJson(Map<String, dynamic> json) =
      _$SaveBirthInfoRequestModelImpl.fromJson;

  /// Local date-time without zone, e.g. "2000-05-17T15:27:00".
  @override
  String get birthDateTime;

  /// Create a copy of SaveBirthInfoRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SaveBirthInfoRequestModelImplCopyWith<_$SaveBirthInfoRequestModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
