import 'package:flutter/material.dart';
import '../../../domain/entities/subscription_entity.dart';
import '../dashboard/dashboard_cards.dart';

/// Short user-facing name of a subscription status.
String subscriptionStatusLabel(SubscriptionStatus status) => switch (status) {
      SubscriptionStatus.active => 'Active',
      SubscriptionStatus.expiringSoon => 'Expiring soon',
      SubscriptionStatus.expired => 'Expired',
      SubscriptionStatus.none => 'No plan',
    };

/// Coloured pill for a member's subscription status.
class SubscriptionStatusChip extends StatelessWidget {
  final SubscriptionStatus status;
  const SubscriptionStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return StatusChip(
      label: subscriptionStatusLabel(status),
      tone: switch (status) {
        SubscriptionStatus.active => ChipTone.success,
        SubscriptionStatus.expiringSoon => ChipTone.warning,
        SubscriptionStatus.expired => ChipTone.danger,
        SubscriptionStatus.none => ChipTone.info,
      },
    );
  }
}
