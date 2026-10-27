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

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please check your internet connection.';
      case DioExceptionType.connectionError:
        // Check for CORS-related errors
        final message = e.message?.toLowerCase() ?? '';
        if (message.contains('cors') || 
            message.contains('origin') ||
            message.contains('blocked')) {
          return 'CORS error: Server is not allowing requests from this origin. Please contact the developer.';
        }
        return 'Cannot connect to server. Please check if the server is running.';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'];
        if (statusCode == 401) {
          return 'Invalid username or password.';
        } else if (statusCode == 403) {
          return 'Access denied.';
        } else if (statusCode == 404) {
          return 'Server endpoint not found.';
        } else if (statusCode == 500) {
          return 'Server error. Please try again later.';
        }
        return message ?? 'Request failed with status: $statusCode';
      default:
        return e.message ?? 'An unexpected error occurred.';
    }
  }

  @override
  Future<void> signup(SignupRequestModel request) async {
    try {
      await _dio.post(ApiEndpoints.signup, data: request.toJson());
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
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
      throw Exception(_handleDioError(e));
    }
  }
}