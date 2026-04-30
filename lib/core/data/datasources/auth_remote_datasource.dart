import 'package:dio/dio.dart';
import 'package:fitness_pro/core/network/api_endpoints.dart';

import '../models/signup_request_model.dart';

abstract class AuthRemoteDatasource {
  Future<void> signup(SignupRequestModel request);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final Dio _dio;
  AuthRemoteDatasourceImpl(this._dio);

  @override
  Future<void> signup(SignupRequestModel request) async {
    await _dio.post(
      ApiEndpoints.signup,
      data: request.toJson(),
    );
  }
}