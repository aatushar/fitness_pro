import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../core/network/auth_interceptor.dart';
import '../../core/storage/token_storage.dart';
import '../../data/datasources/account_remote_datasource.dart';
import '../../data/datasources/admin_remote_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/notification_remote_datasource.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/datasources/subscription_remote_datasource.dart';
import '../../data/repositories/account_repository_impl.dart';
import '../../data/repositories/admin_repository_impl.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../data/repositories/subscription_repository_impl.dart';
import '../../data/services/local_reminder_scheduler.dart';
import '../../domain/repositories/account_repository.dart';
import '../../domain/repositories/admin_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../../domain/services/reminder_scheduler.dart';
import '../../domain/usecases/activate_subscription_usecase.dart';
import '../../domain/usecases/get_member_subscriptions_usecase.dart';
import '../../domain/usecases/get_my_subscription_usecase.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/get_saved_username_usecase.dart';
import '../../domain/usecases/mark_notifications_read_usecase.dart';
import '../../domain/usecases/signin_usecase.dart';
import '../../domain/usecases/signout_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../presentation/blocs/account/account_cubit.dart';
import '../../presentation/blocs/admin/admin_dashboard_cubit.dart';
import '../../presentation/blocs/admin/admin_gyms_cubit.dart';
import '../../presentation/blocs/admin/admin_users_cubit.dart';
import '../../presentation/blocs/admin/gym_options_cubit.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/current_user/current_user_cubit.dart';
import '../../presentation/blocs/notifications/notifications_cubit.dart';
import '../../presentation/blocs/profile/profile_bloc.dart';
import '../../presentation/blocs/subscription/member_fees_cubit.dart';
import '../../presentation/blocs/subscription/my_subscription_cubit.dart';
import '../../presentation/blocs/theme/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  // Storage
  sl.registerLazySingleton(() => TokenStorage());

  // Network — datasources translate DioException into ApiException.
  // AuthInterceptor adds the Bearer token to every non-auth request.
  sl.registerLazySingleton<Dio>(() => Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {'Content-Type': 'application/json'},
  ))..interceptors.add(AuthInterceptor(sl<TokenStorage>())));

  // Phone reminders for subscription expiry (local alarms, no push server)
  sl.registerLazySingleton<ReminderScheduler>(() => LocalReminderScheduler());

  // Datasources
  sl.registerLazySingleton<AuthRemoteDatasource>(
        () => AuthRemoteDatasourceImpl(sl<Dio>()),
  );
  sl.registerLazySingleton<ProfileRemoteDatasource>(
        () => ProfileRemoteDatasourceImpl(sl<Dio>(), sl<TokenStorage>()),
  );
  sl.registerLazySingleton<SubscriptionRemoteDatasource>(
        () => SubscriptionRemoteDatasourceImpl(sl<Dio>()),
  );
  sl.registerLazySingleton<NotificationRemoteDatasource>(
        () => NotificationRemoteDatasourceImpl(sl<Dio>()),
  );

  sl.registerLazySingleton<AdminRemoteDatasource>(
        () => AdminRemoteDatasourceImpl(sl<Dio>()),
  );
  sl.registerLazySingleton<AccountRemoteDatasource>(
        () => AccountRemoteDatasourceImpl(sl<Dio>()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(sl<AuthRemoteDatasource>(), sl<TokenStorage>()),
  );
  sl.registerLazySingleton<ProfileRepository>(
        () => ProfileRepositoryImpl(sl<ProfileRemoteDatasource>()),
  );
  sl.registerLazySingleton<SubscriptionRepository>(
        () => SubscriptionRepositoryImpl(sl<SubscriptionRemoteDatasource>()),
  );
  sl.registerLazySingleton<NotificationRepository>(
        () => NotificationRepositoryImpl(sl<NotificationRemoteDatasource>()),
  );

  sl.registerLazySingleton<AdminRepository>(
        () => AdminRepositoryImpl(sl<AdminRemoteDatasource>()),
  );
  sl.registerLazySingleton<AccountRepository>(
        () => AccountRepositoryImpl(sl<AccountRemoteDatasource>()),
  );

  // Usecases
  sl.registerLazySingleton(() => SignupUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SigninUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(
        () => SignoutUseCase(sl<AuthRepository>(), sl<ReminderScheduler>()),
  );
  sl.registerLazySingleton(() => GetSavedUsernameUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetProfileUseCase(sl<ProfileRepository>()));
  sl.registerLazySingleton(
        () => GetMySubscriptionUseCase(sl<SubscriptionRepository>()),
  );
  sl.registerLazySingleton(
        () => GetMemberSubscriptionsUseCase(sl<SubscriptionRepository>()),
  );
  sl.registerLazySingleton(
        () => ActivateSubscriptionUseCase(sl<SubscriptionRepository>()),
  );
  sl.registerLazySingleton(
        () => GetNotificationsUseCase(sl<NotificationRepository>()),
  );
  sl.registerLazySingleton(
        () => MarkNotificationsReadUseCase(sl<NotificationRepository>()),
  );

  // BLoCs
  sl.registerFactory(() => AuthBloc(
    sl<SignupUseCase>(),
    sl<SigninUseCase>(),
    sl<SignoutUseCase>(),
  ));
  sl.registerFactory(() => ProfileBloc(sl<GetProfileUseCase>()));
  sl.registerFactory(() => CurrentUserCubit(sl<GetSavedUsernameUseCase>()));
  sl.registerFactory(() => MySubscriptionCubit(
    sl<GetMySubscriptionUseCase>(),
    sl<ReminderScheduler>(),
  ));
  sl.registerFactory(() => MemberFeesCubit(
    sl<GetMemberSubscriptionsUseCase>(),
    sl<ActivateSubscriptionUseCase>(),
  ));
  sl.registerFactory(() => NotificationsCubit(
    sl<GetNotificationsUseCase>(),
    sl<MarkNotificationsReadUseCase>(),
  ));
  sl.registerFactory(() => AdminDashboardCubit(sl<AdminRepository>()));
  sl.registerFactory(() => AdminUsersCubit(sl<AdminRepository>()));
  sl.registerFactory(
        () => AdminUsersCubit(sl<AdminRepository>(), trainerMode: true),
    instanceName: 'trainerMembers',
  );
  sl.registerFactory(() => AdminGymsCubit(sl<AdminRepository>()));
  sl.registerFactory(() => GymOptionsCubit(sl<AdminRepository>()));
  sl.registerFactory(() => AccountCubit(sl<AccountRepository>()));
  sl.registerLazySingleton(() => ThemeCubit());
}
