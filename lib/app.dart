import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/storage/token_storage.dart';
import 'core/theme/AppTheme.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/theme/theme_cubit.dart';

class FitnessProApp extends StatefulWidget {
  const FitnessProApp({super.key});

  @override
  State<FitnessProApp> createState() => _FitnessProAppState();
}

class _FitnessProAppState extends State<FitnessProApp> {
  // Created once so a theme change doesn't rebuild the router and lose the stack.
  final _appRouter = AppRouter(sl<TokenStorage>());

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ThemeCubit>()..loadTheme()),
        BlocProvider(create: (_) => sl<AuthBloc>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (_, themeMode) => MaterialApp.router(
          title: 'Fitness Pro',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          routerConfig: _appRouter.router,
        ),
      ),
    );
  }
}
