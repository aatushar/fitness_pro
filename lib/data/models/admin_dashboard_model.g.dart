// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdminDashboardModelImpl _$$AdminDashboardModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AdminDashboardModelImpl(
      totalMembers: (json['totalMembers'] as num?)?.toInt() ?? 0,
      totalTrainers: (json['totalTrainers'] as num?)?.toInt() ?? 0,
      totalManagers: (json['totalManagers'] as num?)?.toInt() ?? 0,
      totalGyms: (json['totalGyms'] as num?)?.toInt() ?? 0,
      subscriptions: json['subscriptions'] == null
          ? const SubscriptionSummaryModel()
          : SubscriptionSummaryModel.fromJson(
              json['subscriptions'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AdminDashboardModelImplToJson(
        _$AdminDashboardModelImpl instance) =>
    <String, dynamic>{
      'totalMembers': instance.totalMembers,
      'totalTrainers': instance.totalTrainers,
      'totalManagers': instance.totalManagers,
      'totalGyms': instance.totalGyms,
      'subscriptions': instance.subscriptions,
    };
