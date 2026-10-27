import 'package:dio/dio.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/network/api_exception.dart';
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
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.profile,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      final data = response.data;
      if (data == null) throw const ApiException('Empty response from server.');
      return UserProfileModel.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
