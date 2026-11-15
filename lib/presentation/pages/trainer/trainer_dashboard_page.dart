import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../blocs/admin/admin_users_cubit.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/dashboard/dashboard_cards.dart';
import '../../widgets/dashboard/dashboard_header.dart';
import '../../widgets/dashboard/dashboard_scaffold.dart';
import '../../widgets/section_title.dart';

/// Trainer (ROLE_TRAINER) dashboard: the gym's members.
/// Needs an [AdminUsersCubit] in trainer mode.

const _navItems = [
  AppNavItem(Icons.grid_view_rounded, 'Home'),
  AppNavItem(Icons.groups_outlined, 'Members'),
  AppNavItem(Icons.person_outline_rounded, 'Profile'),
];

class TrainerDashboardPage extends StatelessWidget {
  const TrainerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminUsersCubit, AdminUsersState>(
      builder: (context, state) {
        final members = state.users;
        final active = members.where((m) => m.isActive).length;
        return DashboardScaffold(
          navItems: _navItems,
          navRoutes: const {1: AppRoutes.trainerMembers},
          onRefresh: () => context.read<AdminUsersCubit>().load(),
          children: [
            const DashboardHeader(roleLabel: 'Trainer', fallbackName: 'Trainer'),
            const SizedBox(height: 20),
            if (state.status == LoadStatus.loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state.status == LoadStatus.failure && members.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(children: [
                    Text(state.message ?? 'Could not load members.'),
                    TextButton(
                      onPressed: () => context.read<AdminUsersCubit>().load(),
                      child: const Text('Try again'),
                    ),
                  ]),
                ),
              )
            else ...[
              GradientHeroCard(
                startColor: AppColors.planGradientStart,
                child: HeroFigure(
                  caption: 'GYM MEMBERS',
                  value: '${members.length}',
                  note: '$active active',
                ),
              ),
              const SizedBox(height: 20),
              const SectionTitle('Members'),
              const SizedBox(height: 10),
              if (members.isEmpty) const Text('No members yet.'),
              for (final m in members.take(8))
                DashboardListTile(
                  leading: InitialsAvatar(
                    initials: m.username.isEmpty ? '?' : m.username[0].toUpperCase(),
                    color: AppColors.purple,
                  ),
                  title: m.username,
                  subtitle: m.email,
                  trailing: StatusChip(
                    label: m.isActive ? 'Active' : 'Inactive',
                    tone: m.isActive ? ChipTone.success : ChipTone.danger,
                  ),
                ),
            ],
          ],
        );
      },
    );
  }
}
