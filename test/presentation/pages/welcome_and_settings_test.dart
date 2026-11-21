import 'package:fitness_pro/core/l10n/app_strings.dart';
import 'package:fitness_pro/core/theme/AppTheme.dart';
import 'package:fitness_pro/domain/usecases/get_profile_usecase.dart';
import 'package:fitness_pro/domain/usecases/get_saved_username_usecase.dart';
import 'package:fitness_pro/domain/usecases/signin_usecase.dart';
import 'package:fitness_pro/domain/usecases/signout_usecase.dart';
import 'package:fitness_pro/domain/usecases/signup_usecase.dart';
import 'package:fitness_pro/presentation/blocs/account/account_cubit.dart';
import 'package:fitness_pro/presentation/blocs/auth/auth_bloc.dart';
import 'package:fitness_pro/presentation/blocs/current_user/current_user_cubit.dart';
import 'package:fitness_pro/presentation/blocs/locale/locale_cubit.dart';
import 'package:fitness_pro/presentation/blocs/profile/profile_bloc.dart';
import 'package:fitness_pro/presentation/blocs/profile/profile_event.dart';
import 'package:fitness_pro/presentation/blocs/theme/theme_cubit.dart';
import 'package:fitness_pro/presentation/pages/profile/profile_page.dart';
import 'package:fitness_pro/presentation/pages/welcome/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fake_repositories.dart';

Widget _welcomeApp({Duration duration = const Duration(seconds: 3)}) {
  final auth = FakeAuthRepository();
  final router = GoRouter(
    initialLocation: '/welcome',
    routes: [
      GoRoute(
        path: '/welcome',
        builder: (_, __) => BlocProvider(
          create: (_) =>
              CurrentUserCubit(GetSavedUsernameUseCase(auth))..load(),
          child: WelcomePage(next: '/home', duration: duration),
        ),
      ),
      GoRoute(
          path: '/home',
          builder: (_, __) => const Scaffold(body: Text('dashboard'))),
    ],
  );
  return MaterialApp.router(theme: AppTheme.light, routerConfig: router);
}

/// The profile page wired like the real app: theme and language follow the cubits.
Widget _profileApp(ThemeCubit theme, LocaleCubit locale) {
  final auth = FakeAuthRepository();
  return MultiBlocProvider(
    providers: [
      BlocProvider.value(value: theme),
      BlocProvider.value(value: locale),
      BlocProvider(
        create: (_) => AuthBloc(SignupUseCase(auth), SigninUseCase(auth),
            SignoutUseCase(auth, FakeReminderScheduler())),
      ),
      BlocProvider(
        create: (_) => ProfileBloc(GetProfileUseCase(FakeProfileRepository()))
          ..add(LoadProfile()),
      ),
      BlocProvider(create: (_) => AccountCubit(FakeAccountRepository())..load()),
    ],
    child: BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (_, mode) => BlocBuilder<LocaleCubit, AppLanguage>(
        builder: (_, language) => MaterialApp(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: mode,
          locale: language.locale,
          supportedLocales: const [Locale('en'), Locale('bn')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: const ProfilePage(),
        ),
      ),
    ),
  );
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  tearDown(() => AppStrings.current = AppLanguage.english);

  group('welcome animation', () {
    testWidgets('greets the user, then opens the dashboard', (tester) async {
      await tester.pumpWidget(_welcomeApp());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Welcome back, alim!'), findsOneWidget);
      expect(find.text('dashboard'), findsNothing);

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      expect(find.text('dashboard'), findsOneWidget);
    });

    testWidgets('Skip goes straight to the dashboard', (tester) async {
      await tester.pumpWidget(_welcomeApp(duration: const Duration(seconds: 30)));
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      expect(find.text('dashboard'), findsOneWidget);
    });

    testWidgets('counts reps while the athlete presses', (tester) async {
      await tester.pumpWidget(_welcomeApp(duration: const Duration(seconds: 30)));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('REPS  0'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 850));
      expect(find.text('REPS  1'), findsOneWidget);

      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();
    });
  });

  group('profile settings', () {
    testWidgets('light is the default and Dark switches the whole app',
        (tester) async {
      tester.view.physicalSize = const Size(900, 2000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final theme = ThemeCubit();
      final locale = LocaleCubit();
      addTearDown(theme.close);
      addTearDown(locale.close);

      await tester.pumpWidget(_profileApp(theme, locale));
      await tester.pumpAndSettle();
      expect(theme.state, ThemeMode.light);

      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      expect(theme.state, ThemeMode.dark);
      expect((await SharedPreferences.getInstance()).getBool('is_dark'), isTrue);

      await tester.tap(find.text('Light'));
      await tester.pumpAndSettle();
      expect(theme.state, ThemeMode.light);
    });

    testWidgets('choosing বাংলা turns the page Bangla', (tester) async {
      tester.view.physicalSize = const Size(900, 2000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final theme = ThemeCubit();
      final locale = LocaleCubit();
      addTearDown(theme.close);
      addTearDown(locale.close);

      await tester.pumpWidget(_profileApp(theme, locale));
      await tester.pumpAndSettle();
      expect(find.text('Sign Out'), findsOneWidget);

      await tester.tap(find.text('বাংলা'));
      await tester.pumpAndSettle();

      expect(find.text('সাইন আউট'), findsOneWidget);
      expect(find.text('থিম'), findsOneWidget);
      expect((await SharedPreferences.getInstance()).getString('language'), 'bn');
    });
  });
}
