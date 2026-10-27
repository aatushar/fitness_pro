import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_palette.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/dashboard/dashboard_cards.dart';
import '../../widgets/dashboard/dashboard_header.dart';
import '../../widgets/dashboard/dashboard_scaffold.dart';
import '../../widgets/section_title.dart';

/// Owner (ROLE_OWNER) dashboard: owns one or more gyms (T_GYMS.owner_id)
/// and sees totals across all of them, plus who manages each gym.

// ── Sample data — later API থেকে আসবে ─────────────────────────

const _stats = [
  StatItem(Icons.store_mall_directory_outlined, AppColors.purple,
      '3', 'My Gyms', trend: '↑ 1 opened this year'),
  StatItem(Icons.people_outline_rounded, AppColors.success,
      '612', 'Total Members', trend: '↑ 21 this month'),
  StatItem(Icons.admin_panel_settings_outlined, AppColors.info,
      '3', 'Admins'),
  StatItem(Icons.sports_outlined, AppColors.warning,
      '14', 'Trainers', trend: '↓ 1 left this month', up: false),
];

const _quickActions = [
  QuickActionItem(Icons.add_business_outlined, 'Add Gym', AppColors.purple),
  QuickActionItem(Icons.person_add_alt_outlined, 'Add Admin', AppColors.info),
  QuickActionItem(Icons.bar_chart_rounded, 'Reports', AppColors.success),
  QuickActionItem(Icons.campaign_outlined, 'Notify All', AppColors.warning),
];

class _Gym {
  final String name;
  final String city;
  final int members;
  final int revenue;
  final bool active;
  const _Gym(this.name, this.city, this.members, this.revenue, this.active);
}

const _gyms = [
  _Gym('Fitness Pro Dhanmondi', 'Dhaka', 248, 124500, true),
  _Gym('Fitness Pro Uttara', 'Dhaka', 231, 98200, true),
  _Gym('Fitness Pro Agrabad', 'Chattogram', 133, 41300, false),
];

const _admins = [
  ('JN', AppColors.purple, 'Jannat', 'Fitness Pro Dhanmondi'),
  ('LB', AppColors.info, 'Lubna', 'Fitness Pro Uttara'),
  ('AL', AppColors.success, 'Alim', 'Fitness Pro Agrabad'),
];

const _navItems = [
  AppNavItem(Icons.grid_view_rounded, 'Home'),
  AppNavItem(Icons.store_mall_directory_outlined, 'Gyms'),
  AppNavItem(Icons.bar_chart_rounded, 'Reports'),
  AppNavItem(Icons.person_outline_rounded, 'Profile'),
];

String _taka(int amount) {
  // 124500 → 1,24,500 (Bangladeshi grouping)
  final s = amount.toString();
  if (s.length <= 3) return '৳ $s';
  final last3 = s.substring(s.length - 3);
  var rest = s.substring(0, s.length - 3);
  final parts = <String>[];
  while (rest.length > 2) {
    parts.insert(0, rest.substring(rest.length - 2));
    rest = rest.substring(0, rest.length - 2);
  }
  if (rest.isNotEmpty) parts.insert(0, rest);
  return '৳ ${parts.join(',')},$last3';
}

// ── Page ──────────────────────────────────────────────────────

class OwnerDashboardPage extends StatelessWidget {
  const OwnerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final total = _gyms.fold<int>(0, (sum, g) => sum + g.revenue);

    return DashboardScaffold(
      navItems: _navItems,
      children: [
        const DashboardHeader(roleLabel: 'Gym Owner', fallbackName: 'Owner'),
        const SizedBox(height: 20),
        GradientHeroCard(
          startColor: AppColors.planGradientStart,
          child: HeroFigure(
            caption: 'TOTAL REVENUE · ALL GYMS',
            value: _taka(total),
            note: '${_gyms.length} gyms · October 2025',
            badge: '↑ 9.1% vs last month',
          ),
        ),
        const SizedBox(height: 16),
        const StatGrid(items: _stats),
        const SizedBox(height: 20),
        const SectionTitle('Quick Actions'),
        const SizedBox(height: 10),
        const QuickActionRow(items: _quickActions),
        const SizedBox(height: 20),
        const SectionTitle('My Gyms'),
        const SizedBox(height: 10),
        for (final g in _gyms)
          DashboardListTile(
            leading: const IconBadge(
                icon: Icons.fitness_center_rounded, color: AppColors.purple),
            title: g.name,
            subtitle: '${g.city} · ${g.members} members',
            trailing: StatusChip(
              label: g.active ? 'Active' : 'Inactive',
              tone: g.active ? ChipTone.success : ChipTone.danger,
            ),
          ),
        const SizedBox(height: 10),
        const SectionTitle('Revenue by Gym'),
        const SizedBox(height: 10),
        SurfaceCard(
          child: Column(
            children: [
              for (var i = 0; i < _gyms.length; i++) ...[
                _RevenueBar(
                  name: _gyms[i].name,
                  amount: _taka(_gyms[i].revenue),
                  share: _gyms[i].revenue / total,
                ),
                if (i < _gyms.length - 1) const SizedBox(height: 14),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),
        const SectionTitle('Gym Admins'),
        const SizedBox(height: 10),
        for (final a in _admins)
          DashboardListTile(
            leading: InitialsAvatar(initials: a.$1, color: a.$2),
            title: a.$3,
            subtitle: a.$4,
            trailing: const StatusChip(label: 'Admin', tone: ChipTone.info),
          ),
      ],
    );
  }
}

class _RevenueBar extends StatelessWidget {
  final String name;
  final String amount;
  final double share;

  const _RevenueBar({
    required this.name,
    required this.amount,
    required this.share,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(name,
                style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600,
                  color: palette.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(amount,
                textAlign: TextAlign.end,
                style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w700,
                  color: AppColors.purple,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: share,
            minHeight: 7,
            backgroundColor: palette.surfaceAlt,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.purple),
          ),
        ),
        const SizedBox(height: 4),
        Text('${(share * 100).round()}% of total',
          style: TextStyle(fontSize: 10, color: palette.textMuted),
        ),
      ],
    );
  }
}
