import '../entities/subscription_entity.dart';

/// Puts "please pay your gym fee" reminders on the phone itself, so they pop
/// up on the due dates even when the app is closed and without a push server.
abstract class ReminderScheduler {
  /// Replaces any scheduled reminders with the ones for [subscription]:
  /// a few days before it ends, and on the day it ends.
  Future<void> scheduleFor(SubscriptionEntity subscription);

  /// Removes every scheduled reminder (used on sign out).
  Future<void> cancelAll();
}
