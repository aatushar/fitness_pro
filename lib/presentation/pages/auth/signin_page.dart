import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/router/app_router.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_palette.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../widgets/auth/auth_hero.dart';
import '../../widgets/labeled_divider.dart';
import '../../widgets/labeled_text_field.dart';
import '../../../core/l10n/app_strings.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePass = true;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_usernameCtrl.text.trim().isEmpty || _passwordCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields'.tr(context))),
      );
      return;
    }
    context.read<AuthBloc>().add(SigninSubmitted(
          username: _usernameCtrl.text.trim(),
          password: _passwordCtrl.text,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (ctx, state) {
          if (state is SigninSuccess) {
            // The gym welcome animation plays, then the dashboard opens.
            ctx.go(AppRoutes.welcome,
                extra: AppRouter.homeForRoles(state.user.roles));
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
          return SingleChildScrollView(
            child: Column(
              children: [
                const AuthHero(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                  child: ResponsiveCenter(
                    maxWidth: Breakpoints.formMaxWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(
                      'Welcome back'.tr(context),
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: palette.textPrimary,
                        letterSpacing: AppStrings.spacing(-0.6),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 8),
                      width: 36,
                      height: 3,
                      decoration: BoxDecoration(
                        color: AppColors.purple,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Text(
                      'Sign in to manage your gym'.tr(context),
                      style: TextStyle(fontSize: 13, color: palette.textMuted),
                    ),

                    const SizedBox(height: 28),

                    // ── Fields ─────────────────────────────
                    LabeledTextField(
                      label: 'USERNAME OR EMAIL'.tr(context),
                      controller: _usernameCtrl,
                      icon: Icons.person_outline_rounded,
                      hint: 'Enter your username or email'.tr(context),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    LabeledTextField(
                      label: 'PASSWORD'.tr(context),
                      controller: _passwordCtrl,
                      icon: Icons.lock_outline_rounded,
                      hint: '••••••••',
                      obscureText: _obscurePass,
                      textInputAction: TextInputAction.done,
                      onSubmitted: loading ? null : (_) => _submit(),
                      suffix: IconButton(
                        icon: Icon(
                          _obscurePass
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: palette.textMuted,
                          size: 17,
                        ),
                        onPressed: () =>
                            setState(() => _obscurePass = !_obscurePass),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot password?'.tr(context),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.purple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Submit button ──────────────────────
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: loading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.purple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Sign in'.tr(context),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    LabeledDivider(text: "don't have an account?".tr(context)),

                    const SizedBox(height: 16),

                    Center(
                      child: TextButton(
                        onPressed: () => context.go(AppRoutes.signup),
                        child: Text(
                          'Create account'.tr(context),
                          style: TextStyle(
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
              ],
            ),
          );
        },
      ),
    );
  }
}
