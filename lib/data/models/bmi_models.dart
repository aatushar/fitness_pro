import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/bmi_record_entity.dart';
part 'bmi_models.freezed.dart';
part 'bmi_models.g.dart';

@freezed
class BmiRecordModel with _$BmiRecordModel {
  const factory BmiRecordModel({
    required int id,
    required double heightCm,
    required double weightKg,
    required double bmi,
    @Default('MALE') String gender,
    int? ageYears,
    required String createdAt,
  }) = _BmiRecordModel;

  factory BmiRecordModel.fromJson(Map<String, dynamic> json) =>
      _$BmiRecordModelFromJson(json);
}

@freezed
class BmiOverviewModel with _$BmiOverviewModel {
  const factory BmiOverviewModel({
    BmiRecordModel? latest,
    @Default([]) List<BmiRecordModel> history,
  }) = _BmiOverviewModel;

  factory BmiOverviewModel.fromJson(Map<String, dynamic> json) =>
      _$BmiOverviewModelFromJson(json);
}

@freezed
class SaveBmiRequestModel with _$SaveBmiRequestModel {
  const factory SaveBmiRequestModel({
    required double heightCm,
    required double weightKg,

    /// MALE or FEMALE.
    required String gender,
  }) = _SaveBmiRequestModel;

  factory SaveBmiRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SaveBmiRequestModelFromJson(json);
}

extension BmiRecordModelMapper on BmiRecordModel {
  BmiRecordEntity toEntity() => BmiRecordEntity(
        id: id,
        heightCm: heightCm,
        weightKg: weightKg,
        bmi: bmi,
        gender: gender,
        ageYears: ageYears,
        createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
      );
}

extension BmiOverviewModelMapper on BmiOverviewModel {
  BmiOverviewEntity toEntity() => BmiOverviewEntity(
        latest: latest?.toEntity(),
        history: history.map((r) => r.toEntity()).toList(),
      );
}
