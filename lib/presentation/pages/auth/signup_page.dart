import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_palette.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../widgets/app_logo_mark.dart';
import '../../widgets/labeled_divider.dart';
import '../../widgets/labeled_text_field.dart';
import '../../widgets/theme_toggle_switch.dart';

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

  void _submit() {
    if (_usernameCtrl.text.trim().isEmpty ||
        _emailCtrl.text.trim().isEmpty ||
        _passwordCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }
    context.read<AuthBloc>().add(SignupSubmitted(
      username: _usernameCtrl.text.trim(),
      email:    _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
      role:     [_selectedRole],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (ctx, state) {
          if (state is SignupSuccess) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              const SnackBar(
                content: Text('Account created successfully! Please sign in.'),
                backgroundColor: AppColors.purple,
              ),
            );
            ctx.go(AppRoutes.signin);
          }
          if (state is AuthFailure) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorSnack,
              ),
            );
          }
        },
        builder: (ctx, state) {
          final loading = state is AuthLoading;
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24, vertical: 28,
              ),
              child: ResponsiveCenter(
                maxWidth: Breakpoints.formMaxWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Top bar ────────────────────────────
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppLogoMark(),
                        ThemeToggleSwitch(),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // ── Headline ───────────────────────────
                    Text('Create account',
                      style: TextStyle(
                        fontSize: 28, fontWeight: FontWeight.w800,
                        color: palette.textPrimary, letterSpacing: -0.6,
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
                      _AvatarStack(),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontSize: 12, color: palette.textMuted,
                            ),
                            children: const [
                              TextSpan(text: 'Join '),
                              TextSpan(
                                text: '2,400+ ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.purple,
                                ),
                              ),
                              TextSpan(text: 'gym managers'),
                            ],
                          ),
                        ),
                      ),
                    ]),

                    const SizedBox(height: 28),

                    // ── Fields ─────────────────────────────
                    LabeledTextField(
                      label: 'USERNAME',
                      controller: _usernameCtrl,
                      icon: Icons.person_outline_rounded,
                      hint: 'e.g. alim',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 14),
                    LabeledTextField(
                      label: 'EMAIL',
                      controller: _emailCtrl,
                      icon: Icons.mail_outline_rounded,
                      hint: 'alim@gmail.com',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 14),
                    LabeledTextField(
                      label: 'PASSWORD',
                      controller: _passwordCtrl,
                      icon: Icons.lock_outline_rounded,
                      hint: '••••••••',
                      obscureText: _obscurePass,
                      onChanged: (_) => setState(() {}),
                      suffix: IconButton(
                        icon: Icon(
                          _obscurePass
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: palette.textMuted, size: 17,
                        ),
                        onPressed: () =>
                            setState(() => _obscurePass = !_obscurePass),
                      ),
                    ),

                    // Password strength bars
                    const SizedBox(height: 8),
                    _StrengthBars(length: _passwordCtrl.text.length),

                    const SizedBox(height: 20),

                    // ── Role picker ────────────────────────
                    Text('ROLE',
                      style: TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w700,
                        color: palette.label, letterSpacing: 0.09,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        for (final role in _roles)
                          Expanded(
                            child: _RoleChip(
                              label: role[0].toUpperCase() + role.substring(1),
                              selected: _selectedRole == role,
                              isLast: role == _roles.last,
                              onTap: () => setState(() => _selectedRole = role),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // ── Submit button ──────────────────────
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: loading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: palette.surfaceAlt,
                          foregroundColor: palette.textPrimary,
                          side: BorderSide(color: palette.border),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: loading
                            ? SizedBox(
                                width: 20, height: 20,
                                child: CircularProgressIndicator(
                                  color: palette.textPrimary, strokeWidth: 2,
                                ),
                              )
                            : const FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text('Create account',
                                  style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    const LabeledDivider(text: 'have an account?'),

                    const SizedBox(height: 16),

                    // ── Sign in link ───────────────────────
                    Center(
                      child: TextButton(
                        onPressed: () => context.go(AppRoutes.signin),
                        child: const Text('Sign in instead',
                          style: TextStyle(
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
          );
        },
      ),
    );
  }
}

// ── Helpers ────────────────────────────────────────────────────

class _AvatarStack extends StatelessWidget {
  static const _initials = ['AK', 'RJ', 'SM'];

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final bg = Theme.of(context).scaffoldBackgroundColor;
    return SizedBox(
      width: 76,
      height: 28,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (var i = 0; i < _initials.length; i++)
            Positioned(
              left: i * 20.0,
              top: 0,
              child: Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  color: palette.surfaceAlt,
                  shape: BoxShape.circle,
                  border: Border.all(color: bg, width: 2),
                ),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(_initials[i],
                      style: const TextStyle(
                        fontSize: 8, fontWeight: FontWeight.w700,
                        color: AppColors.purple,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StrengthBars extends StatelessWidget {
  final int length;
  const _StrengthBars({required this.length});

  @override
  Widget build(BuildContext context) {
    final filled = length == 0 ? 0 : length < 4 ? 1 : length < 8 ? 2 : length < 12 ? 3 : 4;
    return Row(
      children: List.generate(4, (i) => Expanded(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 3,
          margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
          decoration: BoxDecoration(
            color: i < filled ? AppColors.purple : context.palette.strengthFill,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      )),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool isLast;
  final VoidCallback onTap;

  const _RoleChip({
    required this.label,
    required this.selected,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(right: isLast ? 0 : 8),
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.purple
              : Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: selected ? AppColors.purple : palette.border,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : palette.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
