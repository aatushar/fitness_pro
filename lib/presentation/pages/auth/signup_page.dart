import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/theme/theme_cubit.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _usernameCtrl = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  String _selectedRole = 'manager';
  bool   _obscurePass  = true;

  static const _roles = ['manager', 'trainer', 'member'];

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  bool get _isDark =>
      context.read<ThemeCubit>().state == ThemeMode.dark;

  Color get _bg         => _isDark ? AppColors.darkBg         : AppColors.lightBg;
  Color get _surface    => _isDark ? AppColors.darkSurface     : AppColors.lightSurface;
  Color get _surfaceAlt => _isDark ? AppColors.darkSurfaceAlt  : AppColors.lightSurfaceAlt;
  Color get _border     => _isDark ? AppColors.darkBorder      : AppColors.lightBorder;
  Color get _textPrim   => _isDark ? AppColors.darkTextPrim    : AppColors.lightTextPrim;
  Color get _textMuted  => _isDark ? AppColors.darkTextMuted   : AppColors.lightTextMuted;
  Color get _label      => _isDark ? AppColors.darkLabel       : AppColors.lightLabel;
  Color get _strFill    => _isDark ? AppColors.darkStrFill     : AppColors.lightStrFill;

  void _submit(BuildContext ctx) {
    if (_usernameCtrl.text.trim().isEmpty ||
        _emailCtrl.text.trim().isEmpty ||
        _passwordCtrl.text.isEmpty) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }
    ctx.read<AuthBloc>().add(SignupSubmitted(
      username: _usernameCtrl.text.trim(),
      email:    _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
      role:     [_selectedRole],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ThemeCubit, ThemeMode>(
      listener: (_, __) => setState(() {}),
      builder: (context, themeMode) {
        return Scaffold(
          backgroundColor: _bg,
          body: BlocConsumer<AuthBloc, AuthState>(
            listener: (ctx, state) {
              if (state is AuthSuccess) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(
                    content: Text('Account created successfully!'),
                    backgroundColor: AppColors.purple,
                  ),
                );
                // TODO: navigate to login
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
                    // ── Top bar ────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Logo mark
                        Container(
                          width: 48, height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.purple,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.purpleGlow,
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.fitness_center_rounded,
                            color: Colors.white, size: 22,
                          ),
                        ),
                        // Theme toggle
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

                    const SizedBox(height: 28),

                    // ── Headline ───────────────────────────
                    Text('Create account',
                      style: GoogleFonts.inter(
                        fontSize: 28, fontWeight: FontWeight.w800,
                        color: _textPrim, letterSpacing: -0.6,
                      ),
                    ),

                    // Accent line
                    Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 16),
                      width: 36, height: 3,
                      decoration: BoxDecoration(
                        color: AppColors.purple,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // ── Social proof ───────────────────────
                    Row(children: [
                      _avatarStack(),
                      const SizedBox(width: 10),
                      RichText(text: TextSpan(
                        style: GoogleFonts.inter(
                          fontSize: 12, color: _textMuted,
                        ),
                        children: [
                          const TextSpan(text: 'Join '),
                          TextSpan(
                            text: '2,400+ ',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.purple,
                            ),
                          ),
                          const TextSpan(text: 'gym managers'),
                        ],
                      )),
                    ]),

                    const SizedBox(height: 28),

                    // ── Fields ─────────────────────────────
                    _field(
                      label: 'USERNAME',
                      controller: _usernameCtrl,
                      icon: Icons.person_outline_rounded,
                      hint: 'e.g. alim',
                    ),
                    const SizedBox(height: 14),
                    _field(
                      label: 'EMAIL',
                      controller: _emailCtrl,
                      icon: Icons.mail_outline_rounded,
                      hint: 'alim@gmail.com',
                      keyboard: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 14),
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

                    // Password strength bars
                    const SizedBox(height: 8),
                    _strengthBars(),

                    const SizedBox(height: 20),

                    // ── Role picker ────────────────────────
                    Text('ROLE',
                      style: GoogleFonts.inter(
                        fontSize: 11, fontWeight: FontWeight.w700,
                        color: _label, letterSpacing: 0.09,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: _roles.map((role) {
                        final sel = _selectedRole == role;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedRole = role),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(vertical: 11),
                              decoration: BoxDecoration(
                                color: sel
                                    ? AppColors.purple
                                    : _surface,
                                border: Border.all(
                                  color: sel
                                      ? AppColors.purple
                                      : _border,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                role[0].toUpperCase() + role.substring(1),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: sel ? Colors.white : _textMuted,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 28),

                    // ── Submit button ──────────────────────
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is AuthLoading
                            ? null
                            : () => _submit(ctx),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _surfaceAlt,
                          foregroundColor: _textPrim,
                          side: BorderSide(color: _border),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: state is AuthLoading
                            ? SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(
                            color: _textPrim, strokeWidth: 2,
                          ),
                        )
                            : Text('Create account',
                          style: GoogleFonts.inter(
                            fontSize: 15, fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Divider ────────────────────────────
                    Row(children: [
                      Expanded(child: Divider(color: _border)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text('have an account?',
                          style: GoogleFonts.inter(
                            fontSize: 11, color: _textMuted,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: _border)),
                    ]),

                    const SizedBox(height: 16),

                    // ── Sign in link ───────────────────────
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          // TODO: navigate to login
                        },
                        child: Text('Sign in instead',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.purple,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Helpers ────────────────────────────────────────────────

  Widget _avatarStack() {
    final initials = ['AK', 'RJ', 'SM'];
    return SizedBox(
      width: 76,
      height: 28, // ← এই height add করো
      child: Stack(
        clipBehavior: Clip.none,
        children: initials.asMap().entries.map((e) {
          return Positioned(
            left: e.key * 20.0,
            top: 0,           // ← top: 0 add করো
            child: Container(
              width: 28, height: 28,
              decoration: BoxDecoration(
                color: _surfaceAlt,
                shape: BoxShape.circle,
                border: Border.all(color: _bg, width: 2),
              ),
              child: Center(
                child: Text(e.value,
                  style: GoogleFonts.inter(
                    fontSize: 8, fontWeight: FontWeight.w700,
                    color: AppColors.purple,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _strengthBars() {
    final len = _passwordCtrl.text.length;
    final filled = len == 0 ? 0 : len < 4 ? 1 : len < 8 ? 2 : len < 12 ? 3 : 4;
    return Row(
      children: List.generate(4, (i) => Expanded(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 3,
          margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
          decoration: BoxDecoration(
            color: i < filled ? AppColors.purple : _strFill,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      )),
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    TextInputType keyboard = TextInputType.text,
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
          keyboardType: keyboard,
          obscureText: obscure,
          onChanged: label == 'PASSWORD'
              ? (_) => setState(() {})
              : null,
          style: GoogleFonts.inter(
            fontSize: 14, color: _textPrim,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              color: _textMuted, fontSize: 14,
            ),
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