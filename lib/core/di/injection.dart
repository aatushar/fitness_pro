import 'package:dio/dio.dart';
import 'package:fitness_pro/data/datasources/auth_remote_datasource.dart';
import 'package:fitness_pro/data/repositories/auth_repository_impl.dart';

import 'package:get_it/get_it.dart';


import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/theme/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  sl.registerLazySingleton<Dio>(() => Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json'},
  )));

  sl.registerLazySingleton<AuthRemoteDatasource>(
        () => AuthRemoteDatasourceImpl(sl<Dio>()),
  );

  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(sl<AuthRemoteDatasource>()),
  );

  sl.registerLazySingleton(() => SignupUseCase(sl<AuthRepository>()));

  sl.registerFactory(() => AuthBloc(sl<SignupUseCase>()));
  sl.registerLazySingleton(() => ThemeCubit());
}