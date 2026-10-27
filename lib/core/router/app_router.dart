import 'package:fitness_pro/presentation/blocs/profile/profile_event.dart';
import 'package:fitness_pro/presentation/pages/member/member_dashboard_page.dart';
import 'package:fitness_pro/presentation/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/di/injection.dart';
import '../../core/storage/token_storage.dart';
import '../../presentation/blocs/profile/profile_bloc.dart';
import '../../presentation/pages/auth/signin_page.dart';
import '../../presentation/pages/auth/signup_page.dart';
import '../../presentation/pages/dashboard/dashboard_page.dart';
import '../../presentation/pages/profile/profile_page.dart';


class AppRouter {
  final TokenStorage tokenStorage;
  AppRouter(this.tokenStorage);

  late final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      final hasToken = await tokenStorage.hasToken();
      final onAuth = state.matchedLocation == '/signin' ||
          state.matchedLocation == '/signup' ||
          state.matchedLocation == '/';
      if (!hasToken && !onAuth) return '/signin';
      if (hasToken && onAuth) {
        // Token আছে — role দেখে navigate করো
        final roles = await tokenStorage.getRoles();
        if (roles.contains('ROLE_MEMBER')) return '/member-dashboard';
        return '/dashboard';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/',
          builder: (_, __) => const SplashPage()),
      GoRoute(path: '/signin',
          builder: (_, __) => const SigninPage()),
      GoRoute(path: '/signup',
          builder: (_, __) => const SignupPage()),
      GoRoute(path: '/dashboard',
          builder: (_, __) => const DashboardPage()),
      GoRoute(path: '/member-dashboard',
          builder: (_, __) => const MemberDashboardPage()),
      GoRoute(
        path: '/profile',
        builder: (_, __) => BlocProvider(
          create: (_) => sl<ProfileBloc>()..add(LoadProfile()),
          child: const ProfilePage(),
        ),
      ),
    ],
  );
}