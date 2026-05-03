class UserEntity {
  final int id;
  final String token;
  final String username;
  final List<String> roles;

  const UserEntity({
    required this.id,
    required this.token,
    required this.username,
    required this.roles,
  });
}