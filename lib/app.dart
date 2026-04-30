import 'package:fitness_pro/presentation/blocs/auth/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'presentation/blocs/auth/auth_bloc.dart';


class FitnessProApp extends StatelessWidget {
  const FitnessProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Pro',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => sl<AuthBloc>(),
        child: const SignupPage(),
      ),
    );
  }
}