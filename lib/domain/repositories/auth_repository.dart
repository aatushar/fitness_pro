import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<void> signup({
    required String username,
    required String email,
    required String password,
    required List<String> role,
  });

  Future<UserEntity> signin({
    required String username,
    required String password,
  });
}