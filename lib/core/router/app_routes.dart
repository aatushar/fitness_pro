/// Single source of truth for route paths.
class AppRoutes {
  AppRoutes._();

  static const splash          = '/';
  static const signin          = '/signin';
  static const signup          = '/signup';
  static const ownerDashboard   = '/owner-dashboard';
  static const dashboard        = '/dashboard'; // admin (ROLE_MANAGER)
  static const trainerDashboard = '/trainer-dashboard';
  static const memberDashboard  = '/member-dashboard';

  static const dashboards = {
    ownerDashboard, dashboard, trainerDashboard, memberDashboard,
  };
  static const profile         = '/profile';
}
