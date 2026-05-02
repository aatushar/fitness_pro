
import 'package:fitness_pro/domain/repositories/auth_repository.dart';

import '../datasources/auth_remote_datasource.dart';
import '../models/signup_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _datasource;
  AuthRepositoryImpl(this._datasource);

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
}