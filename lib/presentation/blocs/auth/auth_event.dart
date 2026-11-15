abstract class AuthEvent {}

class SignupSubmitted extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final List<String> role;
  final int? gymsId;

  SignupSubmitted({
    required this.username,
    required this.email,
    required this.password,
    required this.role,
    this.gymsId,
  });
}

class SigninSubmitted extends AuthEvent {
  final String username;
  final String password;

  SigninSubmitted({
    required this.username,
    required this.password,
  });
}

class SignoutRequested extends AuthEvent {}
