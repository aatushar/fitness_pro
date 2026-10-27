import 'package:dio/dio.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/network/api_exception.dart';
import '../models/signin_request_model.dart';
import '../models/signin_response_model.dart';
import '../models/signup_request_model.dart';

abstract class AuthRemoteDatasource {
  Future<void> signup(SignupRequestModel request);
  Future<SigninResponseModel> signin(SigninRequestModel request);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final Dio _dio;
  AuthRemoteDatasourceImpl(this._dio);

  @override
  Future<void> signup(SignupRequestModel request) async {
    try {
      await _dio.post<dynamic>(ApiEndpoints.signup, data: request.toJson());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<SigninResponseModel> signin(SigninRequestModel request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.signin,
        data: request.toJson(),
      );
      final data = response.data;
      if (data == null) throw const ApiException('Empty response from server.');
      return SigninResponseModel.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(
        e,
        statusMessages: const {401: 'Invalid username or password.'},
      );
    }
  }
}
