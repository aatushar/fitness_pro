import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/gym_entity.dart';
part 'gym_model.freezed.dart';
part 'gym_model.g.dart';

/// Reads both the full gym ([gymName], [city] ...) and the dropdown shape
/// (only [gymsId] and [gymName]).
@freezed
class GymModel with _$GymModel {
  const factory GymModel({
    required int gymsId,
    required String gymName,
    String? gymEmail,
    String? city,
    String? phoneNumber,
    @Default('ACTIVE') String status,
  }) = _GymModel;

  factory GymModel.fromJson(Map<String, dynamic> json) =>
      _$GymModelFromJson(json);
}

extension GymModelMapper on GymModel {
  GymEntity toEntity() => GymEntity(
        gymsId: gymsId,
        gymName: gymName,
        gymEmail: gymEmail,
        city: city,
        phoneNumber: phoneNumber,
        status: status,
      );
}
