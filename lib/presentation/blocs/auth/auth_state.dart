import '../../../domain/entities/user_entity.dart';

abstract class AuthState {}

class AuthInitial   extends AuthState {}
class AuthLoading   extends AuthState {}
class SignupSuccess extends AuthState {}
class SignoutSuccess extends AuthState {}

class SigninSuccess extends AuthState {
  final UserEntity user;
  SigninSuccess(this.user);
}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}
