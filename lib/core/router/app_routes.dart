
/// Single source of truth for route paths.
class AppRoutes {
  AppRoutes._();

  static const splash          = '/';
  static const signin          = '/signin';
  static const signup          = '/signup';

  /// Animated greeting right after sign-in; its `extra` is the dashboard to open next.
  static const welcome         = '/welcome';
  static const ownerDashboard   = '/owner-dashboard';
  static const dashboard        = '/dashboard'; // admin (ROLE_MANAGER)
  static const trainerDashboard = '/trainer-dashboard';
  static const memberDashboard  = '/member-dashboard';

  static const dashboards = {
    ownerDashboard, dashboard, trainerDashboard, memberDashboard,
  };
  static const profile         = '/profile';
  static const notifications   = '/notifications';

  /// Admin's gym-fee collection page (ROLE_MANAGER only).
  static const memberSubscriptions = '/member-subscriptions';

  static const adminUsers      = '/admin/users';
  static const adminGyms       = '/admin/gyms';
  static const trainerMembers  = '/trainer/members';

  /// Pages only an admin (ROLE_MANAGER) may open.
  static const adminOnly = {memberSubscriptions, adminUsers, adminGyms};
}
