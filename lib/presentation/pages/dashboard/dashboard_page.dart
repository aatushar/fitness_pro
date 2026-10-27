import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/dashboard/dashboard_cards.dart';
import '../../widgets/dashboard/dashboard_header.dart';
import '../../widgets/dashboard/dashboard_scaffold.dart';
import '../../widgets/section_title.dart';

/// Admin (ROLE_MANAGER) dashboard: runs one gym — members, trainers,
/// shop stock (T_PRODUCTS) and sales (T_SALES).

// ── Sample data — later API থেকে আসবে ─────────────────────────

const _stats = [
  StatItem(Icons.people_outline_rounded, AppColors.purple,
      '248', 'Total Members', trend: '↑ 8 this week'),
  StatItem(Icons.sports_outlined, AppColors.info,
      '6', 'Active Trainers', trend: '↑ All on duty'),
  StatItem(Icons.payment_rounded, AppColors.warning,
      '12', 'Due Payments', trend: '↓ Need attention', up: false),
  StatItem(Icons.point_of_sale_rounded, AppColors.success,
      '৳ 8,450', "Today's Sales", trend: '↑ 14 orders'),
];

const _quickActions = [
  QuickActionItem(Icons.person_add_outlined, 'Add Member', AppColors.purple),
  QuickActionItem(Icons.how_to_reg_outlined, 'Assign Trainer', AppColors.info),
  QuickActionItem(Icons.inventory_2_outlined, 'Products', AppColors.warning),
  QuickActionItem(Icons.campaign_outlined, 'Notify', AppColors.success),
];

const _members = [
  ('RK', AppColors.purple, 'Rakibul Islam', 'Premium · 3 months', 'Active', ChipTone.success),
  ('SH', AppColors.success, 'Sadia Hossain', 'Basic · 1 month', 'Due', ChipTone.warning),
  ('MR', AppColors.warning, 'Mehedi Rahman', 'Premium · 6 months', 'Expired', ChipTone.danger),
];

const _lowStock = [
  ('Whey Protein 2kg', 'Supplements', 3),
  ('Gym Gloves (L)', 'Accessories', 5),
  ('Shaker Bottle', 'Accessories', 0),
];

const _recentSales = [
  ('Rakibul Islam', '2 items · Cash', '৳ 3,200'),
  ('Sadia Hossain', '1 item · bKash', '৳ 450'),
  ('Walk-in', '3 items · Card', '৳ 1,850'),
];

const _navItems = [
  AppNavItem(Icons.grid_view_rounded, 'Dashboard'),
  AppNavItem(Icons.people_outline_rounded, 'Members'),
  AppNavItem(Icons.storefront_outlined, 'Shop'),
  AppNavItem(Icons.person_outline_rounded, 'Profile'),
];

// ── Page ──────────────────────────────────────────────────────

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      navItems: _navItems,
      children: [
        const DashboardHeader(roleLabel: 'Admin · Gym Manager', fallbackName: 'Admin'),
        const SizedBox(height: 20),
        const _RevenueCard(),
        const SizedBox(height: 16),
        const StatGrid(items: _stats),
        const SizedBox(height: 20),
        const SectionTitle('Quick Actions'),
        const SizedBox(height: 10),
        const QuickActionRow(items: _quickActions),
        const SizedBox(height: 20),
        const SectionTitle('Recent Members'),
        const SizedBox(height: 10),
        for (final m in _members)
          DashboardListTile(
            leading: InitialsAvatar(initials: m.$1, color: m.$2),
            title: m.$3,
            subtitle: m.$4,
            trailing: StatusChip(label: m.$5, tone: m.$6),
          ),
        const SizedBox(height: 10),
        const SectionTitle('Low Stock'),
        const SizedBox(height: 10),
        for (final p in _lowStock)
          DashboardListTile(
            leading: const IconBadge(
                icon: Icons.inventory_2_outlined, color: AppColors.warning),
            title: p.$1,
            subtitle: p.$2,
            trailing: StatusChip(
              label: p.$3 == 0 ? 'Out of stock' : '${p.$3} left',
              tone: p.$3 == 0 ? ChipTone.danger : ChipTone.warning,
            ),
          ),
        const SizedBox(height: 10),
        const SectionTitle('Recent Sales'),
        const SizedBox(height: 10),
        for (final s in _recentSales)
          DashboardListTile(
            leading: const IconBadge(
                icon: Icons.receipt_long_outlined, color: AppColors.success),
            title: s.$1,
            subtitle: s.$2,
            trailing: StatusChip(label: s.$3, tone: ChipTone.success),
          ),
      ],
    );
  }
}

// ── Revenue Card ───────────────────────────────────────────────

class _RevenueCard extends StatelessWidget {
  const _RevenueCard();

  @override
  Widget build(BuildContext context) {
    return const GradientHeroCard(
      child: Stack(
        children: [
          // Mini chart (behind the text)
          Positioned(
            right: 0, bottom: 0,
            child: Opacity(
              opacity: 0.2,
              child: CustomPaint(
                size: Size(90, 60),
                painter: _ChartPainter(),
              ),
            ),
          ),
          HeroFigure(
            caption: 'MONTHLY REVENUE',
            value: '৳ 1,24,500',
            note: 'October 2025',
            badge: '↑ 12.4% vs last month',
          ),
        ],
      ),
    );
  }
}

// ── Mini Chart Painter ─────────────────────────────────────────

class _ChartPainter extends CustomPainter {
  const _ChartPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5 * size.shortestSide / 60
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(0, size.height * 0.85)
      ..lineTo(size.width * 0.2, size.height * 0.65)
      ..lineTo(size.width * 0.4, size.height * 0.75)
      ..lineTo(size.width * 0.6, size.height * 0.35)
      ..lineTo(size.width * 0.8, size.height * 0.5)
      ..lineTo(size.width, size.height * 0.1);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ChartPainter oldDelegate) => false;
}
