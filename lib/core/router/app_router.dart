import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/di/injection.dart';
import '../../core/storage/token_storage.dart';
import '../../presentation/blocs/admin/admin_dashboard_cubit.dart';
import '../../presentation/blocs/admin/admin_gyms_cubit.dart';
import '../../presentation/blocs/admin/admin_users_cubit.dart';
import '../../presentation/blocs/admin/gym_options_cubit.dart';
import '../../presentation/blocs/account/account_cubit.dart';
import '../../presentation/blocs/current_user/current_user_cubit.dart';
import '../../presentation/blocs/notifications/notifications_cubit.dart';
import '../../presentation/blocs/profile/profile_bloc.dart';
import '../../presentation/blocs/profile/profile_event.dart';
import '../../presentation/blocs/subscription/member_fees_cubit.dart';
import '../../presentation/blocs/subscription/my_subscription_cubit.dart';
import '../../presentation/pages/admin/admin_gyms_page.dart';
import '../../presentation/pages/admin/managed_users_page.dart';
import '../../presentation/pages/auth/signin_page.dart';
import '../../presentation/pages/auth/signup_page.dart';
import '../../presentation/pages/dashboard/dashboard_page.dart';
import '../../presentation/pages/member/member_dashboard_page.dart';
import '../../presentation/pages/notifications/notifications_page.dart';
import '../../presentation/pages/owner/owner_dashboard_page.dart';
import '../../presentation/pages/profile/profile_page.dart';
import '../../presentation/pages/subscriptions/member_subscriptions_page.dart';
import '../../presentation/pages/trainer/trainer_dashboard_page.dart';
import '../../presentation/splash/splash_page.dart';
import 'app_routes.dart';

class AppRouter {
  final TokenStorage tokenStorage;
  AppRouter(this.tokenStorage);

  /// Dashboard for a signed-in user's backend roles. A user with several
  /// roles gets the highest one: OWNER > MANAGER (admin) > TRAINER >
  /// everyone else (ROLE_USER = gym member).
  static String homeForRoles(List<String> roles) {
    if (roles.contains('ROLE_OWNER'))   return AppRoutes.ownerDashboard;
    if (roles.contains('ROLE_MANAGER')) return AppRoutes.dashboard;
    if (roles.contains('ROLE_TRAINER')) return AppRoutes.trainerDashboard;
    return AppRoutes.memberDashboard;
  }

  /// Where [location] must send the user instead, or null to let them in.
  /// Pure so the access rules can be tested without building any page.
  @visibleForTesting
  static String? redirectFor({
    required String location,
    required bool hasToken,
    required List<String> roles,
  }) {
    // Splash leaves on its own timer (to sign-in) and is redirected from there.
    if (location == AppRoutes.splash) return null;

    final onAuthPage =
        location == AppRoutes.signin || location == AppRoutes.signup;
    if (!hasToken) return onAuthPage ? null : AppRoutes.signin;

    // Token আছে — role দেখে সঠিক dashboard এ পাঠাও
    final home = homeForRoles(roles);
    if (onAuthPage) return home;
    // A user may only open their own role's dashboard.
    if (AppRoutes.dashboards.contains(location) && location != home) {
      return home;
    }
    // Fee collection is the admin's job; the backend refuses everyone else.
    if (AppRoutes.adminOnly.contains(location) &&
        !roles.contains('ROLE_MANAGER')) {
      return home;
    }
    // Trainer's member list: trainers and admins only.
    if (location == AppRoutes.trainerMembers &&
        !roles.contains('ROLE_MANAGER') &&
        !roles.contains('ROLE_TRAINER')) {
      return home;
    }
    return null;
  }

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) async => redirectFor(
      location: state.matchedLocation,
      hasToken: await tokenStorage.hasToken(),
      roles: await tokenStorage.getRoles(),
    ),
    routes: [
      GoRoute(path: AppRoutes.splash,
          builder: (_, __) => const SplashPage()),
      GoRoute(path: AppRoutes.signin,
          builder: (_, __) => const SigninPage()),
      GoRoute(path: AppRoutes.signup,
          builder: (_, __) => BlocProvider(
            create: (_) => sl<GymOptionsCubit>()..load(),
            child: const SignupPage(),
          )),
      _dashboardRoute(AppRoutes.ownerDashboard, const OwnerDashboardPage()),
      _dashboardRoute(
        AppRoutes.dashboard,
        const DashboardPage(),
        extraProviders: [
          BlocProvider<AdminDashboardCubit>(
            create: (_) => sl<AdminDashboardCubit>()..load(),
          ),
        ],
      ),
      _dashboardRoute(
        AppRoutes.trainerDashboard,
        const TrainerDashboardPage(),
        extraProviders: [
          BlocProvider<AdminUsersCubit>(
            create: (_) => sl<AdminUsersCubit>(instanceName: 'trainerMembers')..load(),
          ),
        ],
      ),
      _dashboardRoute(
        AppRoutes.memberDashboard,
        const MemberDashboardPage(),
        // The member's own subscription card (also sets the phone reminders).
        extraProviders: [
          BlocProvider<MySubscriptionCubit>(
            create: (_) => sl<MySubscriptionCubit>()..load(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (_, __) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<ProfileBloc>()..add(LoadProfile())),
            BlocProvider(create: (_) => sl<AccountCubit>()..load()),
          ],
          child: const ProfilePage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.adminUsers,
        builder: (_, __) => BlocProvider(
          create: (_) => sl<AdminUsersCubit>()..load(),
          child: const ManagedUsersPage(manage: true),
        ),
      ),
      GoRoute(
        path: AppRoutes.trainerMembers,
        builder: (_, __) => BlocProvider(
          create: (_) => sl<AdminUsersCubit>(instanceName: 'trainerMembers')..load(),
          child: const ManagedUsersPage(manage: false),
        ),
      ),
      GoRoute(
        path: AppRoutes.adminGyms,
        builder: (_, __) => BlocProvider(
          create: (_) => sl<AdminGymsCubit>()..load(),
          child: const AdminGymsPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (_, __) => BlocProvider(
          create: (_) => sl<NotificationsCubit>()..load(),
          child: const NotificationsPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.memberSubscriptions,
        builder: (_, __) => BlocProvider(
          create: (_) => sl<MemberFeesCubit>()..load(),
          child: const MemberSubscriptionsPage(),
        ),
      ),
    ],
  );

  /// Every dashboard shows the signed-in user's name and the notification
  /// bell, so each gets a page-scoped [CurrentUserCubit] and [NotificationsCubit].
  static GoRoute _dashboardRoute(
    String path,
    Widget page, {
    List<BlocProvider> extraProviders = const [],
  }) =>
      GoRoute(
        path: path,
        builder: (_, __) => MultiBlocProvider(
          providers: [
            BlocProvider<CurrentUserCubit>(
              create: (_) => sl<CurrentUserCubit>()..load(),
            ),
            BlocProvider<NotificationsCubit>(
              create: (_) => sl<NotificationsCubit>()..load(),
            ),
            ...extraProviders,
          ],
          child: page,
        ),
      );
}
