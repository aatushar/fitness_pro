import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_palette.dart';
import '../widgets/app_logo_mark.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  // AppRouter's redirect sends a signed-in user on to the right dashboard.
  Future<void> _navigate() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) context.go(AppRoutes.signin);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppLogoMark(size: 72),
                const SizedBox(height: 20),
                Text('Fitness Pro',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26, fontWeight: FontWeight.w800,
                    color: palette.textPrimary, letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Gym Management System',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: palette.textMuted),
                ),
                const SizedBox(height: 48),
                const SizedBox(
                  width: 24, height: 24,
                  child: CircularProgressIndicator(
                    color: AppColors.purple, strokeWidth: 2.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
