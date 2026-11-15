class ProfileEntity {
  final int id;
  final String username;
  final String email;
  final List<String> roles;
  final String? phone;

  const ProfileEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.roles,
    this.phone,
  });
}