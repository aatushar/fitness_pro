import '../repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository _repository;
  SignupUseCase(this._repository);

  Future<void> call({
    required String username,
    required String email,
    required String password,
    required List<String> role,
  }) {
    return _repository.signup(
      username: username,
      email: email,
      password: password,
      role: role,
    );
  }
}