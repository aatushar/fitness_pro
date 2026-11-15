import 'package:dio/dio.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/network/api_exception.dart';
import '../models/activate_subscription_request_model.dart';
import '../models/member_subscription_model.dart';
import '../models/subscription_model.dart';
import '../models/subscription_summary_model.dart';

abstract class SubscriptionRemoteDatasource {
  Future<SubscriptionModel> getMySubscription();
  Future<List<MemberSubscriptionModel>> getMembers();
  Future<SubscriptionSummaryModel> getSummary();
  Future<SubscriptionModel> activate(ActivateSubscriptionRequestModel request);
}

class SubscriptionRemoteDatasourceImpl implements SubscriptionRemoteDatasource {
  final Dio _dio;
  SubscriptionRemoteDatasourceImpl(this._dio);

  @override
  Future<SubscriptionModel> getMySubscription() async {
    try {
      final response =
          await _dio.get<Map<String, dynamic>>(ApiEndpoints.mySubscription);
      return SubscriptionModel.fromJson(_body(response));
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<List<MemberSubscriptionModel>> getMembers() async {
    try {
      final response = await _dio
          .get<List<dynamic>>(ApiEndpoints.adminSubscriptionMembers);
      return (response.data ?? const [])
          .map((e) =>
              MemberSubscriptionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<SubscriptionSummaryModel> getSummary() async {
    try {
      final response = await _dio
          .get<Map<String, dynamic>>(ApiEndpoints.adminSubscriptionSummary);
      return SubscriptionSummaryModel.fromJson(_body(response));
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<SubscriptionModel> activate(
      ActivateSubscriptionRequestModel request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.adminSubscriptions,
        data: request.toJson(),
      );
      return SubscriptionModel.fromJson(_body(response));
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Map<String, dynamic> _body(Response<Map<String, dynamic>> response) {
    final data = response.data;
    if (data == null) throw const ApiException('Empty response from server.');
    return data;
  }
}
