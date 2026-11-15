import 'package:fitness_pro/data/models/activate_subscription_request_model.dart';
import 'package:fitness_pro/data/models/member_subscription_model.dart';
import 'package:fitness_pro/data/models/notification_model.dart';
import 'package:fitness_pro/data/models/subscription_model.dart';
import 'package:fitness_pro/data/models/subscription_summary_model.dart';
import 'package:fitness_pro/domain/entities/subscription_entity.dart';
import 'package:flutter_test/flutter_test.dart';

const activeSubscriptionForTest = SubscriptionEntity(
  status: SubscriptionStatus.active,
  daysLeft: 20,
  totalDays: 30,
  planMonths: 1,
);

void main() {
  group('SubscriptionModel', () {
    test('fromJson + toEntity map an active subscription', () {
      // Exactly what GET /api/member/subscription returned in testing.
      final entity = SubscriptionModel.fromJson({
        'status': 'ACTIVE',
        'startDate': '2026-11-11',
        'endDate': '2027-02-11',
        'daysLeft': 92,
        'totalDays': 92,
        'planMonths': 2,
        'lastAmount': 3000.00,
      }).toEntity();

      expect(entity.status, SubscriptionStatus.active);
      expect(entity.startDate, DateTime(2026, 11, 11));
      expect(entity.endDate, DateTime(2027, 2, 11));
      expect(entity.daysLeft, 92);
      expect(entity.totalDays, 92);
      expect(entity.planMonths, 2);
      expect(entity.lastAmount, 3000);
      expect(entity.hasAccess, isTrue);
    });

    test('a member who never subscribed has null dates and no access', () {
      final entity = SubscriptionModel.fromJson({
        'status': 'NONE',
        'startDate': null,
        'endDate': null,
        'daysLeft': 0,
        'totalDays': 0,
        'planMonths': null,
        'lastAmount': null,
      }).toEntity();

      expect(entity.status, SubscriptionStatus.none);
      expect(entity.endDate, isNull);
      expect(entity.hasAccess, isFalse);
      expect(entity.progress, 0);
    });

    test('maps every status and treats unknown text as none', () {
      expect(subscriptionStatusFromString('ACTIVE'), SubscriptionStatus.active);
      expect(subscriptionStatusFromString('EXPIRING_SOON'),
          SubscriptionStatus.expiringSoon);
      expect(subscriptionStatusFromString('EXPIRED'), SubscriptionStatus.expired);
      expect(subscriptionStatusFromString('SOMETHING_NEW'), SubscriptionStatus.none);
      expect(subscriptionStatusFromString(null), SubscriptionStatus.none);
    });

    test('progress is the used share of the period, kept within 0..1', () {
      const half = SubscriptionEntity(
          status: SubscriptionStatus.active, daysLeft: 15, totalDays: 30);
      const over = SubscriptionEntity(
          status: SubscriptionStatus.expired, daysLeft: 0, totalDays: 30);
      expect(half.progress, 0.5);
      expect(over.progress, 1);
    });

    test('expiring soon still has access', () {
      const s = SubscriptionEntity(
          status: SubscriptionStatus.expiringSoon, daysLeft: 2, totalDays: 30);
      expect(s.hasAccess, isTrue);
    });
  });

  test('a minutes-long test plan carries its exact end moment', () {
    // Shape of the server reply for a 2 minute test plan (offset included).
    final entity = SubscriptionModel.fromJson({
      'status': 'ACTIVE',
      'startDate': '2026-11-11',
      'endDate': '2026-11-11',
      'daysLeft': 0,
      'totalDays': 1,
      'planMonths': 0,
      'planMinutes': 2,
      'expiresAt': '2026-11-11T00:25:00+06:00',
      'lastAmount': 1,
    }).toEntity();

    expect(entity.isTestPlan, isTrue);
    expect(entity.planMinutes, 2);
    expect(entity.expiresAt, DateTime.utc(2026, 11, 10, 18, 25));
    expect(entity.hasAccess, isTrue);
  });

  test('testProgress runs from 0 at the start to 1 at the end', () {
    final end = DateTime(2026, 11, 11, 0, 25);
    final plan = SubscriptionEntity(
      status: SubscriptionStatus.active,
      expiresAt: end,
      planMinutes: 2,
    );

    expect(plan.testProgress(end.subtract(const Duration(minutes: 2))), 0);
    expect(plan.testProgress(end.subtract(const Duration(minutes: 1))), 0.5);
    expect(plan.testProgress(end), 1);
    expect(plan.testProgress(end.add(const Duration(minutes: 5))), 1);
  });

  test('a monthly plan is not a test plan', () {
    expect(activeSubscriptionForTest.isTestPlan, isFalse);
  });

  test('MemberSubscriptionModel maps a row of the admin list', () {
    final entity = MemberSubscriptionModel.fromJson({
      'userId': 13,
      'username': 'zzmember2',
      'email': 'zzmember2@test.local',
      'phone': null,
      'status': 'EXPIRED',
      'endDate': '2026-11-10',
      'daysLeft': 0,
      'lastAmount': 500.00,
    }).toEntity();

    expect(entity.userId, 13);
    expect(entity.phone, isNull);
    expect(entity.status, SubscriptionStatus.expired);
    expect(entity.endDate, DateTime(2026, 11, 10));
    expect(entity.lastAmount, 500);
  });

  test('SubscriptionSummaryModel maps counts and the collected amount', () {
    final entity = SubscriptionSummaryModel.fromJson({
      'totalMembers': 3,
      'active': 0,
      'expiringSoon': 1,
      'expired': 1,
      'notSubscribed': 1,
      'collectedThisMonth': 3500.00,
    }).toEntity();

    expect(entity.totalMembers, 3);
    expect(entity.expiringSoon, 1);
    expect(entity.notSubscribed, 1);
    expect(entity.collectedThisMonth, 3500);
  });

  group('NotificationModel', () {
    test('maps a notification with its timestamp', () {
      final entity = NotificationModel.fromJson({
        'id': 2,
        'title': 'Subscription ending soon',
        'message': 'Your gym subscription ends in 2 days. '
            'Please pay your Gym subscription fee.',
        'type': 'SUBSCRIPTION_EXPIRING',
        'read': false,
        'createdAt': '2026-11-11T00:21:03.689157',
      }).toEntity();

      expect(entity.id, 2);
      expect(entity.read, isFalse);
      expect(entity.createdAt, DateTime(2026, 11, 11, 0, 21, 3, 689, 157));
      expect(entity.type, 'SUBSCRIPTION_EXPIRING');
    });

    test('a missing read flag means unread', () {
      final entity = NotificationModel.fromJson({
        'id': 1,
        'title': 't',
        'message': 'm',
        'createdAt': '2026-11-11T09:00:00',
      }).toEntity();
      expect(entity.read, isFalse);
    });
  });

  test('a test-plan request sends testMinutes and leaves months out', () {
    const request = ActivateSubscriptionRequestModel(
      userId: 12,
      testMinutes: 3,
      amount: 1,
      paymentMethod: 'CASH',
    );
    final json = request.toJson();
    expect(json['testMinutes'], 3);
    expect(json.containsKey('months'), isFalse);
  });

  test('ActivateSubscriptionRequestModel.toJson matches what the API expects', () {
    const request = ActivateSubscriptionRequestModel(
      userId: 12,
      months: 3,
      amount: 4500,
      paymentMethod: 'BKASH',
      note: 'paid in full',
    );
    expect(request.toJson(), {
      'userId': 12,
      'months': 3,
      'amount': 4500.0,
      'paymentMethod': 'BKASH',
      'note': 'paid in full',
    });
  });
}
