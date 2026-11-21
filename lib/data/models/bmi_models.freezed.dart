// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bmi_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BmiRecordModel _$BmiRecordModelFromJson(Map<String, dynamic> json) {
  return _BmiRecordModel.fromJson(json);
}

/// @nodoc
mixin _$BmiRecordModel {
  int get id => throw _privateConstructorUsedError;
  double get heightCm => throw _privateConstructorUsedError;
  double get weightKg => throw _privateConstructorUsedError;
  double get bmi => throw _privateConstructorUsedError;
  String get gender => throw _privateConstructorUsedError;
  int? get ageYears => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;

  /// Serializes this BmiRecordModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BmiRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BmiRecordModelCopyWith<BmiRecordModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BmiRecordModelCopyWith<$Res> {
  factory $BmiRecordModelCopyWith(
          BmiRecordModel value, $Res Function(BmiRecordModel) then) =
      _$BmiRecordModelCopyWithImpl<$Res, BmiRecordModel>;
  @useResult
  $Res call(
      {int id,
      double heightCm,
      double weightKg,
      double bmi,
      String gender,
      int? ageYears,
      String createdAt});
}

/// @nodoc
class _$BmiRecordModelCopyWithImpl<$Res, $Val extends BmiRecordModel>
    implements $BmiRecordModelCopyWith<$Res> {
  _$BmiRecordModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BmiRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? heightCm = null,
    Object? weightKg = null,
    Object? bmi = null,
    Object? gender = null,
    Object? ageYears = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      heightCm: null == heightCm
          ? _value.heightCm
          : heightCm // ignore: cast_nullable_to_non_nullable
              as double,
      weightKg: null == weightKg
          ? _value.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as double,
      bmi: null == bmi
          ? _value.bmi
          : bmi // ignore: cast_nullable_to_non_nullable
              as double,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      ageYears: freezed == ageYears
          ? _value.ageYears
          : ageYears // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BmiRecordModelImplCopyWith<$Res>
    implements $BmiRecordModelCopyWith<$Res> {
  factory _$$BmiRecordModelImplCopyWith(_$BmiRecordModelImpl value,
          $Res Function(_$BmiRecordModelImpl) then) =
      __$$BmiRecordModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      double heightCm,
      double weightKg,
      double bmi,
      String gender,
      int? ageYears,
      String createdAt});
}

/// @nodoc
class __$$BmiRecordModelImplCopyWithImpl<$Res>
    extends _$BmiRecordModelCopyWithImpl<$Res, _$BmiRecordModelImpl>
    implements _$$BmiRecordModelImplCopyWith<$Res> {
  __$$BmiRecordModelImplCopyWithImpl(
      _$BmiRecordModelImpl _value, $Res Function(_$BmiRecordModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of BmiRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? heightCm = null,
    Object? weightKg = null,
    Object? bmi = null,
    Object? gender = null,
    Object? ageYears = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$BmiRecordModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      heightCm: null == heightCm
          ? _value.heightCm
          : heightCm // ignore: cast_nullable_to_non_nullable
              as double,
      weightKg: null == weightKg
          ? _value.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as double,
      bmi: null == bmi
          ? _value.bmi
          : bmi // ignore: cast_nullable_to_non_nullable
              as double,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      ageYears: freezed == ageYears
          ? _value.ageYears
          : ageYears // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BmiRecordModelImpl implements _BmiRecordModel {
  const _$BmiRecordModelImpl(
      {required this.id,
      required this.heightCm,
      required this.weightKg,
      required this.bmi,
      this.gender = 'MALE',
      this.ageYears,
      required this.createdAt});

  factory _$BmiRecordModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BmiRecordModelImplFromJson(json);

  @override
  final int id;
  @override
  final double heightCm;
  @override
  final double weightKg;
  @override
  final double bmi;
  @override
  @JsonKey()
  final String gender;
  @override
  final int? ageYears;
  @override
  final String createdAt;

  @override
  String toString() {
    return 'BmiRecordModel(id: $id, heightCm: $heightCm, weightKg: $weightKg, bmi: $bmi, gender: $gender, ageYears: $ageYears, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BmiRecordModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.heightCm, heightCm) ||
                other.heightCm == heightCm) &&
            (identical(other.weightKg, weightKg) ||
                other.weightKg == weightKg) &&
            (identical(other.bmi, bmi) || other.bmi == bmi) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.ageYears, ageYears) ||
                other.ageYears == ageYears) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, heightCm, weightKg, bmi, gender, ageYears, createdAt);

  /// Create a copy of BmiRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BmiRecordModelImplCopyWith<_$BmiRecordModelImpl> get copyWith =>
      __$$BmiRecordModelImplCopyWithImpl<_$BmiRecordModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BmiRecordModelImplToJson(
      this,
    );
  }
}

abstract class _BmiRecordModel implements BmiRecordModel {
  const factory _BmiRecordModel(
      {required final int id,
      required final double heightCm,
      required final double weightKg,
      required final double bmi,
      final String gender,
      final int? ageYears,
      required final String createdAt}) = _$BmiRecordModelImpl;

