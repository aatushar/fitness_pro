import 'package:dio/dio.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/network/api_exception.dart';
import '../models/bmi_models.dart';
import '../../core/l10n/app_strings.dart';

abstract class BmiRemoteDatasource {
  Future<BmiOverviewModel> getOverview();
  Future<BmiOverviewModel> save(SaveBmiRequestModel request);
}

class BmiRemoteDatasourceImpl implements BmiRemoteDatasource {
  final Dio _dio;
  BmiRemoteDatasourceImpl(this._dio);

  @override
  Future<BmiOverviewModel> getOverview() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(ApiEndpoints.bmi);
      return BmiOverviewModel.fromJson(_body(response));
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<BmiOverviewModel> save(SaveBmiRequestModel request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.bmi,
        data: request.toJson(),
      );
      return BmiOverviewModel.fromJson(_body(response));
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
