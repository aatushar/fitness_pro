import 'package:fitness_pro/domain/entities/birth_info_entity.dart';
import 'package:fitness_pro/domain/usecases/get_birth_info_usecase.dart';
import 'package:fitness_pro/domain/usecases/save_birth_info_usecase.dart';
import 'package:fitness_pro/domain/entities/bmi_category.dart';
import 'package:fitness_pro/domain/entities/bmi_record_entity.dart';
import 'package:fitness_pro/domain/usecases/get_bmi_usecase.dart';
import 'package:fitness_pro/domain/usecases/save_bmi_usecase.dart';
import 'package:fitness_pro/presentation/blocs/age/age_cubit.dart';
import 'package:fitness_pro/presentation/blocs/bmi/bmi_cubit.dart';
import 'package:fitness_pro/presentation/blocs/account/account_cubit.dart';
import 'package:fitness_pro/presentation/blocs/admin/admin_dashboard_cubit.dart';
import 'package:fitness_pro/presentation/blocs/admin/admin_gyms_cubit.dart';
import 'package:fitness_pro/presentation/blocs/admin/admin_users_cubit.dart';
import 'package:fitness_pro/presentation/blocs/admin/gym_options_cubit.dart';
import 'package:fitness_pro/presentation/pages/admin/admin_gyms_page.dart';
import 'package:fitness_pro/presentation/pages/admin/managed_users_page.dart';
import 'package:fitness_pro/core/theme/app_colors.dart';
import 'package:fitness_pro/core/theme/app_palette.dart';
import 'package:fitness_pro/domain/entities/app_notification_entity.dart';
import 'package:fitness_pro/domain/entities/member_subscription_entity.dart';
import 'package:fitness_pro/domain/entities/subscription_entity.dart';
import 'package:fitness_pro/domain/usecases/activate_subscription_usecase.dart';
import 'package:fitness_pro/domain/usecases/get_member_subscriptions_usecase.dart';
import 'package:fitness_pro/domain/usecases/get_my_subscription_usecase.dart';
import 'package:fitness_pro/domain/usecases/get_notifications_usecase.dart';
import 'package:fitness_pro/domain/usecases/get_profile_usecase.dart';
import 'package:fitness_pro/domain/usecases/mark_notifications_read_usecase.dart';
import 'package:fitness_pro/domain/usecases/get_saved_username_usecase.dart';
import 'package:fitness_pro/domain/usecases/signin_usecase.dart';
import 'package:fitness_pro/domain/usecases/signout_usecase.dart';
import 'package:fitness_pro/domain/usecases/signup_usecase.dart';
import 'package:fitness_pro/presentation/blocs/auth/auth_bloc.dart';
import 'package:fitness_pro/presentation/blocs/current_user/current_user_cubit.dart';
import 'package:fitness_pro/presentation/blocs/notifications/notifications_cubit.dart';
import 'package:fitness_pro/presentation/blocs/profile/profile_bloc.dart';
import 'package:fitness_pro/presentation/blocs/profile/profile_event.dart';
import 'package:fitness_pro/presentation/blocs/subscription/member_fees_cubit.dart';
import 'package:fitness_pro/presentation/blocs/subscription/my_subscription_cubit.dart';
import 'package:fitness_pro/presentation/blocs/theme/theme_cubit.dart';
import 'package:fitness_pro/presentation/pages/auth/signin_page.dart';
import 'package:fitness_pro/presentation/pages/auth/signup_page.dart';
import 'package:fitness_pro/presentation/pages/dashboard/dashboard_page.dart';
import 'package:fitness_pro/presentation/pages/member/member_dashboard_page.dart';
import 'package:fitness_pro/presentation/pages/notifications/notifications_page.dart';
import 'package:fitness_pro/presentation/pages/owner/owner_dashboard_page.dart';
import 'package:fitness_pro/presentation/pages/subscriptions/member_subscriptions_page.dart';
import 'package:fitness_pro/presentation/pages/trainer/trainer_dashboard_page.dart';
import 'package:fitness_pro/presentation/pages/profile/profile_page.dart';
import 'package:fitness_pro/presentation/pages/welcome/welcome_page.dart';
import 'package:fitness_pro/presentation/splash/splash_page.dart';
import 'package:fitness_pro/core/l10n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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

