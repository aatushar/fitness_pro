import 'package:dio/dio.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/network/api_exception.dart';
import '../models/birth_info_model.dart';
import '../models/save_birth_info_request_model.dart';
import '../../core/l10n/app_strings.dart';

abstract class AgeRemoteDatasource {
  Future<BirthInfoModel> getBirthInfo();
  Future<BirthInfoModel> saveBirthInfo(SaveBirthInfoRequestModel request);
}

class AgeRemoteDatasourceImpl implements AgeRemoteDatasource {
  final Dio _dio;
  AgeRemoteDatasourceImpl(this._dio);

  @override
  Future<BirthInfoModel> getBirthInfo() async {
    try {
      final response =
          await _dio.get<Map<String, dynamic>>(ApiEndpoints.ageCalculator);
      return BirthInfoModel.fromJson(_body(response));
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<BirthInfoModel> saveBirthInfo(
      SaveBirthInfoRequestModel request) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        ApiEndpoints.ageCalculator,
        data: request.toJson(),
      );
      return BirthInfoModel.fromJson(_body(response));
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Map<String, dynamic> _body(Response<Map<String, dynamic>> response) {
    final data = response.data;
    if (data == null) throw ApiException('Empty response from server.'.trNow);
    return data;
  }
}
