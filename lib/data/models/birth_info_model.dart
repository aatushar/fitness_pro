import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/birth_info_entity.dart';
part 'birth_info_model.freezed.dart';
part 'birth_info_model.g.dart';

@freezed
class BirthInfoModel with _$BirthInfoModel {
  const factory BirthInfoModel({
    String? birthDateTime,
    String? updatedAt,
  }) = _BirthInfoModel;

  factory BirthInfoModel.fromJson(Map<String, dynamic> json) =>
      _$BirthInfoModelFromJson(json);
}

extension BirthInfoModelMapper on BirthInfoModel {
  BirthInfoEntity toEntity() => BirthInfoEntity(
        birthDateTime:
            birthDateTime == null ? null : DateTime.tryParse(birthDateTime!),
        updatedAt: updatedAt == null ? null : DateTime.tryParse(updatedAt!),
      );
}
