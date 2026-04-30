abstract class AuthRepository {
  Future<void> signup({
    required String username,
    required String email,
    required String password,
    required List<String> role,
  });
}