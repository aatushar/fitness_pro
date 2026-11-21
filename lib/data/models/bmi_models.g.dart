// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bmi_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BmiRecordModelImpl _$$BmiRecordModelImplFromJson(Map<String, dynamic> json) =>
    _$BmiRecordModelImpl(
      id: (json['id'] as num).toInt(),
      heightCm: (json['heightCm'] as num).toDouble(),
      weightKg: (json['weightKg'] as num).toDouble(),
      bmi: (json['bmi'] as num).toDouble(),
      gender: json['gender'] as String? ?? 'MALE',
      ageYears: (json['ageYears'] as num?)?.toInt(),
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$$BmiRecordModelImplToJson(
        _$BmiRecordModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'heightCm': instance.heightCm,
      'weightKg': instance.weightKg,
      'bmi': instance.bmi,
      'gender': instance.gender,
      'ageYears': instance.ageYears,
      'createdAt': instance.createdAt,
    };

_$BmiOverviewModelImpl _$$BmiOverviewModelImplFromJson(
        Map<String, dynamic> json) =>
    _$BmiOverviewModelImpl(
      latest: json['latest'] == null
          ? null
          : BmiRecordModel.fromJson(json['latest'] as Map<String, dynamic>),
      history: (json['history'] as List<dynamic>?)
              ?.map((e) => BmiRecordModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$BmiOverviewModelImplToJson(
        _$BmiOverviewModelImpl instance) =>
    <String, dynamic>{
      'latest': instance.latest,
      'history': instance.history,
    };

_$SaveBmiRequestModelImpl _$$SaveBmiRequestModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SaveBmiRequestModelImpl(
      heightCm: (json['heightCm'] as num).toDouble(),
      weightKg: (json['weightKg'] as num).toDouble(),
      gender: json['gender'] as String,
    );

Map<String, dynamic> _$$SaveBmiRequestModelImplToJson(
        _$SaveBmiRequestModelImpl instance) =>
    <String, dynamic>{
      'heightCm': instance.heightCm,
      'weightKg': instance.weightKg,
      'gender': instance.gender,
    };
