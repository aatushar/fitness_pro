import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/theme/theme_cubit.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});
  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePass   = true;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  bool get _isDark =>
      context.read<ThemeCubit>().state == ThemeMode.dark;

  Color get _bg        => _isDark ? AppColors.darkBg        : AppColors.lightBg;
  Color get _surface   => _isDark ? AppColors.darkSurface    : AppColors.lightSurface;
  Color get _surfaceAlt=> _isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt;
  Color get _border    => _isDark ? AppColors.darkBorder     : AppColors.lightBorder;
  Color get _textPrim  => _isDark ? AppColors.darkTextPrim   : AppColors.lightTextPrim;
  Color get _textMuted => _isDark ? AppColors.darkTextMuted  : AppColors.lightTextMuted;
  Color get _label     => _isDark ? AppColors.darkLabel      : AppColors.lightLabel;

  void _submit(BuildContext ctx) {
    if (_usernameCtrl.text.trim().isEmpty || _passwordCtrl.text.isEmpty) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }
    ctx.read<AuthBloc>().add(SigninSubmitted(
      username: _usernameCtrl.text.trim(),
      password: _passwordCtrl.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ThemeCubit, ThemeMode>(
      listener: (_, __) => setState(() {}),
      builder: (context, _) => Scaffold(
        backgroundColor: _bg,
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (ctx, state) {
            if (state is SigninSuccess) {
              context.go('/dashboard');
            }
            if (state is AuthFailure) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red.shade800,
                ),
              );
            }
          },
          builder: (ctx, state) => SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24, vertical: 28,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.purple,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [BoxShadow(
                            color: AppColors.purpleGlow,
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          )],
                        ),
                        child: const Icon(Icons.fitness_center_rounded,
                            color: Colors.white, size: 22),
                      ),
                      GestureDetector(
                        onTap: () => context.read<ThemeCubit>().toggleTheme(),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 52, height: 28,
                          decoration: BoxDecoration(
                            color: _surfaceAlt,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: _border),
                          ),
                          child: AnimatedAlign(
                            duration: const Duration(milliseconds: 250),
                            alignment: _isDark
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: Container(
                              width: 22, height: 22,
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                color: AppColors.purple,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _isDark
                                    ? Icons.dark_mode_rounded
                                    : Icons.light_mode_rounded,
                                color: Colors.white, size: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  Text('Welcome back',
                    style: GoogleFonts.inter(
                      fontSize: 28, fontWeight: FontWeight.w800,
                      color: _textPrim, letterSpacing: -0.6,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 8),
                    width: 36, height: 3,
                    decoration: BoxDecoration(
                      color: AppColors.purple,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Text('Sign in to manage your gym',
                    style: GoogleFonts.inter(
                      fontSize: 13, color: _textMuted,
                    ),
                  ),

                  const SizedBox(height: 36),

                  _field(
                    label: 'USERNAME',
                    controller: _usernameCtrl,
                    icon: Icons.person_outline_rounded,
                    hint: 'Enter your username',
                  ),
                  const SizedBox(height: 16),
                  _field(
                    label: 'PASSWORD',
                    controller: _passwordCtrl,
                    icon: Icons.lock_outline_rounded,
                    hint: '••••••••',
                    obscure: _obscurePass,
                    suffix: IconButton(
                      icon: Icon(
                        _obscurePass
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: _textMuted, size: 17,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePass = !_obscurePass),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Text('Forgot password?',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.purple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state is AuthLoading
                          ? null
                          : () => _submit(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: state is AuthLoading
                          ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2,
                        ),
                      )
                          : Text('Sign in',
                        style: GoogleFonts.inter(
                          fontSize: 15, fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  Row(children: [
                    Expanded(child: Divider(color: _border)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text("don't have an account?",
                        style: GoogleFonts.inter(
                          fontSize: 11, color: _textMuted,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: _border)),
                  ]),

                  const SizedBox(height: 16),

                  Center(
                    child: GestureDetector(
                      onTap: () => context.go('/signup'),
                      child: Text('Create account',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.purple,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
          style: GoogleFonts.inter(
            fontSize: 11, fontWeight: FontWeight.w700,
            color: _label, letterSpacing: 0.09,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          style: GoogleFonts.inter(fontSize: 14, color: _textPrim),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(color: _textMuted, fontSize: 14),
            prefixIcon: Icon(icon, color: _textMuted, size: 18),
            suffixIcon: suffix,
            filled: true,
            fillColor: _surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.purple, width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}