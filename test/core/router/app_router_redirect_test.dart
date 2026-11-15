import 'package:fitness_pro/core/router/app_router.dart';
import 'package:fitness_pro/core/router/app_routes.dart';
import 'package:flutter_test/flutter_test.dart';

String? _redirect(String location, {bool hasToken = true, List<String> roles = const ['ROLE_USER']}) =>
    AppRouter.redirectFor(location: location, hasToken: hasToken, roles: roles);

void main() {
  group('signed out', () {
    test('may open the sign in and sign up pages', () {
      expect(_redirect(AppRoutes.signin, hasToken: false), isNull);
      expect(_redirect(AppRoutes.signup, hasToken: false), isNull);
    });

    test('is sent to sign in from everything else, fee page included', () {
      expect(_redirect(AppRoutes.memberDashboard, hasToken: false), AppRoutes.signin);
      expect(_redirect(AppRoutes.memberSubscriptions, hasToken: false), AppRoutes.signin);
      expect(_redirect(AppRoutes.notifications, hasToken: false), AppRoutes.signin);
    });
  });

  group('signed in', () {
    test('splash is never redirected', () {
      expect(_redirect(AppRoutes.splash, hasToken: false), isNull);
    });

    test('is moved off the auth pages to their own dashboard', () {
      expect(_redirect(AppRoutes.signin), AppRoutes.memberDashboard);
      expect(_redirect(AppRoutes.signup, roles: ['ROLE_MANAGER']), AppRoutes.dashboard);
    });

    test('may only open the dashboard of their own role', () {
      expect(_redirect(AppRoutes.dashboard), AppRoutes.memberDashboard);
      expect(_redirect(AppRoutes.memberDashboard), isNull);
    });

    test('everyone may open notifications and profile', () {
      expect(_redirect(AppRoutes.notifications), isNull);
      expect(_redirect(AppRoutes.profile), isNull);
    });
  });

  group('member fee page (admin only)', () {
    test('a manager may open it', () {
      expect(
        _redirect(AppRoutes.memberSubscriptions, roles: ['ROLE_USER', 'ROLE_MANAGER']),
        isNull,
      );
    });

    test('a member is sent back to their own dashboard', () {
      expect(_redirect(AppRoutes.memberSubscriptions), AppRoutes.memberDashboard);
    });

    test('a trainer is sent back to the trainer dashboard', () {
      expect(
        _redirect(AppRoutes.memberSubscriptions, roles: ['ROLE_TRAINER']),
        AppRoutes.trainerDashboard,
      );
    });
  });
}
