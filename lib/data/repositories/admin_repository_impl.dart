import '../../core/network/api_endpoints.dart';
import '../../domain/entities/admin_dashboard_entity.dart';
import '../../domain/entities/gym_entity.dart';
import '../../domain/entities/managed_user_entity.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/admin_remote_datasource.dart';
import '../models/admin_dashboard_model.dart';
import '../models/gym_model.dart';
import '../models/managed_user_model.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDatasource _datasource;
  AdminRepositoryImpl(this._datasource);

  @override
  Future<AdminDashboardEntity> getDashboard() async =>
      (await _datasource.getDashboard()).toEntity();

  @override
  Future<List<ManagedUserEntity>> getUsers() async =>
      (await _datasource.getUsers(ApiEndpoints.adminUsers))
          .map((m) => m.toEntity())
          .toList();

  @override
  Future<List<ManagedUserEntity>> getTrainerMembers() async =>
      (await _datasource.getUsers(ApiEndpoints.trainerMembers))
          .map((m) => m.toEntity())
          .toList();

  @override
  Future<void> setUserStatus(int userId, String status) =>
      _datasource.setUserStatus(userId, status);

  @override
  Future<void> setUserRoles(int userId, List<String> roles) =>
      _datasource.setUserRoles(userId, roles);

  @override
  Future<void> deleteUser(int userId) => _datasource.deleteUser(userId);

  @override
  Future<List<GymEntity>> getGyms() async =>
      (await _datasource.getGyms(ApiEndpoints.adminGyms))
          .map((m) => m.toEntity())
          .toList();

  @override
  Future<List<GymEntity>> getGymOptions() async =>
      (await _datasource.getGyms(ApiEndpoints.publicGyms))
          .map((m) => m.toEntity())
          .toList();

  @override
  Future<void> saveGym({
    int? gymsId,
    required String name,
    required String email,
    required String city,
    required String phone,
  }) {
    final body = {
      'gymName': name,
      'gymEmail': email,
      'city': city,
      'phoneNumber': phone,
    };
    return gymsId == null
        ? _datasource.createGym(body)
        : _datasource.updateGym(gymsId, body);
  }

  @override
  Future<void> setGymStatus(int gymsId, String status) =>
      _datasource.setGymStatus(gymsId, status);

  @override
  Future<void> deleteGym(int gymsId) => _datasource.deleteGym(gymsId);
}
