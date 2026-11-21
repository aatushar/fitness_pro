import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/address_entity.dart';
import '../../blocs/account/account_cubit.dart';
import '../../widgets/form_dialog.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_palette.dart';
import '../../../domain/entities/profile_entity.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/locale/locale_cubit.dart';
import '../../blocs/theme/theme_cubit.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../blocs/profile/profile_event.dart';
import '../../blocs/profile/profile_state.dart';
import '../../widgets/app_back_button.dart';
import '../../../core/l10n/app_strings.dart';

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
                          const AppBackButton(),
                          Expanded(
                            child: Text('My Profile'.tr(context),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700,
                                color: palette.textPrimary, letterSpacing: AppStrings.spacing(-0.3),
                              ),
                            ),
                          ),
                          // Same width as the back button, so the title stays centred.
                          const SizedBox(width: 38),
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
                        _InfoCard(profile: state.profile),
                        const SizedBox(height: 16),
                        _AccountActions(profile: state.profile),
                        const SizedBox(height: 16),
                        const _AddressSection(),
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
          letterSpacing: AppStrings.spacing(-0.4),
        ),
      ),
      const SizedBox(height: 6),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: palette.tintPurple,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text('⚡ ${_roleOf(profile).tr(context)}',
          style: TextStyle(
            fontSize: 11, fontWeight: FontWeight.w600,
            color: palette.roleText,
          ),
        ),
      ),
    ]);
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
      (Icons.person_outline_rounded, AppColors.purple, 'Username'.tr(context), profile.username),
      (Icons.mail_outline_rounded, AppColors.success, 'Email'.tr(context),
          profile.email.isEmpty ? 'Not provided'.tr(context) : profile.email),
      (Icons.phone_outlined, AppColors.warning, 'Phone'.tr(context),
          (profile.phone ?? '').isEmpty ? 'Not provided'.tr(context) : profile.phone!),
      (Icons.shield_outlined, AppColors.purpleDeep, 'Role'.tr(context), _roleOf(profile).tr(context)),
      (Icons.tag_rounded, AppColors.info, 'Member ID'.tr(context), AppStrings.digits('#${profile.id}')),
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
                          color: palette.textMuted, letterSpacing: AppStrings.spacing(0.06),
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
            Divider(height: 1, color: palette.border, indent: 16, endIndent: 16),
          ],
          // Right under Member ID: the app language (English by default).
          const _LanguageRow(),
          Divider(height: 1, color: palette.border, indent: 16, endIndent: 16),
          const _ThemeRow(),
        ],
      ),
    );
  }
}

// ── Theme ──────────────────────────────────────────────────────

/// Light (default) or dark. The only place the theme can be changed.
class _ThemeRow extends StatelessWidget {
  const _ThemeRow();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final mode = context.watch<ThemeCubit>().state;
    final tintAlpha = context.isDarkTheme ? 0.2 : 0.12;

    Widget option(ThemeMode value, String label, IconData icon) {
      final selected = mode == value;
      return ChoiceChip(
        selected: selected,
        selectedColor: AppColors.purple,
        showCheckmark: false,
        avatar: Icon(icon,
            size: 16, color: selected ? Colors.white : palette.textMuted),
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: selected ? Colors.white : palette.textPrimary,
        ),
        label: Text(label),
        onSelected: (_) => context.read<ThemeCubit>().setThemeMode(value),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: tintAlpha),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.brightness_6_rounded,
              color: AppColors.warning, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Theme'.tr(context),
                style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w600,
                  color: palette.textMuted,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8, children: [
                option(ThemeMode.light, 'Light'.tr(context),
                    Icons.light_mode_rounded),
                option(ThemeMode.dark, 'Dark'.tr(context),
                    Icons.dark_mode_rounded),
              ]),
            ],
          ),
        ),
      ]),
    );
  }
}

// ── Language ───────────────────────────────────────────────────

class _LanguageRow extends StatelessWidget {
  const _LanguageRow();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final selected = AppStrings.of(context);
    final tintAlpha = context.isDarkTheme ? 0.2 : 0.12;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: AppColors.purple.withValues(alpha: tintAlpha),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.language_rounded,
              color: AppColors.purple, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Language'.tr(context),
                style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w600,
                  color: palette.textMuted,
                ),
              ),
              const SizedBox(height: 8),
              // Names are shown in their own language, never translated.
              Wrap(spacing: 8, runSpacing: 8, children: [
                for (final language in AppLanguage.values)
                  ChoiceChip(
                    selected: language == selected,
                    selectedColor: AppColors.purple,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: language == selected
                          ? Colors.white
                          : palette.textPrimary,
                    ),
                    showCheckmark: false,
                    onSelected: (_) =>
                        context.read<LocaleCubit>().setLanguage(language),
                    // Shown in its own language, never translated.
                    label: Text(language.nativeName),
                  ),
              ]),
            ],
          ),
        ),
      ]),
    );
  }
}

