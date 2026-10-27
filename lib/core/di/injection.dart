import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../core/storage/token_storage.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/get_saved_username_usecase.dart';
import '../../domain/usecases/signin_usecase.dart';
import '../../domain/usecases/signout_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/current_user/current_user_cubit.dart';
import '../../presentation/blocs/profile/profile_bloc.dart';
import '../../presentation/blocs/theme/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  // Storage
  sl.registerLazySingleton(() => TokenStorage());

  // Network — datasources translate DioException into ApiException
  sl.registerLazySingleton<Dio>(() => Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {'Content-Type': 'application/json'},
  )));

  // Datasources
  sl.registerLazySingleton<AuthRemoteDatasource>(
        () => AuthRemoteDatasourceImpl(sl<Dio>()),
  );
  sl.registerLazySingleton<ProfileRemoteDatasource>(
        () => ProfileRemoteDatasourceImpl(sl<Dio>(), sl<TokenStorage>()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(sl<AuthRemoteDatasource>(), sl<TokenStorage>()),
  );
  sl.registerLazySingleton<ProfileRepository>(
        () => ProfileRepositoryImpl(sl<ProfileRemoteDatasource>()),
  );

  // Usecases
  sl.registerLazySingleton(() => SignupUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SigninUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignoutUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetSavedUsernameUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetProfileUseCase(sl<ProfileRepository>()));

  // BLoCs
  sl.registerFactory(() => AuthBloc(
    sl<SignupUseCase>(),
    sl<SigninUseCase>(),
    sl<SignoutUseCase>(),
  ));
  sl.registerFactory(() => ProfileBloc(sl<GetProfileUseCase>()));
  sl.registerFactory(() => CurrentUserCubit(sl<GetSavedUsernameUseCase>()));
  sl.registerLazySingleton(() => ThemeCubit());
}
