
import 'package:fitness_pro/core/theme/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';

import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/theme/theme_cubit.dart';
import 'presentation/pages/auth/signup_page.dart';

class FitnessProApp extends StatelessWidget {
  const FitnessProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ThemeCubit>()..loadTheme()),
        BlocProvider(create: (_) => sl<AuthBloc>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) => MaterialApp(
          title: 'Fitness Pro',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          home: const SignupPage(),
        ),
      ),
    );
  }
}