  factory _BmiRecordModel.fromJson(Map<String, dynamic> json) =
      _$BmiRecordModelImpl.fromJson;

  @override
  int get id;
  @override
  double get heightCm;
  @override
  double get weightKg;
  @override
  double get bmi;
  @override
  String get gender;
  @override
  int? get ageYears;
  @override
  String get createdAt;

  /// Create a copy of BmiRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BmiRecordModelImplCopyWith<_$BmiRecordModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BmiOverviewModel _$BmiOverviewModelFromJson(Map<String, dynamic> json) {
  return _BmiOverviewModel.fromJson(json);
}

/// @nodoc
mixin _$BmiOverviewModel {
  BmiRecordModel? get latest => throw _privateConstructorUsedError;
  List<BmiRecordModel> get history => throw _privateConstructorUsedError;

  /// Serializes this BmiOverviewModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BmiOverviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BmiOverviewModelCopyWith<BmiOverviewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BmiOverviewModelCopyWith<$Res> {
  factory $BmiOverviewModelCopyWith(
          BmiOverviewModel value, $Res Function(BmiOverviewModel) then) =
      _$BmiOverviewModelCopyWithImpl<$Res, BmiOverviewModel>;
  @useResult
  $Res call({BmiRecordModel? latest, List<BmiRecordModel> history});

  $BmiRecordModelCopyWith<$Res>? get latest;
}

