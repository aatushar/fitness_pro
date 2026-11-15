// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SubscriptionSummaryModel _$SubscriptionSummaryModelFromJson(
    Map<String, dynamic> json) {
  return _SubscriptionSummaryModel.fromJson(json);
}

/// @nodoc
mixin _$SubscriptionSummaryModel {
  int get totalMembers => throw _privateConstructorUsedError;
  int get active => throw _privateConstructorUsedError;
  int get expiringSoon => throw _privateConstructorUsedError;
  int get expired => throw _privateConstructorUsedError;
  int get notSubscribed => throw _privateConstructorUsedError;
  double get collectedThisMonth => throw _privateConstructorUsedError;

  /// Serializes this SubscriptionSummaryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubscriptionSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubscriptionSummaryModelCopyWith<SubscriptionSummaryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionSummaryModelCopyWith<$Res> {
  factory $SubscriptionSummaryModelCopyWith(SubscriptionSummaryModel value,
          $Res Function(SubscriptionSummaryModel) then) =
      _$SubscriptionSummaryModelCopyWithImpl<$Res, SubscriptionSummaryModel>;
  @useResult
  $Res call(
      {int totalMembers,
      int active,
      int expiringSoon,
      int expired,
      int notSubscribed,
      double collectedThisMonth});
}

/// @nodoc
class _$SubscriptionSummaryModelCopyWithImpl<$Res,
        $Val extends SubscriptionSummaryModel>
    implements $SubscriptionSummaryModelCopyWith<$Res> {
  _$SubscriptionSummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubscriptionSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalMembers = null,
    Object? active = null,
    Object? expiringSoon = null,
    Object? expired = null,
    Object? notSubscribed = null,
    Object? collectedThisMonth = null,
  }) {
    return _then(_value.copyWith(
      totalMembers: null == totalMembers
          ? _value.totalMembers
          : totalMembers // ignore: cast_nullable_to_non_nullable
              as int,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as int,
      expiringSoon: null == expiringSoon
          ? _value.expiringSoon
          : expiringSoon // ignore: cast_nullable_to_non_nullable
              as int,
      expired: null == expired
          ? _value.expired
          : expired // ignore: cast_nullable_to_non_nullable
              as int,
      notSubscribed: null == notSubscribed
          ? _value.notSubscribed
          : notSubscribed // ignore: cast_nullable_to_non_nullable
              as int,
      collectedThisMonth: null == collectedThisMonth
          ? _value.collectedThisMonth
          : collectedThisMonth // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubscriptionSummaryModelImplCopyWith<$Res>
    implements $SubscriptionSummaryModelCopyWith<$Res> {
  factory _$$SubscriptionSummaryModelImplCopyWith(
          _$SubscriptionSummaryModelImpl value,
          $Res Function(_$SubscriptionSummaryModelImpl) then) =
      __$$SubscriptionSummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalMembers,
      int active,
      int expiringSoon,
      int expired,
      int notSubscribed,
      double collectedThisMonth});
}

/// @nodoc
class __$$SubscriptionSummaryModelImplCopyWithImpl<$Res>
    extends _$SubscriptionSummaryModelCopyWithImpl<$Res,
        _$SubscriptionSummaryModelImpl>
    implements _$$SubscriptionSummaryModelImplCopyWith<$Res> {
  __$$SubscriptionSummaryModelImplCopyWithImpl(
      _$SubscriptionSummaryModelImpl _value,
      $Res Function(_$SubscriptionSummaryModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SubscriptionSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalMembers = null,
    Object? active = null,
    Object? expiringSoon = null,
    Object? expired = null,
    Object? notSubscribed = null,
    Object? collectedThisMonth = null,
  }) {
    return _then(_$SubscriptionSummaryModelImpl(
      totalMembers: null == totalMembers
          ? _value.totalMembers
          : totalMembers // ignore: cast_nullable_to_non_nullable
              as int,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as int,
      expiringSoon: null == expiringSoon
          ? _value.expiringSoon
          : expiringSoon // ignore: cast_nullable_to_non_nullable
              as int,
      expired: null == expired
          ? _value.expired
          : expired // ignore: cast_nullable_to_non_nullable
              as int,
      notSubscribed: null == notSubscribed
          ? _value.notSubscribed
          : notSubscribed // ignore: cast_nullable_to_non_nullable
              as int,
      collectedThisMonth: null == collectedThisMonth
          ? _value.collectedThisMonth
          : collectedThisMonth // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubscriptionSummaryModelImpl implements _SubscriptionSummaryModel {
  const _$SubscriptionSummaryModelImpl(
      {this.totalMembers = 0,
      this.active = 0,
      this.expiringSoon = 0,
      this.expired = 0,
      this.notSubscribed = 0,
      this.collectedThisMonth = 0});

  factory _$SubscriptionSummaryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubscriptionSummaryModelImplFromJson(json);

  @override
  @JsonKey()
  final int totalMembers;
  @override
  @JsonKey()
  final int active;
  @override
  @JsonKey()
  final int expiringSoon;
  @override
  @JsonKey()
  final int expired;
  @override
  @JsonKey()
  final int notSubscribed;
  @override
  @JsonKey()
  final double collectedThisMonth;

  @override
  String toString() {
    return 'SubscriptionSummaryModel(totalMembers: $totalMembers, active: $active, expiringSoon: $expiringSoon, expired: $expired, notSubscribed: $notSubscribed, collectedThisMonth: $collectedThisMonth)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionSummaryModelImpl &&
            (identical(other.totalMembers, totalMembers) ||
                other.totalMembers == totalMembers) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.expiringSoon, expiringSoon) ||
                other.expiringSoon == expiringSoon) &&
            (identical(other.expired, expired) || other.expired == expired) &&
            (identical(other.notSubscribed, notSubscribed) ||
                other.notSubscribed == notSubscribed) &&
            (identical(other.collectedThisMonth, collectedThisMonth) ||
                other.collectedThisMonth == collectedThisMonth));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalMembers, active,
      expiringSoon, expired, notSubscribed, collectedThisMonth);

  /// Create a copy of SubscriptionSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionSummaryModelImplCopyWith<_$SubscriptionSummaryModelImpl>
      get copyWith => __$$SubscriptionSummaryModelImplCopyWithImpl<
          _$SubscriptionSummaryModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubscriptionSummaryModelImplToJson(
      this,
    );
  }
}

abstract class _SubscriptionSummaryModel implements SubscriptionSummaryModel {
  const factory _SubscriptionSummaryModel(
      {final int totalMembers,
      final int active,
      final int expiringSoon,
      final int expired,
      final int notSubscribed,
      final double collectedThisMonth}) = _$SubscriptionSummaryModelImpl;

  factory _SubscriptionSummaryModel.fromJson(Map<String, dynamic> json) =
      _$SubscriptionSummaryModelImpl.fromJson;

  @override
  int get totalMembers;
  @override
  int get active;
  @override
  int get expiringSoon;
  @override
  int get expired;
  @override
  int get notSubscribed;
  @override
  double get collectedThisMonth;

  /// Create a copy of SubscriptionSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscriptionSummaryModelImplCopyWith<_$SubscriptionSummaryModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
