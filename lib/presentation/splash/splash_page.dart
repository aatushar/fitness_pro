import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/di/injection.dart';
import '../../../core/storage/token_storage.dart';

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

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final hasToken = await sl<TokenStorage>().hasToken();
    if (mounted) {
      hasToken ? context.go('/dashboard') : context.go('/signin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A12),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFF7B2FBE),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7B2FBE).withOpacity(0.4),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.fitness_center_rounded,
                color: Colors.white, size: 36,
              ),
            ),
            const SizedBox(height: 20),
            const Text('Fitness Pro',
              style: TextStyle(
                fontSize: 26, fontWeight: FontWeight.w800,
                color: Color(0xFFF0EDFF), letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Gym Management System',
              style: TextStyle(fontSize: 13, color: Color(0xFF5A5A7A)),
            ),
            const SizedBox(height: 48),
            const SizedBox(
              width: 24, height: 24,
              child: CircularProgressIndicator(
                color: Color(0xFF7B2FBE), strokeWidth: 2.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}