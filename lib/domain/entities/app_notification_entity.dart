class AppNotificationEntity {
  final int id;
  final String title;
  final String message;
  final String type;
  final bool read;
  final DateTime createdAt;

  const AppNotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.read,
    required this.createdAt,
  });

  AppNotificationEntity copyWith({bool? read}) => AppNotificationEntity(
        id: id,
        title: title,
        message: message,
        type: type,
        read: read ?? this.read,
        createdAt: createdAt,
      );
}
