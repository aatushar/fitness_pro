/// A user as the admin (or a trainer) sees them in a list.
class ManagedUserEntity {
  final int userId;
  final String username;
  final String email;
  final String? phone;
  final String status; // ACTIVE | INACTIVE | SUSPENDED
  final int? gymsId;
  final String? gymName;
  final List<String> roles;

  const ManagedUserEntity({
    required this.userId,
    required this.username,
    required this.email,
    this.phone,
    required this.status,
    this.gymsId,
    this.gymName,
    this.roles = const [],
  });

  bool get isActive => status == 'ACTIVE';

  /// Highest role first: manager > trainer > member.
  String get roleLabel {
    if (roles.contains('ROLE_MANAGER')) return 'Manager';
    if (roles.contains('ROLE_TRAINER')) return 'Trainer';
    return 'Member';
  }
}
