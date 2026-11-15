class GymEntity {
  final int gymsId;
  final String gymName;
  final String? gymEmail;
  final String? city;
  final String? phoneNumber;
  final String status; // ACTIVE | INACTIVE | SUSPENDED

  const GymEntity({
    required this.gymsId,
    required this.gymName,
    this.gymEmail,
    this.city,
    this.phoneNumber,
    this.status = 'ACTIVE',
  });

  bool get isActive => status == 'ACTIVE';
}
