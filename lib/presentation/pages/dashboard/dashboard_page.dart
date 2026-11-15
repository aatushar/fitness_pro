import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/admin_dashboard_entity.dart';
import '../../blocs/admin/admin_dashboard_cubit.dart';
import '../../blocs/admin/admin_users_cubit.dart' show LoadStatus;
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/dashboard/dashboard_cards.dart';
import '../../widgets/dashboard/dashboard_header.dart';
import '../../widgets/dashboard/dashboard_scaffold.dart';
import '../../widgets/section_title.dart';

/// Admin (ROLE_MANAGER) dashboard: runs one gym — members, trainers, fees.
/// Needs an [AdminDashboardCubit].

const _quickActions = [
  QuickActionItem(Icons.payments_outlined, 'Member Fees', AppColors.purple,
      route: AppRoutes.memberSubscriptions),
  QuickActionItem(Icons.people_alt_outlined, 'Users', AppColors.info,
      route: AppRoutes.adminUsers),
  QuickActionItem(Icons.fitness_center_rounded, 'Gyms', AppColors.success,
      route: AppRoutes.adminGyms),
];

const _navItems = [
  AppNavItem(Icons.grid_view_rounded, 'Dashboard'),
  AppNavItem(Icons.people_outline_rounded, 'Members'),
  AppNavItem(Icons.person_outline_rounded, 'Profile'),
];

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
      builder: (context, state) {
        final d = state.dashboard;
        return DashboardScaffold(
          navItems: _navItems,
          navRoutes: const {1: AppRoutes.memberSubscriptions}, // Members tab
          onRefresh: () => context.read<AdminDashboardCubit>().load(),
          children: [
            const DashboardHeader(
                roleLabel: 'Admin · Gym Manager', fallbackName: 'Admin'),
            const SizedBox(height: 20),
            if (d == null && state.status == LoadStatus.failure)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(children: [
                    Text(state.message ?? 'Could not load the dashboard.'),
                    TextButton(
                      onPressed: () => context.read<AdminDashboardCubit>().load(),
                      child: const Text('Try again'),
                    ),
                  ]),
                ),
              )
            else if (d == null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Center(child: CircularProgressIndicator()),
              )
            else ...[
              _RevenueCard(d: d),
              const SizedBox(height: 16),
              StatGrid(items: _stats(d)),
              const SizedBox(height: 20),
              const SectionTitle('Quick Actions'),
              const SizedBox(height: 10),
              const QuickActionRow(items: _quickActions),
              const SizedBox(height: 20),
              const SectionTitle('Recent Members'),
              const SizedBox(height: 10),
              if (state.recentMembers.isEmpty) const Text('No members yet.'),
              for (final m in state.recentMembers)
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

  static List<StatItem> _stats(AdminDashboardEntity d) => [
        StatItem(Icons.people_outline_rounded, AppColors.purple,
            '${d.totalMembers}', 'Total Members'),
        StatItem(Icons.sports_outlined, AppColors.info,
            '${d.totalTrainers}', 'Trainers'),
        StatItem(Icons.payment_rounded, AppColors.warning,
            '${d.subscriptions.expired + d.subscriptions.expiringSoon}',
            'Due Payments',
            trend: '↓ Expired or ending soon', up: false),
        StatItem(Icons.fitness_center_rounded, AppColors.success,
            '${d.totalGyms}', 'Gyms'),
      ];
}

class _RevenueCard extends StatelessWidget {
  final AdminDashboardEntity d;
  const _RevenueCard({required this.d});

  @override
  Widget build(BuildContext context) {
    final s = d.subscriptions;
    return GradientHeroCard(
      child: HeroFigure(
        caption: 'COLLECTED THIS MONTH',
        value: '৳ ${s.collectedThisMonth.toStringAsFixed(0)}',
        note: '${s.active} active · ${s.expired} expired members',
        badge: '${s.notSubscribed} without a plan',
      ),
    );
  }
}
