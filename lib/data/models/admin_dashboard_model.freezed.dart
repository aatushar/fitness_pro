// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_dashboard_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AdminDashboardModel _$AdminDashboardModelFromJson(Map<String, dynamic> json) {
  return _AdminDashboardModel.fromJson(json);
}

/// @nodoc
mixin _$AdminDashboardModel {
  int get totalMembers => throw _privateConstructorUsedError;
  int get totalTrainers => throw _privateConstructorUsedError;
  int get totalManagers => throw _privateConstructorUsedError;
  int get totalGyms => throw _privateConstructorUsedError;
  SubscriptionSummaryModel get subscriptions =>
      throw _privateConstructorUsedError;

  /// Serializes this AdminDashboardModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AdminDashboardModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdminDashboardModelCopyWith<AdminDashboardModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminDashboardModelCopyWith<$Res> {
  factory $AdminDashboardModelCopyWith(
          AdminDashboardModel value, $Res Function(AdminDashboardModel) then) =
      _$AdminDashboardModelCopyWithImpl<$Res, AdminDashboardModel>;
  @useResult
  $Res call(
      {int totalMembers,
      int totalTrainers,
      int totalManagers,
      int totalGyms,
      SubscriptionSummaryModel subscriptions});

  $SubscriptionSummaryModelCopyWith<$Res> get subscriptions;
}

/// @nodoc
class _$AdminDashboardModelCopyWithImpl<$Res, $Val extends AdminDashboardModel>
    implements $AdminDashboardModelCopyWith<$Res> {
  _$AdminDashboardModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdminDashboardModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalMembers = null,
    Object? totalTrainers = null,
    Object? totalManagers = null,
    Object? totalGyms = null,
    Object? subscriptions = null,
  }) {
    return _then(_value.copyWith(
      totalMembers: null == totalMembers
          ? _value.totalMembers
          : totalMembers // ignore: cast_nullable_to_non_nullable
              as int,
      totalTrainers: null == totalTrainers
          ? _value.totalTrainers
          : totalTrainers // ignore: cast_nullable_to_non_nullable
              as int,
      totalManagers: null == totalManagers
          ? _value.totalManagers
          : totalManagers // ignore: cast_nullable_to_non_nullable
              as int,
      totalGyms: null == totalGyms
          ? _value.totalGyms
          : totalGyms // ignore: cast_nullable_to_non_nullable
              as int,
      subscriptions: null == subscriptions
          ? _value.subscriptions
          : subscriptions // ignore: cast_nullable_to_non_nullable
              as SubscriptionSummaryModel,
    ) as $Val);
  }

  /// Create a copy of AdminDashboardModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SubscriptionSummaryModelCopyWith<$Res> get subscriptions {
    return $SubscriptionSummaryModelCopyWith<$Res>(_value.subscriptions,
        (value) {
      return _then(_value.copyWith(subscriptions: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AdminDashboardModelImplCopyWith<$Res>
    implements $AdminDashboardModelCopyWith<$Res> {
  factory _$$AdminDashboardModelImplCopyWith(_$AdminDashboardModelImpl value,
          $Res Function(_$AdminDashboardModelImpl) then) =
      __$$AdminDashboardModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalMembers,
      int totalTrainers,
      int totalManagers,
      int totalGyms,
      SubscriptionSummaryModel subscriptions});

  @override
  $SubscriptionSummaryModelCopyWith<$Res> get subscriptions;
}

/// @nodoc
class __$$AdminDashboardModelImplCopyWithImpl<$Res>
    extends _$AdminDashboardModelCopyWithImpl<$Res, _$AdminDashboardModelImpl>
    implements _$$AdminDashboardModelImplCopyWith<$Res> {
  __$$AdminDashboardModelImplCopyWithImpl(_$AdminDashboardModelImpl _value,
      $Res Function(_$AdminDashboardModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AdminDashboardModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalMembers = null,
    Object? totalTrainers = null,
    Object? totalManagers = null,
    Object? totalGyms = null,
    Object? subscriptions = null,
  }) {
    return _then(_$AdminDashboardModelImpl(
      totalMembers: null == totalMembers
          ? _value.totalMembers
          : totalMembers // ignore: cast_nullable_to_non_nullable
              as int,
      totalTrainers: null == totalTrainers
          ? _value.totalTrainers
          : totalTrainers // ignore: cast_nullable_to_non_nullable
              as int,
      totalManagers: null == totalManagers
          ? _value.totalManagers
          : totalManagers // ignore: cast_nullable_to_non_nullable
              as int,
      totalGyms: null == totalGyms
          ? _value.totalGyms
          : totalGyms // ignore: cast_nullable_to_non_nullable
              as int,
      subscriptions: null == subscriptions
          ? _value.subscriptions
          : subscriptions // ignore: cast_nullable_to_non_nullable
              as SubscriptionSummaryModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AdminDashboardModelImpl implements _AdminDashboardModel {
  const _$AdminDashboardModelImpl(
      {this.totalMembers = 0,
      this.totalTrainers = 0,
      this.totalManagers = 0,
      this.totalGyms = 0,
      this.subscriptions = const SubscriptionSummaryModel()});

  factory _$AdminDashboardModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdminDashboardModelImplFromJson(json);

  @override
  @JsonKey()
  final int totalMembers;
  @override
  @JsonKey()
  final int totalTrainers;
  @override
  @JsonKey()
  final int totalManagers;
  @override
  @JsonKey()
  final int totalGyms;
  @override
  @JsonKey()
  final SubscriptionSummaryModel subscriptions;

  @override
  String toString() {
    return 'AdminDashboardModel(totalMembers: $totalMembers, totalTrainers: $totalTrainers, totalManagers: $totalManagers, totalGyms: $totalGyms, subscriptions: $subscriptions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminDashboardModelImpl &&
            (identical(other.totalMembers, totalMembers) ||
                other.totalMembers == totalMembers) &&
            (identical(other.totalTrainers, totalTrainers) ||
                other.totalTrainers == totalTrainers) &&
            (identical(other.totalManagers, totalManagers) ||
                other.totalManagers == totalManagers) &&
            (identical(other.totalGyms, totalGyms) ||
                other.totalGyms == totalGyms) &&
            (identical(other.subscriptions, subscriptions) ||
                other.subscriptions == subscriptions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalMembers, totalTrainers,
      totalManagers, totalGyms, subscriptions);

  /// Create a copy of AdminDashboardModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminDashboardModelImplCopyWith<_$AdminDashboardModelImpl> get copyWith =>
      __$$AdminDashboardModelImplCopyWithImpl<_$AdminDashboardModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdminDashboardModelImplToJson(
      this,
    );
  }
}

abstract class _AdminDashboardModel implements AdminDashboardModel {
  const factory _AdminDashboardModel(
          {final int totalMembers,
          final int totalTrainers,
          final int totalManagers,
          final int totalGyms,
          final SubscriptionSummaryModel subscriptions}) =
      _$AdminDashboardModelImpl;

  factory _AdminDashboardModel.fromJson(Map<String, dynamic> json) =
      _$AdminDashboardModelImpl.fromJson;

  @override
  int get totalMembers;
  @override
  int get totalTrainers;
  @override
  int get totalManagers;
  @override
  int get totalGyms;
  @override
  SubscriptionSummaryModel get subscriptions;

  /// Create a copy of AdminDashboardModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdminDashboardModelImplCopyWith<_$AdminDashboardModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
