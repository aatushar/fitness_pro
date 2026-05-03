import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/di/injection.dart';
import '../../../core/storage/token_storage.dart';
import '../../../core/theme/app_colors.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../blocs/profile/profile_event.dart';
import '../../blocs/profile/profile_state.dart';
import '../../blocs/theme/theme_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  bool _isDark(BuildContext context) =>
      context.read<ThemeCubit>().state == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    final isDark = _isDark(context);

    final bg         = isDark ? AppColors.darkBg         : AppColors.lightBg;
    final surface    = isDark ? AppColors.darkSurface     : AppColors.lightSurface;
    final surfaceAlt = isDark ? AppColors.darkSurfaceAlt  : AppColors.lightSurfaceAlt;
    final border     = isDark ? AppColors.darkBorder      : AppColors.lightBorder;
    final textPrim   = isDark ? AppColors.darkTextPrim    : AppColors.lightTextPrim;
    final textMuted  = isDark ? AppColors.darkTextMuted   : AppColors.lightTextMuted;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 20,
              ),
              child: Column(
                children: [
                  // ── Top bar ──────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          width: 38, height: 38,
                          decoration: BoxDecoration(
                            color: surface,
                            borderRadius: BorderRadius.circular(11),
                            border: Border.all(color: border),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: textPrim, size: 16,
                          ),
                        ),
                      ),
                      Text('My Profile',
                        style: GoogleFonts.inter(
                          fontSize: 16, fontWeight: FontWeight.w700,
                          color: textPrim, letterSpacing: -0.3,
                        ),
                      ),
                      // Theme toggle
                      GestureDetector(
                        onTap: () => context.read<ThemeCubit>().toggleTheme(),
                        child: Container(
                          width: 38, height: 38,
                          decoration: BoxDecoration(
                            color: surface,
                            borderRadius: BorderRadius.circular(11),
                            border: Border.all(color: border),
                          ),
                          child: Icon(
                            isDark
                                ? Icons.light_mode_rounded
                                : Icons.dark_mode_rounded,
                            color: AppColors.purple, size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  if (state is ProfileLoading)
                    const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.purple,
                      ),
                    )
                  else if (state is ProfileFailure)
                    _buildError(context, state.message, textPrim, textMuted)
                  else if (state is ProfileLoaded) ...[
                      // ── Avatar ────────────────────────
                      _buildAvatar(state, isDark),

                      const SizedBox(height: 20),

                      // ── Mini stats ────────────────────
                      _buildMiniStats(surface, border, textPrim, textMuted),

                      const SizedBox(height: 16),

                      // ── Info card ─────────────────────
                      _buildInfoCard(
                        context, state,
                        surface, border, textPrim, textMuted, isDark,
                      ),

                      const SizedBox(height: 16),

                      // ── Logout button ─────────────────
                      _buildLogoutButton(context, isDark),
                    ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Avatar section ──────────────────────────────────────────
  Widget _buildAvatar(ProfileLoaded state, bool isDark) {
    final initial = state.profile.username.isNotEmpty
        ? state.profile.username[0].toUpperCase()
        : 'U';
    final role = state.profile.roles.isNotEmpty
        ? state.profile.roles.first.replaceAll('ROLE_', '')
        : 'USER';

    return Column(children: [
      Container(
        width: 84, height: 84,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFF7B2FBE), Color(0xFFA855F7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(3),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark
                ? const Color(0xFF1A1040)
                : const Color(0xFF6D28D9),
          ),
          child: Center(
            child: Text(initial,
              style: GoogleFonts.inter(
                fontSize: 32, fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      const SizedBox(height: 12),
      Text(state.profile.username,
        style: GoogleFonts.inter(
          fontSize: 22, fontWeight: FontWeight.w800,
          color: isDark ? AppColors.darkTextPrim : AppColors.lightTextPrim,
          letterSpacing: -0.4,
        ),
      ),
      const SizedBox(height: 6),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF1E1040)
              : const Color(0xFFEDE9FE),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text('⚡ $role',
          style: GoogleFonts.inter(
            fontSize: 11, fontWeight: FontWeight.w600,
            color: isDark
                ? const Color(0xFF9F87F5)
                : const Color(0xFF6D28D9),
          ),
        ),
      ),
    ]);
  }

  // ── Mini stats ──────────────────────────────────────────────
  Widget _buildMiniStats(
      Color surface, Color border, Color textPrim, Color textMuted,
      ) {
    final stats = [
      {'value': '248', 'label': 'Members'},
      {'value': '34',  'label': 'Check-ins'},
      {'value': '6',   'label': 'Trainers'},
    ];

    return Row(
      children: stats.map((s) => Expanded(
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
          ),
          child: Column(children: [
            Text(s['value']!,
              style: GoogleFonts.inter(
                fontSize: 18, fontWeight: FontWeight.w800,
                color: textPrim, letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 2),
            Text(s['label']!,
              style: GoogleFonts.inter(
                fontSize: 9, color: textMuted,
              ),
            ),
          ]),
        ),
      )).toList(),
    );
  }

  // ── Info card ───────────────────────────────────────────────
  Widget _buildInfoCard(
      BuildContext context,
      ProfileLoaded state,
      Color surface, Color border,
      Color textPrim, Color textMuted,
      bool isDark,
      ) {
    final role = state.profile.roles.isNotEmpty
        ? state.profile.roles.first.replaceAll('ROLE_', '')
        : 'USER';

    final items = [
      {
        'icon': Icons.person_outline_rounded,
        'color': 0xFF7B2FBE,
        'label': 'Username',
        'value': state.profile.username,
      },
      {
        'icon': Icons.mail_outline_rounded,
        'color': 0xFF10B981,
        'label': 'Email',
        'value': state.profile.email.isEmpty
            ? 'Not provided'
            : state.profile.email,
      },
      {
        'icon': Icons.shield_outlined,
        'color': 0xFF6D28D9,
        'label': 'Role',
        'value': role,
      },
      {
        'icon': Icons.tag_rounded,
        'color': 0xFF3B82F6,
        'label': 'Member ID',
        'value': '#${state.profile.id}',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Column(
        children: items.asMap().entries.map((e) {
          final item = e.value;
          final isLast = e.key == items.length - 1;
          return Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14,
              ),
              child: Row(children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: Color(item['color'] as int).withOpacity(
                      isDark ? 0.2 : 0.12,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: Color(item['color'] as int),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['label'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 10, fontWeight: FontWeight.w600,
                        color: textMuted, letterSpacing: 0.06,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(item['value'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 14, fontWeight: FontWeight.w600,
                        color: textPrim,
                      ),
                    ),
                  ],
                ),
              ]),
            ),
            if (!isLast)
              Divider(height: 1, color: border, indent: 16, endIndent: 16),
          ]);
        }).toList(),
      ),
    );
  }

  // ── Logout button ───────────────────────────────────────────
  Widget _buildLogoutButton(BuildContext context, bool isDark) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          await sl<TokenStorage>().clearAll();
          if (context.mounted) context.go('/signin');
        },
        icon: const Icon(Icons.logout_rounded, size: 18),
        label: Text('Sign Out',
          style: GoogleFonts.inter(
            fontSize: 15, fontWeight: FontWeight.w700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark
              ? const Color(0xFF2D0A0A)
              : const Color(0xFFFFEBEB),
          foregroundColor: const Color(0xFFEF4444),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(
              color: Color(0xFFEF4444),
              width: 1,
            ),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  // ── Error widget ────────────────────────────────────────────
  Widget _buildError(
      BuildContext context,
      String message,
      Color textPrim,
      Color textMuted,
      ) {
    return Column(children: [
      const SizedBox(height: 40),
      const Icon(Icons.error_outline_rounded,
          color: Color(0xFFEF4444), size: 48),
      const SizedBox(height: 16),
      Text('Failed to load profile',
        style: GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w700,
          color: textPrim,
        ),
      ),
      const SizedBox(height: 8),
      Text(message,
        style: GoogleFonts.inter(fontSize: 12, color: textMuted),
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
        child: Text('Retry',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),
    ]);
  }
}