import 'package:dio/dio.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/storage/token_storage.dart';
import '../models/user_profile_model.dart';

abstract class ProfileRemoteDatasource {
  Future<UserProfileModel> getProfile();
}

class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasource {
  final Dio _dio;
  final TokenStorage _tokenStorage;

  ProfileRemoteDatasourceImpl(this._dio, this._tokenStorage);

  @override
  Future<UserProfileModel> getProfile() async {
    try {
      final token = await _tokenStorage.getToken();
      final response = await _dio.get(
        ApiEndpoints.profile,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      return UserProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Failed to load profile');
    }
  }
}