import 'package:fitness_pro/presentation/blocs/profile/profile_event.dart';
import 'package:fitness_pro/presentation/pages/profile/profile_page.dart';
import 'package:fitness_pro/presentation/splash/splash_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/di/injection.dart';
import '../../core/storage/token_storage.dart';
import '../../presentation/blocs/profile/profile_bloc.dart';
import '../../presentation/pages/auth/signin_page.dart';
import '../../presentation/pages/auth/signup_page.dart';
import '../../presentation/pages/dashboard/dashboard_page.dart';


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
      if (hasToken && onAuth) return '/dashboard';
      return null;
    },
    routes: [
      GoRoute(path: '/',          builder: (_, __) => const SplashPage()),
      GoRoute(path: '/signin',    builder: (_, __) => const SigninPage()),
      GoRoute(path: '/signup',    builder: (_, __) => const SignupPage()),
      GoRoute(path: '/dashboard', builder: (_, __) => const DashboardPage()),
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