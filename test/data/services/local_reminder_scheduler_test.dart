import 'package:fitness_pro/data/services/local_reminder_scheduler.dart';
import 'package:fitness_pro/domain/entities/subscription_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LocalReminderScheduler.reminderTimes', () {
    test('warns 3 days before the end date and again on it, at 9 AM', () {
      final times = LocalReminderScheduler.reminderTimes(DateTime(2026, 12, 11));

      expect(times.warning, DateTime(2026, 12, 8, 9));
      expect(times.due, DateTime(2026, 12, 11, 9));
    });

    test('counts back across a month and year boundary', () {
      final times = LocalReminderScheduler.reminderTimes(DateTime(2027, 1, 2));

      expect(times.warning, DateTime(2026, 12, 30, 9));
    });
  });

  group('LocalReminderScheduler.testPlanTimes', () {
    test('warns 1 minute before the end and again when it ends', () {
      final end = DateTime(2026, 11, 11, 0, 25, 30);

      final times = LocalReminderScheduler.testPlanTimes(end);

      expect(times.warning, DateTime(2026, 11, 11, 0, 24, 30));
      expect(times.due, end);
    });
  });

  group('on platforms without local notifications (web, desktop, tests)', () {
    // Scheduling must quietly do nothing, never throw.
    test('scheduleFor and cancelAll complete without error', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      final scheduler = LocalReminderScheduler();

      await scheduler.scheduleFor(SubscriptionEntity(
        status: SubscriptionStatus.active,
        endDate: DateTime.now().add(const Duration(days: 30)),
        daysLeft: 30,
        totalDays: 30,
      ));
      await scheduler.cancelAll();
    });
  });
}
