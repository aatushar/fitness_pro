import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_palette.dart';
import '../../../domain/entities/managed_user_entity.dart';
import '../../blocs/admin/admin_users_cubit.dart';
import '../../widgets/app_back_button.dart';
import '../../widgets/dashboard/dashboard_cards.dart';
import '../../widgets/form_dialog.dart';

/// Users of the gym. With [manage] true (admin) each row has a menu to
/// activate/deactivate, change role or delete; otherwise (trainer) it is a
/// read-only member list. Needs an [AdminUsersCubit].
class ManagedUsersPage extends StatelessWidget {
  final bool manage;
  const ManagedUsersPage({super.key, required this.manage});

  static const _roles = ['Member', 'Trainer', 'Manager'];

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<AdminUsersCubit, AdminUsersState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () => context.read<AdminUsersCubit>().load(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                children: [
                  ResponsiveCenter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const AppBackButton(),
                          Expanded(
                            child: Text(manage ? 'Users' : 'My Members',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700,
                                color: palette.textPrimary, letterSpacing: -0.3,
                              ),
                            ),
                          ),
                          const SizedBox(width: 38),
                        ]),
                        const SizedBox(height: 16),
                        _Body(state: state, manage: manage),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final AdminUsersState state;
  final bool manage;
  const _Body({required this.state, required this.manage});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final cubit = context.read<AdminUsersCubit>();

    if (state.status == LoadStatus.loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 80),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (state.status == LoadStatus.failure && state.users.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(children: [
          Icon(Icons.cloud_off_rounded, size: 44, color: palette.textMuted),
          const SizedBox(height: 12),
          Text(state.message ?? 'Could not load users.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: palette.textMuted)),
          TextButton(onPressed: cubit.load, child: const Text('Try again')),
        ]),
      );
    }

    final visible = state.visibleUsers;
    OutlineInputBorder outline(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onChanged: cubit.setSearch,
          decoration: InputDecoration(
            hintText: 'Search name, email or phone',
            hintStyle: TextStyle(fontSize: 13, color: palette.textMuted),
            prefixIcon: Icon(Icons.search_rounded, color: palette.textMuted),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: outline(palette.border),
            enabledBorder: outline(palette.border),
            focusedBorder: outline(AppColors.purple),
          ),
        ),
        if (manage) ...[
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final r in <String?>[null, ...ManagedUsersPage._roles])
              ChoiceChip(
                label: Text(r ?? 'All'),
                selected: state.roleFilter == r,
                onSelected: (_) => cubit.setRoleFilter(r),
              ),
          ]),
        ],
        const SizedBox(height: 16),
        if (visible.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text('No users found.',
                style: TextStyle(fontSize: 14, color: palette.textMuted)),
            ),
          )
        else
          for (final u in visible) _UserTile(user: u, manage: manage),
      ],
    );
  }
}

class _UserTile extends StatelessWidget {
  final ManagedUserEntity user;
  final bool manage;
  const _UserTile({required this.user, required this.manage});

  Future<void> _report(BuildContext context, Future<String?> result, String ok) async {
    final error = await result;
    if (context.mounted) showMessage(context, error ?? ok, error: error != null);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AdminUsersCubit>();
    final initial = user.username.isEmpty ? '?' : user.username[0].toUpperCase();
    final details = [
      user.roleLabel,
      if (user.email.isNotEmpty) user.email,
      if (user.phone != null && user.phone!.isNotEmpty) user.phone!,
    ].join(' · ');

    return DashboardListTile(
      leading: InitialsAvatar(
        initials: initial,
        color: switch (user.roleLabel) {
          'Manager' => AppColors.purple,
          'Trainer' => AppColors.info,
          _ => AppColors.success,
        },
      ),
      title: user.username,
      subtitle: details,
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        Flexible(child: StatusChip(
          label: user.status[0] + user.status.substring(1).toLowerCase(),
          tone: user.isActive ? ChipTone.success : ChipTone.danger,
        )),
        if (manage)
          PopupMenuButton<String>(
            tooltip: 'Actions',
            onSelected: (a) async {
              if (a == 'toggle') {
                await _report(context,
                    cubit.setStatus(user.userId, user.isActive ? 'INACTIVE' : 'ACTIVE'),
                    user.isActive ? 'User deactivated.' : 'User activated.');
              } else if (a == 'delete') {
                final ok = await confirmAction(context,
                    title: 'Delete user?',
                    message: '${user.username} will no longer be able to sign in.');
                if (ok && context.mounted) {
                  await _report(context, cubit.delete(user.userId), 'User deleted.');
                }
              } else if (a.startsWith('role:')) {
                await _report(context, cubit.setRole(user.userId, a.substring(5).toLowerCase()),
                    'Role updated.');
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'toggle',
                child: Text(user.isActive ? 'Deactivate' : 'Activate'),
              ),
              for (final r in ManagedUsersPage._roles)
                if (r != user.roleLabel)
                  PopupMenuItem(value: 'role:$r', child: Text('Make $r')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
      ]),
    );
  }
}
