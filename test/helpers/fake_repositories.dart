import 'package:fitness_pro/domain/entities/profile_entity.dart';
import 'package:fitness_pro/domain/entities/user_entity.dart';
import 'package:fitness_pro/domain/repositories/auth_repository.dart';
import 'package:fitness_pro/domain/repositories/profile_repository.dart';

const testUser = UserEntity(
  id: 1,
  token: 'jwt-123',
  username: 'alim',
  roles: ['ROLE_MANAGER'],
);

const testProfile = ProfileEntity(
  id: 7,
  username: 'alim',
  email: 'alim@gmail.com',
  roles: ['ROLE_MEMBER'],
);

/// Hand-written fake: records calls, and throws [error] when it is set.
class FakeAuthRepository implements AuthRepository {
  Object? error;
  String? savedUsername = 'alim';
  final calls = <String>[];
  Map<String, Object> lastArgs = {};

  @override
  Future<void> signup({
    required String username,
    required String email,
    required String password,
    required List<String> role,
  }) async {
    calls.add('signup');
    lastArgs = {
      'username': username,
      'email': email,
      'password': password,
      'role': role,
    };
    if (error != null) throw error!;
  }

  @override
  Future<UserEntity> signin({
    required String username,
    required String password,
  }) async {
    calls.add('signin');
    lastArgs = {'username': username, 'password': password};
    if (error != null) throw error!;
    return testUser;
  }

  @override
  Future<void> signout() async {
    calls.add('signout');
    if (error != null) throw error!;
  }

  @override
  Future<String?> getSavedUsername() async {
    calls.add('getSavedUsername');
    if (error != null) throw error!;
    return savedUsername;
  }
}

class FakeProfileRepository implements ProfileRepository {
  Object? error;
  int calls = 0;

  @override
  Future<ProfileEntity> getProfile() async {
    calls++;
    if (error != null) throw error!;
    return testProfile;
  }
}
