import 'package:freezed_annotation/freezed_annotation.dart';
part 'signin_response_model.freezed.dart';
part 'signin_response_model.g.dart';

@freezed
class SigninResponseModel with _$SigninResponseModel {
  const factory SigninResponseModel({
    required int id,
    required String username,
    required List<String> roles,
    required String jwtToken,
  }) = _SigninResponseModel;

  factory SigninResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SigninResponseModelFromJson(json);
}