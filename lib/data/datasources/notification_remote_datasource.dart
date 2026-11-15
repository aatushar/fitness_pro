import 'package:dio/dio.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/network/api_exception.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDatasource {
  Future<List<NotificationModel>> getNotifications();
  Future<void> markRead(int id);
  Future<void> markAllRead();
}

class NotificationRemoteDatasourceImpl implements NotificationRemoteDatasource {
  final Dio _dio;
  NotificationRemoteDatasourceImpl(this._dio);

  @override
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response =
          await _dio.get<List<dynamic>>(ApiEndpoints.notifications);
      return (response.data ?? const [])
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<void> markRead(int id) async {
    try {
      await _dio.post<dynamic>('${ApiEndpoints.notifications}/$id/read');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<void> markAllRead() async {
    try {
      await _dio.post<dynamic>('${ApiEndpoints.notifications}/read-all');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
