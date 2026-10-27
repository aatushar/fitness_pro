import '../repositories/auth_repository.dart';

class SignoutUseCase {
  final AuthRepository _repo;
  SignoutUseCase(this._repo);

  Future<void> call() => _repo.signout();
}
