// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activate_subscription_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ActivateSubscriptionRequestModel _$ActivateSubscriptionRequestModelFromJson(
    Map<String, dynamic> json) {
  return _ActivateSubscriptionRequestModel.fromJson(json);
}

/// @nodoc
mixin _$ActivateSubscriptionRequestModel {
  int get userId => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  int? get months => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  int? get testMinutes => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get paymentMethod => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;

  /// Serializes this ActivateSubscriptionRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivateSubscriptionRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivateSubscriptionRequestModelCopyWith<ActivateSubscriptionRequestModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivateSubscriptionRequestModelCopyWith<$Res> {
  factory $ActivateSubscriptionRequestModelCopyWith(
          ActivateSubscriptionRequestModel value,
          $Res Function(ActivateSubscriptionRequestModel) then) =
      _$ActivateSubscriptionRequestModelCopyWithImpl<$Res,
          ActivateSubscriptionRequestModel>;
  @useResult
  $Res call(
      {int userId,
      @JsonKey(includeIfNull: false) int? months,
      @JsonKey(includeIfNull: false) int? testMinutes,
      double amount,
      String paymentMethod,
      String? note});
}

/// @nodoc
class _$ActivateSubscriptionRequestModelCopyWithImpl<$Res,
        $Val extends ActivateSubscriptionRequestModel>
    implements $ActivateSubscriptionRequestModelCopyWith<$Res> {
  _$ActivateSubscriptionRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivateSubscriptionRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? months = freezed,
    Object? testMinutes = freezed,
    Object? amount = null,
    Object? paymentMethod = null,
    Object? note = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      months: freezed == months
          ? _value.months
          : months // ignore: cast_nullable_to_non_nullable
              as int?,
      testMinutes: freezed == testMinutes
          ? _value.testMinutes
          : testMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActivateSubscriptionRequestModelImplCopyWith<$Res>
    implements $ActivateSubscriptionRequestModelCopyWith<$Res> {
  factory _$$ActivateSubscriptionRequestModelImplCopyWith(
          _$ActivateSubscriptionRequestModelImpl value,
          $Res Function(_$ActivateSubscriptionRequestModelImpl) then) =
      __$$ActivateSubscriptionRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int userId,
      @JsonKey(includeIfNull: false) int? months,
      @JsonKey(includeIfNull: false) int? testMinutes,
      double amount,
      String paymentMethod,
      String? note});
}

/// @nodoc
class __$$ActivateSubscriptionRequestModelImplCopyWithImpl<$Res>
    extends _$ActivateSubscriptionRequestModelCopyWithImpl<$Res,
        _$ActivateSubscriptionRequestModelImpl>
    implements _$$ActivateSubscriptionRequestModelImplCopyWith<$Res> {
  __$$ActivateSubscriptionRequestModelImplCopyWithImpl(
      _$ActivateSubscriptionRequestModelImpl _value,
      $Res Function(_$ActivateSubscriptionRequestModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActivateSubscriptionRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? months = freezed,
    Object? testMinutes = freezed,
    Object? amount = null,
    Object? paymentMethod = null,
    Object? note = freezed,
  }) {
    return _then(_$ActivateSubscriptionRequestModelImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      months: freezed == months
          ? _value.months
          : months // ignore: cast_nullable_to_non_nullable
              as int?,
      testMinutes: freezed == testMinutes
          ? _value.testMinutes
          : testMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivateSubscriptionRequestModelImpl
    implements _ActivateSubscriptionRequestModel {
  const _$ActivateSubscriptionRequestModelImpl(
      {required this.userId,
      @JsonKey(includeIfNull: false) this.months,
      @JsonKey(includeIfNull: false) this.testMinutes,
      required this.amount,
      required this.paymentMethod,
      this.note});

  factory _$ActivateSubscriptionRequestModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ActivateSubscriptionRequestModelImplFromJson(json);

  @override
  final int userId;
  @override
  @JsonKey(includeIfNull: false)
  final int? months;
  @override
  @JsonKey(includeIfNull: false)
  final int? testMinutes;
  @override
  final double amount;
  @override
  final String paymentMethod;
  @override
  final String? note;

  @override
  String toString() {
    return 'ActivateSubscriptionRequestModel(userId: $userId, months: $months, testMinutes: $testMinutes, amount: $amount, paymentMethod: $paymentMethod, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivateSubscriptionRequestModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.months, months) || other.months == months) &&
            (identical(other.testMinutes, testMinutes) ||
                other.testMinutes == testMinutes) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, userId, months, testMinutes, amount, paymentMethod, note);

  /// Create a copy of ActivateSubscriptionRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivateSubscriptionRequestModelImplCopyWith<
          _$ActivateSubscriptionRequestModelImpl>
      get copyWith => __$$ActivateSubscriptionRequestModelImplCopyWithImpl<
          _$ActivateSubscriptionRequestModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivateSubscriptionRequestModelImplToJson(
      this,
    );
  }
}

abstract class _ActivateSubscriptionRequestModel
    implements ActivateSubscriptionRequestModel {
  const factory _ActivateSubscriptionRequestModel(
      {required final int userId,
      @JsonKey(includeIfNull: false) final int? months,
      @JsonKey(includeIfNull: false) final int? testMinutes,
      required final double amount,
      required final String paymentMethod,
      final String? note}) = _$ActivateSubscriptionRequestModelImpl;

  factory _ActivateSubscriptionRequestModel.fromJson(
          Map<String, dynamic> json) =
      _$ActivateSubscriptionRequestModelImpl.fromJson;

  @override
  int get userId;
  @override
  @JsonKey(includeIfNull: false)
  int? get months;
  @override
  @JsonKey(includeIfNull: false)
  int? get testMinutes;
  @override
  double get amount;
  @override
  String get paymentMethod;
  @override
  String? get note;

  /// Create a copy of ActivateSubscriptionRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivateSubscriptionRequestModelImplCopyWith<
          _$ActivateSubscriptionRequestModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
