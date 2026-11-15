import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/app_notification_entity.dart';
part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required int id,
    required String title,
    required String message,
    @Default('') String type,
    @Default(false) bool read,
    required String createdAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}

extension NotificationModelMapper on NotificationModel {
  AppNotificationEntity toEntity() => AppNotificationEntity(
        id: id,
        title: title,
        message: message,
        type: type,
        read: read,
        createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
      );
}
