import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/admin_dashboard_entity.dart';
import 'subscription_summary_model.dart';
part 'admin_dashboard_model.freezed.dart';
part 'admin_dashboard_model.g.dart';

@freezed
class AdminDashboardModel with _$AdminDashboardModel {
  const factory AdminDashboardModel({
    @Default(0) int totalMembers,
    @Default(0) int totalTrainers,
    @Default(0) int totalManagers,
    @Default(0) int totalGyms,
    @Default(SubscriptionSummaryModel()) SubscriptionSummaryModel subscriptions,
  }) = _AdminDashboardModel;

  factory AdminDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$AdminDashboardModelFromJson(json);
}

extension AdminDashboardModelMapper on AdminDashboardModel {
  AdminDashboardEntity toEntity() => AdminDashboardEntity(
        totalMembers: totalMembers,
        totalTrainers: totalTrainers,
        totalManagers: totalManagers,
        totalGyms: totalGyms,
        subscriptions: subscriptions.toEntity(),
      );
}
