import '../repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository _repo;
  SignupUseCase(this._repo);

  Future<void> call({
    required String username,
    required String email,
    required String password,
    required List<String> role,
  }) =>
      _repo.signup(
        username: username,
        email: email,
        password: password,
        role: role,
      );
}