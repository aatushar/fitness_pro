import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import '../../domain/entities/subscription_entity.dart';
import '../../domain/services/reminder_scheduler.dart';
import '../../core/l10n/app_strings.dart';

/// [ReminderScheduler] backed by `flutter_local_notifications`: the phone's own
/// alarm manager shows the reminder, so it works with the app closed and
/// needs no Firebase / push server. Does nothing on web and desktop.
class LocalReminderScheduler implements ReminderScheduler {
  static const _warningId = 1001;
  static const _dueId = 1002;

  /// How many days before the end date the first reminder is shown.
  static const warningDays = 3;

  /// Local clock hour of day the reminders are shown at (matches the server job).
  static const reminderHour = 9;

  static const _channelId = 'subscription_reminders';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _ready = false;

  bool get _supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Future<bool> _init() async {
    if (!_supported) return false;
    if (_ready) return true;

    tzdata.initializeTimeZones();
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
    // Android 13+ and iOS ask the user once; later calls are silent.
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    _ready = true;
    return true;
  }

  /// The two moments reminders are due for a subscription ending on [endDate].
  @visibleForTesting
  static ({DateTime warning, DateTime due}) reminderTimes(DateTime endDate) => (
        warning: DateTime(endDate.year, endDate.month,
            endDate.day - warningDays, reminderHour),
        due: DateTime(endDate.year, endDate.month, endDate.day, reminderHour),
      );

  /// For a quick test plan: a warning 1 minute before it ends, and one when it ends.
  @visibleForTesting
  static ({DateTime warning, DateTime due}) testPlanTimes(DateTime expiresAt) => (
        warning: expiresAt.subtract(const Duration(minutes: 1)),
        due: expiresAt,
      );

  /// Minute-long reminders must fire on time, which needs the "exact alarm"
  /// permission on Android 12+. Falls back to a roughly-on-time alarm if the
  /// user does not allow it.
  Future<AndroidScheduleMode> _preciseMode() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return AndroidScheduleMode.inexactAllowWhileIdle;
    var allowed = await android.canScheduleExactNotifications() ?? false;
    if (!allowed) {
      await android.requestExactAlarmsPermission();
      allowed = await android.canScheduleExactNotifications() ?? false;
    }
    return allowed
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;
  }

  @override
  Future<void> scheduleFor(SubscriptionEntity subscription) async {
    if (!await _init()) return;

    await _plugin.cancel(id: _warningId);
    await _plugin.cancel(id: _dueId);

    final expiresAt = subscription.expiresAt;
    if (expiresAt != null) {
      final times = testPlanTimes(expiresAt);
      final now = DateTime.now();
      final mode = await _preciseMode();
      if (times.warning.isAfter(now)) {
        await _schedule(
          id: _warningId,
          at: times.warning,
          title: 'Subscription ending soon'.trNow,
          body: 'Your gym subscription ends in 1 minute. '
              'Please pay your Gym subscription fee.'.trNow,
          mode: mode,
        );
      }
      if (times.due.isAfter(now)) {
        await _schedule(
          id: _dueId,
          at: times.due,
          title: 'Subscription expired'.trNow,
          body: 'Please pay your Gym subscription fee.'.trNow,
          mode: mode,
        );
      }
      return;
    }

    final end = subscription.endDate;
    if (end == null || subscription.status == SubscriptionStatus.none) return;

    final times = reminderTimes(end);
    final now = DateTime.now();
    if (times.warning.isAfter(now)) {
      await _schedule(
        id: _warningId,
        at: times.warning,
        title: 'Subscription ending soon'.trNow,
        body: 'Your gym subscription ends in $warningDays days. '
            'Please pay your Gym subscription fee.'.trNow,
      );
    }
    if (times.due.isAfter(now)) {
      await _schedule(
        id: _dueId,
        at: times.due,
        title: 'Subscription expired'.trNow,
        body: 'Please pay your Gym subscription fee.'.trNow,
      );
    }
  }

  Future<void> _schedule({
    required int id,
    required DateTime at,
    required String title,
    required String body,
    AndroidScheduleMode mode = AndroidScheduleMode.inexactAllowWhileIdle,
  }) {
    return _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      // The instant is what matters, so express it in UTC; no device time
      // zone lookup needed.
      scheduledDate: tz.TZDateTime.from(at, tz.UTC),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          'Subscription reminders'.trNow,
          channelDescription: 'Reminds you to pay your gym subscription fee'.trNow,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      // Monthly reminders (9 AM) are fine inexact and need no special
      // permission; minute-long test plans pass an exact mode.
      androidScheduleMode: mode,
    );
  }

  @override
  Future<void> cancelAll() async {
    if (!await _init()) return;
    await _plugin.cancel(id: _warningId);
    await _plugin.cancel(id: _dueId);
  }
}
