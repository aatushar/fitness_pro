import 'package:freezed_annotation/freezed_annotation.dart';
part 'save_birth_info_request_model.freezed.dart';
part 'save_birth_info_request_model.g.dart';

@freezed
class SaveBirthInfoRequestModel with _$SaveBirthInfoRequestModel {
  const factory SaveBirthInfoRequestModel({
    /// Local date-time without zone, e.g. "2000-05-17T15:27:00".
    required String birthDateTime,
  }) = _SaveBirthInfoRequestModel;

  factory SaveBirthInfoRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SaveBirthInfoRequestModelFromJson(json);
}