// ── Edit profile / change password ─────────────────────────────

class _AccountActions extends StatelessWidget {
  final ProfileEntity profile;
  const _AccountActions({required this.profile});

  Future<void> _editProfile(BuildContext context) async {
    final v = await showFormDialog(
      context,
      title: 'Edit profile'.tr(context),
      fields: [
        FormFieldSpec('Email'.tr(context),
            initial: profile.email, keyboard: TextInputType.emailAddress),
        FormFieldSpec('Phone'.tr(context),
            initial: profile.phone ?? '', keyboard: TextInputType.phone),
      ],
      optional: {1},
    );
    if (v == null || !context.mounted) return;
    final error = await context
        .read<AccountCubit>()
        .updateProfile(email: v[0], phone: v[1].isEmpty ? null : v[1]);
    if (!context.mounted) return;
    showMessage(context, error ?? 'Profile updated.'.tr(context), error: error != null);
    if (error == null) context.read<ProfileBloc>().add(LoadProfile());
  }

  Future<void> _changePassword(BuildContext context) async {
    final v = await showFormDialog(
      context,
      title: 'Change password'.tr(context),
      confirmLabel: 'Change'.tr(context),
      fields: [
        FormFieldSpec('Current password'.tr(context), obscure: true),
        FormFieldSpec('New password (min 6)'.tr(context), obscure: true),
      ],
    );
    if (v == null || !context.mounted) return;
    final error = await context.read<AccountCubit>().changePassword(v[0], v[1]);
    if (context.mounted) {
      showMessage(context, error ?? 'Password changed.'.tr(context), error: error != null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: OutlinedButton.icon(
          onPressed: () => _editProfile(context),
          icon: const Icon(Icons.edit_outlined, size: 18),
          label: FittedBox(fit: BoxFit.scaleDown, child: Text('Edit profile'.tr(context))),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: OutlinedButton.icon(
          onPressed: () => _changePassword(context),
          icon: const Icon(Icons.lock_outline_rounded, size: 18),
          label: FittedBox(fit: BoxFit.scaleDown, child: Text('Password'.tr(context))),
        ),
      ),
    ]);
  }
}

// ── Addresses ──────────────────────────────────────────────────

class _AddressSection extends StatelessWidget {
  const _AddressSection();

  static const _labels = [
    'Street (min 5 chars)',
    'Building name (min 5)',
    'City (min 4)',
    'State (min 2)',
    'Country (min 2)',
    'Pincode (min 5)',
  ];

  Future<void> _edit(BuildContext context, [AddressEntity? a]) async {
    final initial = a == null
        ? List.filled(6, '')
        : [a.street, a.buildingName, a.city, a.state, a.country, a.pincode];
    final v = await showFormDialog(
      context,
      title: a == null ? 'Add address'.tr(context) : 'Edit address'.tr(context),
      fields: [
        for (var i = 0; i < _labels.length; i++)
          FormFieldSpec(_labels[i].tr(context), initial: initial[i]),
      ],
    );
    if (v == null || !context.mounted) return;
    final error = await context.read<AccountCubit>().saveAddress(
        addressId: a?.addressId,
        street: v[0], buildingName: v[1], city: v[2],
        state: v[3], country: v[4], pincode: v[5]);
    if (context.mounted) {
      showMessage(context, error ?? 'Address saved.'.tr(context), error: error != null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: palette.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                  child: Text('My addresses'.tr(context),
                    style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700,
                      color: palette.textPrimary)),
                ),
                Flexible(
                  child: TextButton.icon(
                    onPressed: () => _edit(context),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Add'.tr(context)),
                    ),
                  ),
                ),
              ]),
              if (state.loading)
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state.addresses.isEmpty)
                Text(state.message ?? 'No saved addresses.'.tr(context),
                  style: TextStyle(fontSize: 12, color: palette.textMuted)),
              for (final a in state.addresses)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.location_on_outlined),
                  title: Text(a.oneLine, style: const TextStyle(fontSize: 13)),
                  onTap: () => _edit(context, a),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline_rounded,
                        color: AppColors.danger),
                    onPressed: () async {
                      final error = await context
                          .read<AccountCubit>()
                          .deleteAddress(a.addressId);
                      if (context.mounted && error != null) {
                        showMessage(context, error, error: true);
                      }
                    },
                  ),
                ),
            ],
          ),
        );
      },
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
        label: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('Sign Out'.tr(context),
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
      Text('Failed to load profile'.tr(context),
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
        child: Text('Retry'.tr(context),
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    ]);
  }
}