/// @nodoc
class _$BmiOverviewModelCopyWithImpl<$Res, $Val extends BmiOverviewModel>
    implements $BmiOverviewModelCopyWith<$Res> {
  _$BmiOverviewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BmiOverviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latest = freezed,
    Object? history = null,
  }) {
    return _then(_value.copyWith(
      latest: freezed == latest
          ? _value.latest
          : latest // ignore: cast_nullable_to_non_nullable
              as BmiRecordModel?,
      history: null == history
          ? _value.history
          : history // ignore: cast_nullable_to_non_nullable
              as List<BmiRecordModel>,
    ) as $Val);
  }

  /// Create a copy of BmiOverviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BmiRecordModelCopyWith<$Res>? get latest {
    if (_value.latest == null) {
      return null;
    }

    return $BmiRecordModelCopyWith<$Res>(_value.latest!, (value) {
      return _then(_value.copyWith(latest: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BmiOverviewModelImplCopyWith<$Res>
    implements $BmiOverviewModelCopyWith<$Res> {
  factory _$$BmiOverviewModelImplCopyWith(_$BmiOverviewModelImpl value,
          $Res Function(_$BmiOverviewModelImpl) then) =
      __$$BmiOverviewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({BmiRecordModel? latest, List<BmiRecordModel> history});

  @override
  $BmiRecordModelCopyWith<$Res>? get latest;
}

/// @nodoc
class __$$BmiOverviewModelImplCopyWithImpl<$Res>
    extends _$BmiOverviewModelCopyWithImpl<$Res, _$BmiOverviewModelImpl>
    implements _$$BmiOverviewModelImplCopyWith<$Res> {
  __$$BmiOverviewModelImplCopyWithImpl(_$BmiOverviewModelImpl _value,
      $Res Function(_$BmiOverviewModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of BmiOverviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latest = freezed,
    Object? history = null,
  }) {
    return _then(_$BmiOverviewModelImpl(
      latest: freezed == latest
          ? _value.latest
          : latest // ignore: cast_nullable_to_non_nullable
              as BmiRecordModel?,
      history: null == history
          ? _value._history
          : history // ignore: cast_nullable_to_non_nullable
              as List<BmiRecordModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BmiOverviewModelImpl implements _BmiOverviewModel {
  const _$BmiOverviewModelImpl(
      {this.latest, final List<BmiRecordModel> history = const []})
      : _history = history;

  factory _$BmiOverviewModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BmiOverviewModelImplFromJson(json);

  @override
  final BmiRecordModel? latest;
  final List<BmiRecordModel> _history;
  @override
  @JsonKey()
  List<BmiRecordModel> get history {
    if (_history is EqualUnmodifiableListView) return _history;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_history);
  }

  @override
  String toString() {
    return 'BmiOverviewModel(latest: $latest, history: $history)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BmiOverviewModelImpl &&
            (identical(other.latest, latest) || other.latest == latest) &&
            const DeepCollectionEquality().equals(other._history, _history));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, latest, const DeepCollectionEquality().hash(_history));

  /// Create a copy of BmiOverviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BmiOverviewModelImplCopyWith<_$BmiOverviewModelImpl> get copyWith =>
      __$$BmiOverviewModelImplCopyWithImpl<_$BmiOverviewModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BmiOverviewModelImplToJson(
      this,
    );
  }
}

abstract class _BmiOverviewModel implements BmiOverviewModel {
  const factory _BmiOverviewModel(
      {final BmiRecordModel? latest,
      final List<BmiRecordModel> history}) = _$BmiOverviewModelImpl;

  factory _BmiOverviewModel.fromJson(Map<String, dynamic> json) =
      _$BmiOverviewModelImpl.fromJson;

  @override
  BmiRecordModel? get latest;
  @override
  List<BmiRecordModel> get history;

  /// Create a copy of BmiOverviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BmiOverviewModelImplCopyWith<_$BmiOverviewModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SaveBmiRequestModel _$SaveBmiRequestModelFromJson(Map<String, dynamic> json) {
  return _SaveBmiRequestModel.fromJson(json);
}

/// @nodoc
mixin _$SaveBmiRequestModel {
  double get heightCm => throw _privateConstructorUsedError;
  double get weightKg => throw _privateConstructorUsedError;

  /// MALE or FEMALE.
  String get gender => throw _privateConstructorUsedError;

  /// Serializes this SaveBmiRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SaveBmiRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SaveBmiRequestModelCopyWith<SaveBmiRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaveBmiRequestModelCopyWith<$Res> {
  factory $SaveBmiRequestModelCopyWith(
          SaveBmiRequestModel value, $Res Function(SaveBmiRequestModel) then) =
      _$SaveBmiRequestModelCopyWithImpl<$Res, SaveBmiRequestModel>;
  @useResult
  $Res call({double heightCm, double weightKg, String gender});
}

/// @nodoc
class _$SaveBmiRequestModelCopyWithImpl<$Res, $Val extends SaveBmiRequestModel>
    implements $SaveBmiRequestModelCopyWith<$Res> {
  _$SaveBmiRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SaveBmiRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? heightCm = null,
    Object? weightKg = null,
    Object? gender = null,
  }) {
    return _then(_value.copyWith(
      heightCm: null == heightCm
          ? _value.heightCm
          : heightCm // ignore: cast_nullable_to_non_nullable
              as double,
      weightKg: null == weightKg
          ? _value.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as double,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SaveBmiRequestModelImplCopyWith<$Res>
    implements $SaveBmiRequestModelCopyWith<$Res> {
  factory _$$SaveBmiRequestModelImplCopyWith(_$SaveBmiRequestModelImpl value,
          $Res Function(_$SaveBmiRequestModelImpl) then) =
      __$$SaveBmiRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double heightCm, double weightKg, String gender});
}

/// @nodoc
class __$$SaveBmiRequestModelImplCopyWithImpl<$Res>
    extends _$SaveBmiRequestModelCopyWithImpl<$Res, _$SaveBmiRequestModelImpl>
    implements _$$SaveBmiRequestModelImplCopyWith<$Res> {
  __$$SaveBmiRequestModelImplCopyWithImpl(_$SaveBmiRequestModelImpl _value,
      $Res Function(_$SaveBmiRequestModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SaveBmiRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? heightCm = null,
    Object? weightKg = null,
    Object? gender = null,
  }) {
    return _then(_$SaveBmiRequestModelImpl(
      heightCm: null == heightCm
          ? _value.heightCm
          : heightCm // ignore: cast_nullable_to_non_nullable
              as double,
      weightKg: null == weightKg
          ? _value.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as double,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SaveBmiRequestModelImpl implements _SaveBmiRequestModel {
  const _$SaveBmiRequestModelImpl(
      {required this.heightCm, required this.weightKg, required this.gender});

  factory _$SaveBmiRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SaveBmiRequestModelImplFromJson(json);

  @override
  final double heightCm;
  @override
  final double weightKg;

  /// MALE or FEMALE.
  @override
  final String gender;

  @override
  String toString() {
    return 'SaveBmiRequestModel(heightCm: $heightCm, weightKg: $weightKg, gender: $gender)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaveBmiRequestModelImpl &&
            (identical(other.heightCm, heightCm) ||
                other.heightCm == heightCm) &&
            (identical(other.weightKg, weightKg) ||
                other.weightKg == weightKg) &&
            (identical(other.gender, gender) || other.gender == gender));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, heightCm, weightKg, gender);

  /// Create a copy of SaveBmiRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SaveBmiRequestModelImplCopyWith<_$SaveBmiRequestModelImpl> get copyWith =>
      __$$SaveBmiRequestModelImplCopyWithImpl<_$SaveBmiRequestModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SaveBmiRequestModelImplToJson(
      this,
    );
  }
}

abstract class _SaveBmiRequestModel implements SaveBmiRequestModel {
  const factory _SaveBmiRequestModel(
      {required final double heightCm,
      required final double weightKg,
      required final String gender}) = _$SaveBmiRequestModelImpl;

  factory _SaveBmiRequestModel.fromJson(Map<String, dynamic> json) =
      _$SaveBmiRequestModelImpl.fromJson;

  @override
  double get heightCm;
  @override
  double get weightKg;

  /// MALE or FEMALE.
  @override
  String get gender;

  /// Create a copy of SaveBmiRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SaveBmiRequestModelImplCopyWith<_$SaveBmiRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
