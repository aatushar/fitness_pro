import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/di/injection.dart';
import '../../core/storage/token_storage.dart';
import '../../presentation/blocs/current_user/current_user_cubit.dart';
import '../../presentation/blocs/profile/profile_bloc.dart';
import '../../presentation/blocs/profile/profile_event.dart';
import '../../presentation/pages/auth/signin_page.dart';
import '../../presentation/pages/auth/signup_page.dart';
import '../../presentation/pages/dashboard/dashboard_page.dart';
import '../../presentation/pages/member/member_dashboard_page.dart';
import '../../presentation/pages/owner/owner_dashboard_page.dart';
import '../../presentation/pages/profile/profile_page.dart';
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

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) async {
      final location = state.matchedLocation;
      // Splash leaves on its own timer (to sign-in) and is redirected from there.
      if (location == AppRoutes.splash) return null;

      final onAuthPage =
          location == AppRoutes.signin || location == AppRoutes.signup;
      final hasToken = await tokenStorage.hasToken();
      if (!hasToken) return onAuthPage ? null : AppRoutes.signin;

      // Token আছে — role দেখে সঠিক dashboard এ পাঠাও
      final home = homeForRoles(await tokenStorage.getRoles());
      if (onAuthPage) return home;
      // A user may only open their own role's dashboard.
      if (AppRoutes.dashboards.contains(location) && location != home) {
        return home;
      }
      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.splash,
          builder: (_, __) => const SplashPage()),
      GoRoute(path: AppRoutes.signin,
          builder: (_, __) => const SigninPage()),
      GoRoute(path: AppRoutes.signup,
          builder: (_, __) => const SignupPage()),
      _dashboardRoute(AppRoutes.ownerDashboard, const OwnerDashboardPage()),
      _dashboardRoute(AppRoutes.dashboard, const DashboardPage()),
      _dashboardRoute(AppRoutes.trainerDashboard, const TrainerDashboardPage()),
      _dashboardRoute(AppRoutes.memberDashboard, const MemberDashboardPage()),
      GoRoute(
        path: AppRoutes.profile,
        builder: (_, __) => BlocProvider(
          create: (_) => sl<ProfileBloc>()..add(LoadProfile()),
          child: const ProfilePage(),
        ),
      ),
    ],
  );

  /// Every dashboard shows the signed-in user's name, so each gets a
  /// page-scoped [CurrentUserCubit].
  static GoRoute _dashboardRoute(String path, Widget page) => GoRoute(
        path: path,
        builder: (_, __) => BlocProvider(
          create: (_) => sl<CurrentUserCubit>()..load(),
          child: page,
        ),
      );
}
