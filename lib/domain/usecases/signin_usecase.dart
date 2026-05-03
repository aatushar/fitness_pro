import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SigninUseCase {
  final AuthRepository _repo;
  SigninUseCase(this._repo);

  Future<UserEntity> call({
    required String username,
    required String password,
  }) =>
      _repo.signin(username: username, password: password);
}