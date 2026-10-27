import 'package:fitness_pro/core/router/app_router.dart';
import 'package:fitness_pro/core/router/app_routes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppRouter.homeForRoles', () {
    test('owner → owner dashboard', () {
      expect(AppRouter.homeForRoles(['ROLE_OWNER']), AppRoutes.ownerDashboard);
    });

    test('manager (admin) → admin dashboard', () {
      expect(AppRouter.homeForRoles(['ROLE_MANAGER']), AppRoutes.dashboard);
    });

    test('trainer → trainer dashboard', () {
      expect(AppRouter.homeForRoles(['ROLE_TRAINER']), AppRoutes.trainerDashboard);
    });

    test('user (member) → member dashboard', () {
      expect(AppRouter.homeForRoles(['ROLE_USER']), AppRoutes.memberDashboard);
    });

    test('no roles → member dashboard', () {
      expect(AppRouter.homeForRoles([]), AppRoutes.memberDashboard);
    });

    test('several roles → the highest one wins', () {
      // The seeded "admin" user has all three of these.
      expect(
        AppRouter.homeForRoles(['ROLE_USER', 'ROLE_TRAINER', 'ROLE_MANAGER']),
        AppRoutes.dashboard,
      );
      expect(
        AppRouter.homeForRoles(['ROLE_MANAGER', 'ROLE_OWNER']),
        AppRoutes.ownerDashboard,
      );
    });
  });
}