/// Every dashboard shows the user's name and the notification bell.
Widget _dashboard(
  Widget page, {
  String? username,
  List<BlocProvider> extra = const [],
}) {
  final auth = FakeAuthRepository();
  if (username != null) auth.savedUsername = username;
  final notifications = FakeNotificationRepository()
    ..items = [
      AppNotificationEntity(
        id: 1,
        title: 'Subscription ending soon',
        message: 'Your gym subscription ends in 2 days. '
            'Please pay your Gym subscription fee.',
        type: 'SUBSCRIPTION_EXPIRING',
        read: false,
        createdAt: DateTime(2026, 11, 11, 9),
      ),
    ];
  return MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => CurrentUserCubit(GetSavedUsernameUseCase(auth))..load(),
      ),
      BlocProvider(
        create: (_) => NotificationsCubit(
          GetNotificationsUseCase(notifications),
          MarkNotificationsReadUseCase(notifications),
        )..load(),
      ),
      BlocProvider<AgeCubit>(
        create: (_) {
          final age = FakeAgeRepository()
            ..info = BirthInfoEntity(birthDateTime: DateTime(1995, 5, 17, 15, 27));
          return AgeCubit(GetBirthInfoUseCase(age), SaveBirthInfoUseCase(age))
            ..load();
        },
      ),
      BlocProvider<BmiCubit>(
        create: (_) {
          final bmi = FakeBmiRepository()
            ..records.addAll([
              for (var i = 0; i < 5; i++)
                BmiRecordEntity(
                  id: i + 1,
                  heightCm: 175,
                  weightKg: 78 - i * 2.5,
                  bmi: BmiCategory.bmiOf(heightCm: 175, weightKg: 78 - i * 2.5),
                  gender: 'MALE',
                  ageYears: 30,
                  createdAt: DateTime(2026, 6 + i, 10),
                ),
            ]);
          return BmiCubit(GetBmiUseCase(bmi), SaveBmiUseCase(bmi))..load();
        },
      ),
      ...extra,
    ],
    child: page,
  );
}

BlocProvider<MySubscriptionCubit> _mySubscription(SubscriptionEntity s) =>
    BlocProvider(
      create: (_) => MySubscriptionCubit(
        GetMySubscriptionUseCase(FakeSubscriptionRepository()..mine = s),
        FakeReminderScheduler(),
      )..load(),
    );

final _expiredSubscription = SubscriptionEntity(
  status: SubscriptionStatus.expired,
  startDate: DateTime(2026, 10, 10),
  endDate: DateTime(2026, 11, 10),
  daysLeft: 0,
  totalDays: 31,
  planMonths: 1,
);

final _expiringSubscription = SubscriptionEntity(
  status: SubscriptionStatus.expiringSoon,
  startDate: DateTime(2026, 10, 14),
  endDate: DateTime(2026, 11, 13),
  daysLeft: 2,
  totalDays: 30,
  planMonths: 1,
);

const _noSubscription = SubscriptionEntity(status: SubscriptionStatus.none);

FakeSubscriptionRepository _gymMembers() => FakeSubscriptionRepository()
  ..members = [
    for (final (i, status) in SubscriptionStatus.values.indexed)
      MemberSubscriptionEntity(
        userId: i + 1,
        username: 'a_member_with_a_rather_long_username_$i',
        email: 'member$i@example.com',
        phone: '0170000000$i',
        status: status,
        endDate: status == SubscriptionStatus.none ? null : DateTime(2026, 12, 1),
        daysLeft: status == SubscriptionStatus.expired ? 0 : 12,
        lastAmount: 1500,
      ),
  ];

