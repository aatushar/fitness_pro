import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_palette.dart';
import '../../../domain/entities/profile_entity.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../blocs/profile/profile_event.dart';
import '../../blocs/profile/profile_state.dart';
import '../../widgets/theme_toggle_switch.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return BlocListener<AuthBloc, AuthState>(
      listener: (ctx, state) {
        if (state is SignoutSuccess) ctx.go(AppRoutes.signin);
        if (state is AuthFailure) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.errorSnack,
            ),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ResponsiveCenter(
                  maxWidth: Breakpoints.formMaxWidth,
                  child: Column(
                    children: [
                      // ── Top bar ──────────────────────────
                      Row(
                        children: [
                          _BackButton(),
                          Expanded(
                            child: Text('My Profile',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700,
                                color: palette.textPrimary, letterSpacing: -0.3,
                              ),
                            ),
                          ),
                          const ThemeToggleSwitch(width: 46, height: 26),
                        ],
                      ),

                      const SizedBox(height: 28),

                      if (state is ProfileLoading || state is ProfileInitial)
                        const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.purple,
                          ),
                        )
                      else if (state is ProfileFailure)
                        _ErrorView(message: state.message)
                      else if (state is ProfileLoaded) ...[
                        _Avatar(profile: state.profile),
                        const SizedBox(height: 20),
                        const _MiniStats(),
                        const SizedBox(height: 16),
                        _InfoCard(profile: state.profile),
                        const SizedBox(height: 16),
                        const _SignOutButton(),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

String _roleOf(ProfileEntity profile) => profile.roles.isNotEmpty
    ? profile.roles.first.replaceAll('ROLE_', '')
    : 'USER';

// ── Back button ────────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Semantics(
      button: true,
      label: 'Back',
      child: GestureDetector(
        // Opened directly by URL on web there is nothing to pop.
        onTap: () => context.canPop()
            ? context.pop()
            : context.go(AppRoutes.dashboard),
        child: Container(
          width: 38, height: 38,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: palette.border),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: palette.textPrimary, size: 16,
          ),
        ),
      ),
    );
  }
}

// ── Avatar section ─────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final ProfileEntity profile;
  const _Avatar({required this.profile});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final initial = profile.username.isNotEmpty
        ? profile.username[0].toUpperCase()
        : 'U';

    return Column(children: [
      Container(
        width: 84, height: 84,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [AppColors.purple, AppColors.purpleLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(3),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: palette.avatarFill,
          ),
          child: Center(
            child: Text(initial,
              style: const TextStyle(
                fontSize: 32, fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      const SizedBox(height: 12),
      Text(profile.username,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 22, fontWeight: FontWeight.w800,
          color: palette.textPrimary,
          letterSpacing: -0.4,
        ),
      ),
      const SizedBox(height: 6),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: palette.tintPurple,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text('⚡ ${_roleOf(profile)}',
          style: TextStyle(
            fontSize: 11, fontWeight: FontWeight.w600,
            color: palette.roleText,
          ),
        ),
      ),
    ]);
  }
}

// ── Mini stats ─────────────────────────────────────────────────

class _MiniStats extends StatelessWidget {
  const _MiniStats();

  static const _stats = [
    ('248', 'Members'),
    ('34',  'Check-ins'),
    ('6',   'Trainers'),
  ];

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      children: [
        for (var i = 0; i < _stats.length; i++)
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i < _stats.length - 1 ? 8 : 0),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: palette.border),
              ),
              child: Column(children: [
                Text(_stats[i].$1,
                  style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800,
                    color: palette.textPrimary, letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(_stats[i].$2,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 9, color: palette.textMuted),
                ),
              ]),
            ),
          ),
      ],
    );
  }
}

// ── Info card ──────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final ProfileEntity profile;
  const _InfoCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final tintAlpha = context.isDarkTheme ? 0.2 : 0.12;

    final items = [
      (Icons.person_outline_rounded, AppColors.purple, 'Username', profile.username),
      (Icons.mail_outline_rounded, AppColors.success, 'Email',
          profile.email.isEmpty ? 'Not provided' : profile.email),
      (Icons.shield_outlined, AppColors.purpleDeep, 'Role', _roleOf(profile)),
      (Icons.tag_rounded, AppColors.info, 'Member ID', '#${profile.id}'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14,
              ),
              child: Row(children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: items[i].$2.withValues(alpha: tintAlpha),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(items[i].$1, color: items[i].$2, size: 18),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(items[i].$3,
                        style: TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w600,
                          color: palette.textMuted, letterSpacing: 0.06,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(items[i].$4,
                        style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600,
                          color: palette.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
            if (i < items.length - 1)
              Divider(height: 1, color: palette.border, indent: 16, endIndent: 16),
          ],
        ],
      ),
    );
  }
}

// ── Sign out button ────────────────────────────────────────────

class _SignOutButton extends StatelessWidget {
  const _SignOutButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => context.read<AuthBloc>().add(SignoutRequested()),
        icon: const Icon(Icons.logout_rounded, size: 18),
        label: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('Sign Out',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: context.palette.dangerBg,
          foregroundColor: AppColors.danger,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: AppColors.danger, width: 1),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}

// ── Error view ─────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(children: [
      const SizedBox(height: 40),
      const Icon(Icons.error_outline_rounded,
          color: AppColors.danger, size: 48),
      const SizedBox(height: 16),
      Text('Failed to load profile',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w700,
          color: palette.textPrimary,
        ),
      ),
      const SizedBox(height: 8),
      Text(message,
        style: TextStyle(fontSize: 12, color: palette.textMuted),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 24),
      ElevatedButton(
        onPressed: () => context.read<ProfileBloc>().add(LoadProfile()),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.purple,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text('Retry',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    ]);
  }
}
