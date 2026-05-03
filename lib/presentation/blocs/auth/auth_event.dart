abstract class AuthEvent {}

class SignupSubmitted extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final List<String> role;

  SignupSubmitted({
    required this.username,
    required this.email,
    required this.password,
    required this.role,
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