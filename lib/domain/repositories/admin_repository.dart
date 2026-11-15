import '../entities/admin_dashboard_entity.dart';
import '../entities/gym_entity.dart';
import '../entities/managed_user_entity.dart';

/// Everything the admin (ROLE_MANAGER) manages: dashboard numbers, users, gyms.
abstract class AdminRepository {
  Future<AdminDashboardEntity> getDashboard();

  Future<List<ManagedUserEntity>> getUsers();
  Future<void> setUserStatus(int userId, String status);
  Future<void> setUserRoles(int userId, List<String> roles);
  Future<void> deleteUser(int userId);

  /// Members of the caller's own gym (trainer screens).
  Future<List<ManagedUserEntity>> getTrainerMembers();

  Future<List<GymEntity>> getGyms();
  Future<void> saveGym({
    int? gymsId,
    required String name,
    required String email,
    required String city,
    required String phone,
  });
  Future<void> setGymStatus(int gymsId, String status);
  Future<void> deleteGym(int gymsId);

  /// Active gyms for the sign-up picker (needs no sign-in).
  Future<List<GymEntity>> getGymOptions();
}
