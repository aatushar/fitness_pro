import '../repositories/auth_repository.dart';

class GetSavedUsernameUseCase {
  final AuthRepository _repo;
  GetSavedUsernameUseCase(this._repo);

  Future<String?> call() => _repo.getSavedUsername();
}
