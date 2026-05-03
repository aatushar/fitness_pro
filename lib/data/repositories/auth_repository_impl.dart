import '../../core/storage/token_storage.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/signin_request_model.dart';
import '../models/signup_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _datasource;
  final TokenStorage _tokenStorage;

  AuthRepositoryImpl(this._datasource, this._tokenStorage);

  @override
  Future<void> signup({
    required String username,
    required String email,
    required String password,
    required List<String> role,
  }) async {
    await _datasource.signup(SignupRequestModel(
      username: username,
      email: email,
      password: password,
      role: role,
    ));
  }

  @override
  Future<UserEntity> signin({
    required String username,
    required String password,
  }) async {
    final response = await _datasource.signin(
      SigninRequestModel(username: username, password: password),
    );

    await _tokenStorage.saveToken(response.jwtToken);
    await _tokenStorage.saveUsername(response.username);
    await _tokenStorage.saveRoles(response.roles);

    return UserEntity(
      id:       response.id,
      token:    response.jwtToken,
      username: response.username,
      roles:    response.roles,
    );
  }
}