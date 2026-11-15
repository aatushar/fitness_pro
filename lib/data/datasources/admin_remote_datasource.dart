import 'package:dio/dio.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/network/api_exception.dart';
import '../models/admin_dashboard_model.dart';
import '../models/gym_model.dart';
import '../models/managed_user_model.dart';

abstract class AdminRemoteDatasource {
  Future<AdminDashboardModel> getDashboard();
  Future<List<ManagedUserModel>> getUsers(String url);
  Future<void> setUserStatus(int userId, String status);
  Future<void> setUserRoles(int userId, List<String> roles);
  Future<void> deleteUser(int userId);
  Future<List<GymModel>> getGyms(String url);
  Future<void> createGym(Map<String, dynamic> body);
  Future<void> updateGym(int gymsId, Map<String, dynamic> body);
  Future<void> setGymStatus(int gymsId, String status);
  Future<void> deleteGym(int gymsId);
}

class AdminRemoteDatasourceImpl implements AdminRemoteDatasource {
  final Dio _dio;
  AdminRemoteDatasourceImpl(this._dio);

  /// Runs [call] and turns any [DioException] into an [ApiException].
  Future<T> _run<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<AdminDashboardModel> getDashboard() => _run(() async {
        final r = await _dio.get<Map<String, dynamic>>(ApiEndpoints.adminDashboard);
        return AdminDashboardModel.fromJson(r.data ?? const {});
      });

  @override
  Future<List<ManagedUserModel>> getUsers(String url) => _run(() async {
        final r = await _dio.get<List<dynamic>>(url);
        return (r.data ?? const [])
            .map((e) => ManagedUserModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

  @override
  Future<void> setUserStatus(int userId, String status) => _run(() async {
        await _dio.patch<dynamic>('${ApiEndpoints.adminUsers}/$userId/status',
            data: {'status': status});
      });

  @override
  Future<void> setUserRoles(int userId, List<String> roles) => _run(() async {
        await _dio.put<dynamic>('${ApiEndpoints.adminUsers}/$userId/roles',
            data: {'roles': roles});
      });

  @override
  Future<void> deleteUser(int userId) => _run(() async {
        await _dio.delete<dynamic>('${ApiEndpoints.adminUsers}/$userId');
      });

  @override
  Future<List<GymModel>> getGyms(String url) => _run(() async {
        final r = await _dio.get<List<dynamic>>(url);
        return (r.data ?? const [])
            .map((e) => GymModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

  @override
  Future<void> createGym(Map<String, dynamic> body) => _run(() async {
        await _dio.post<dynamic>(ApiEndpoints.adminGyms, data: body);
      });

  @override
  Future<void> updateGym(int gymsId, Map<String, dynamic> body) => _run(() async {
        await _dio.put<dynamic>('${ApiEndpoints.adminGyms}/$gymsId', data: body);
      });

  @override
  Future<void> setGymStatus(int gymsId, String status) => _run(() async {
        await _dio.patch<dynamic>('${ApiEndpoints.adminGyms}/$gymsId/status',
            data: {'status': status});
      });

  @override
  Future<void> deleteGym(int gymsId) => _run(() async {
        await _dio.delete<dynamic>('${ApiEndpoints.adminGyms}/$gymsId');
      });
}
