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
import '../../domain/usecases/signin_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/profile/profile_bloc.dart';
import '../../presentation/blocs/theme/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  // Storage
  sl.registerLazySingleton(() => TokenStorage());

  // Network - Configure for web compatibility
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ));
    
    // Add interceptor for better error handling
    dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        // Detect CORS errors
        if (error.type == DioExceptionType.connectionError ||
            error.message?.contains('CORS') == true ||
            error.message?.contains('Network') == true) {
          throw Exception('Connection failed: Please check if the server is running and supports CORS');
        }
        handler.next(error);
      },
    ));
    
    return dio;
  });

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
  sl.registerLazySingleton(() => GetProfileUseCase(sl<ProfileRepository>()));

  // BLoCs
  sl.registerFactory(() => AuthBloc(
    sl<SignupUseCase>(),
    sl<SigninUseCase>(),
  ));
  sl.registerFactory(() => ProfileBloc(sl<GetProfileUseCase>()));
  sl.registerLazySingleton(() => ThemeCubit());
}