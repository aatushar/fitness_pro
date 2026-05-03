import 'package:dio/dio.dart';
import '../../core/network/api_endpoints.dart';
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
      await _dio.post(ApiEndpoints.signup, data: request.toJson());
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Signup failed');
    }
  }

  @override
  Future<SigninResponseModel> signin(SigninRequestModel request) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.signin,
        data: request.toJson(),
      );
      return SigninResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Invalid credentials');
    }
  }
}