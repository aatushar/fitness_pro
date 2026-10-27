import 'package:fitness_pro/core/theme/app_colors.dart';
import 'package:fitness_pro/core/theme/app_palette.dart';
import 'package:fitness_pro/domain/usecases/get_profile_usecase.dart';
import 'package:fitness_pro/domain/usecases/get_saved_username_usecase.dart';
import 'package:fitness_pro/domain/usecases/signin_usecase.dart';
import 'package:fitness_pro/domain/usecases/signout_usecase.dart';
import 'package:fitness_pro/domain/usecases/signup_usecase.dart';
import 'package:fitness_pro/presentation/blocs/auth/auth_bloc.dart';
import 'package:fitness_pro/presentation/blocs/current_user/current_user_cubit.dart';
import 'package:fitness_pro/presentation/blocs/profile/profile_bloc.dart';
import 'package:fitness_pro/presentation/blocs/profile/profile_event.dart';
import 'package:fitness_pro/presentation/blocs/theme/theme_cubit.dart';
import 'package:fitness_pro/presentation/pages/auth/signin_page.dart';
import 'package:fitness_pro/presentation/pages/auth/signup_page.dart';
import 'package:fitness_pro/presentation/pages/dashboard/dashboard_page.dart';
import 'package:fitness_pro/presentation/pages/member/member_dashboard_page.dart';
import 'package:fitness_pro/presentation/pages/owner/owner_dashboard_page.dart';
import 'package:fitness_pro/presentation/pages/trainer/trainer_dashboard_page.dart';
import 'package:fitness_pro/presentation/pages/profile/profile_page.dart';
import 'package:fitness_pro/presentation/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fake_repositories.dart';

/// Pumps every page at phone / landscape / tablet / desktop sizes, at normal
/// and large system font scale, in both themes, and fails on any overflow.

const _sizes = {
  'small phone 320x568': Size(320, 568),
  'phone 390x844': Size(390, 844),
  'phone landscape 844x390': Size(844, 390),
  'tablet 820x1180': Size(820, 1180),
  'desktop 1440x900': Size(1440, 900),
};

const _textScales = [1.0, 2.0];

// AppTheme uses google_fonts, which fetches over the network; tests can't,
// so mirror its colors here with the default test font.
ThemeData _theme(Brightness b) {
  final dark = b == Brightness.dark;
  return ThemeData(
    brightness: b,
    scaffoldBackgroundColor: dark ? AppColors.darkBg : AppColors.lightBg,
    colorScheme: dark
        ? const ColorScheme.dark(
            primary: AppColors.purple, surface: AppColors.darkSurface)
        : const ColorScheme.light(
            primary: AppColors.purple, surface: AppColors.lightSurface),
    extensions: [dark ? AppPalette.dark : AppPalette.light],
  );
}

final _pages = <String, Widget Function()>{
  'Splash': () => const SplashPage(),
  'Signin': () => const SigninPage(),
  'Signup': () => const SignupPage(),
  'Dashboard': () => BlocProvider(
        create: (_) =>
            CurrentUserCubit(GetSavedUsernameUseCase(FakeAuthRepository()))
              ..load(),
        child: const DashboardPage(),
      ),
  'Owner dashboard': () => BlocProvider(
        create: (_) =>
            CurrentUserCubit(GetSavedUsernameUseCase(FakeAuthRepository()))
              ..load(),
        child: const OwnerDashboardPage(),
      ),
  'Trainer dashboard': () => BlocProvider(
        create: (_) =>
            CurrentUserCubit(GetSavedUsernameUseCase(FakeAuthRepository()))
              ..load(),
        child: const TrainerDashboardPage(),
      ),
  'Member dashboard': () => BlocProvider(
        create: (_) => CurrentUserCubit(GetSavedUsernameUseCase(
            FakeAuthRepository()..savedUsername = 'Mohammad Rakibul Hasan'))
          ..load(),
        child: const MemberDashboardPage(),
      ),
  'Profile': () => BlocProvider(
        create: (_) =>
            ProfileBloc(GetProfileUseCase(FakeProfileRepository()))
              ..add(LoadProfile()),
        child: const ProfilePage(),
      ),
  'Profile error': () => BlocProvider(
        create: (_) => ProfileBloc(GetProfileUseCase(
            FakeProfileRepository()..error = StateError('x')))
          ..add(LoadProfile()),
        child: const ProfilePage(),
      ),
};

Widget _app(Widget Function() page, Brightness brightness) {
  final auth = FakeAuthRepository();
  final router = GoRouter(
    initialLocation: '/page',
    routes: [
      GoRoute(path: '/page', builder: (_, __) => page()),
      GoRoute(path: '/signin', builder: (_, __) => const SizedBox()),
    ],
  );
  return MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => ThemeCubit()),
      BlocProvider(
        create: (_) => AuthBloc(
            SignupUseCase(auth), SigninUseCase(auth), SignoutUseCase(auth)),
      ),
    ],
    child: MaterialApp.router(
      theme: _theme(brightness),
      routerConfig: router,
    ),
  );
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  for (final page in _pages.entries) {
    for (final size in _sizes.entries) {
      for (final scale in _textScales) {
        for (final brightness in Brightness.values) {
          testWidgets(
              '${page.key} · ${size.key} · text x$scale · ${brightness.name}',
              (tester) async {
            tester.view.physicalSize = size.value;
            tester.view.devicePixelRatio = 1;
            tester.platformDispatcher.textScaleFactorTestValue = scale;
            addTearDown(tester.view.reset);
            addTearDown(tester.platformDispatcher.clearAllTestValues);

            await tester.pumpWidget(_app(page.value, brightness));
            await tester.pump(const Duration(milliseconds: 100));

            final errors = <Object>[];
            Object? e;
            while ((e = tester.takeException()) != null) {
              errors.add(e!);
            }
            expect(errors, isEmpty);

            // Let the splash timer fire so no timer is left pending.
            await tester.pump(const Duration(seconds: 3));
            expect(tester.takeException(), isNull);
          });
        }
      }
    }
  }
}