final _pages = <String, Widget Function()>{
  'Splash': () => const SplashPage(),
  'Welcome': () => _dashboard(const WelcomePage(next: '/signin')),
  'Signin': () => const SigninPage(),
  'Signup': () => BlocProvider(
        create: (_) => GymOptionsCubit(FakeAdminRepository())..load(),
        child: const SignupPage(),
      ),
  'Dashboard': () => _dashboard(const DashboardPage(), extra: [
        BlocProvider<AdminDashboardCubit>(
          create: (_) => AdminDashboardCubit(FakeAdminRepository())..load(),
        ),
      ]),
  'Owner dashboard': () => _dashboard(const OwnerDashboardPage()),
  'Trainer dashboard': () => _dashboard(const TrainerDashboardPage(), extra: [
        BlocProvider<AdminUsersCubit>(
          create: (_) =>
              AdminUsersCubit(FakeAdminRepository(), trainerMode: true)..load(),
        ),
      ]),
  'Users': () => BlocProvider(
        create: (_) => AdminUsersCubit(FakeAdminRepository())..load(),
        child: const ManagedUsersPage(manage: true),
      ),
  'Gyms': () => BlocProvider(
        create: (_) => AdminGymsCubit(FakeAdminRepository())..load(),
        child: const AdminGymsPage(),
      ),
  'Member dashboard': () => _dashboard(
        const MemberDashboardPage(),
        username: 'Mohammad Rakibul Hasan',
        extra: [_mySubscription(activeSubscription)],
      ),
  'Member dashboard · ending soon': () => _dashboard(
        const MemberDashboardPage(),
        extra: [_mySubscription(_expiringSubscription)],
      ),
  'Member dashboard · expired': () => _dashboard(
        const MemberDashboardPage(),
        extra: [_mySubscription(_expiredSubscription)],
      ),
  'Member dashboard · no plan': () => _dashboard(
        const MemberDashboardPage(),
        extra: [_mySubscription(_noSubscription)],
      ),
  'Notifications': () => _dashboard(const NotificationsPage()),
  'Member fees': () => BlocProvider(
        create: (_) => MemberFeesCubit(
          GetMemberSubscriptionsUseCase(_gymMembers()),
          ActivateSubscriptionUseCase(_gymMembers()),
        )..load(),
        child: const MemberSubscriptionsPage(),
      ),
'Profile': () => MultiBlocProvider(        providers: [          BlocProvider(            create: (_) => ProfileBloc(GetProfileUseCase(FakeProfileRepository()))              ..add(LoadProfile()),          ),          BlocProvider(create: (_) => AccountCubit(FakeAccountRepository())..load()),        ],        child: const ProfilePage(),      ),  'Profile error': () => MultiBlocProvider(        providers: [          BlocProvider(            create: (_) => ProfileBloc(GetProfileUseCase(                FakeProfileRepository()..error = StateError('x')))              ..add(LoadProfile()),          ),          BlocProvider(create: (_) => AccountCubit(FakeAccountRepository())..load()),        ],        child: const ProfilePage(),      ),
};

Widget _app(Widget Function() page, Brightness brightness,
    {Locale? locale}) {
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
            SignupUseCase(auth), SigninUseCase(auth), SignoutUseCase(auth, FakeReminderScheduler())),
      ),
    ],
    child: MaterialApp.router(
      theme: _theme(brightness),
      locale: locale,
      supportedLocales: const [Locale('en'), Locale('bn')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      routerConfig: router,
    ),
  );
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  tearDown(() => AppStrings.current = AppLanguage.english);

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

  // Bangla text is longer and has taller glyphs: nothing may overflow in it either.
  for (final page in _pages.entries) {
    for (final size in _sizes.entries) {
      for (final scale in _textScales) {
        testWidgets('${page.key} · ${size.key} · text x$scale · bangla',
            (tester) async {
          AppStrings.current = AppLanguage.bangla;
          tester.view.physicalSize = size.value;
          tester.view.devicePixelRatio = 1;
          tester.platformDispatcher.textScaleFactorTestValue = scale;
          addTearDown(tester.view.reset);
          addTearDown(tester.platformDispatcher.clearAllTestValues);

          await tester.pumpWidget(
              _app(page.value, Brightness.dark, locale: const Locale('bn')));
          await tester.pump(const Duration(milliseconds: 100));

          final errors = <Object>[];
          Object? e;
          while ((e = tester.takeException()) != null) {
            errors.add(e!);
          }
          expect(
              errors.map((e) => e is FlutterError ? e.toStringDeep() : '$e').toList(),
              isEmpty);

          await tester.pump(const Duration(seconds: 3));
          expect(tester.takeException(), isNull);
        });
      }
    }
  }
}
