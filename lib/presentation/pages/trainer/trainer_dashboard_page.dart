import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/dashboard/dashboard_cards.dart';
import '../../widgets/dashboard/dashboard_header.dart';
import '../../widgets/dashboard/dashboard_scaffold.dart';
import '../../widgets/section_title.dart';

/// Trainer (ROLE_TRAINER) dashboard: assigned members (T_TRAINER_USERS),
/// workouts they assign (T_WORKOUT_EXERCISES) and members' progress
/// (T_STRENGTH_LOG).

// ── Sample data — later API থেকে আসবে ─────────────────────────

const _stats = [
  StatItem(Icons.groups_outlined, AppColors.purple,
      '12', 'My Members', trend: '↑ 2 assigned this week'),
  StatItem(Icons.event_available_outlined, AppColors.success,
      '3/5', "Today's Sessions"),
  StatItem(Icons.fitness_center_rounded, AppColors.info,
      '18', 'Plans Assigned'),
  StatItem(Icons.trending_up_rounded, AppColors.warning,
      '9', 'Improved This Month', trend: '↑ 75% of members'),
];

const _quickActions = [
  QuickActionItem(Icons.playlist_add_rounded, 'Assign Workout', AppColors.purple),
  QuickActionItem(Icons.edit_note_rounded, 'Log Progress', AppColors.success),
  QuickActionItem(Icons.chat_bubble_outline_rounded, 'Message', AppColors.info),
  QuickActionItem(Icons.list_alt_rounded, 'Exercises', AppColors.warning),
];

enum _Level { beginner, pro }

class _Trainee {
  final String initials;
  final Color color;
  final String name;
  final _Level level;
  final String today;
  const _Trainee(this.initials, this.color, this.name, this.level, this.today);
}

const _trainees = [
  _Trainee('RK', AppColors.purple, 'Rakibul Islam', _Level.pro, 'Chest & Triceps · 6:00 PM'),
  _Trainee('SH', AppColors.success, 'Sadia Hossain', _Level.beginner, 'Full body · 7:30 AM'),
  _Trainee('MR', AppColors.warning, 'Mehedi Rahman', _Level.beginner, 'Rest day'),
];

const _todayPlan = [
  ('Bench Press', 'Rakibul · 4 sets × 12 reps', true),
  ('Squats', 'Sadia · 3 sets × 15 reps', true),
  ('Deadlift', 'Rakibul · 4 sets × 8 reps', false),
  ('Treadmill', 'Sadia · 20 mins', false),
];

const _recentProgress = [
  ('RK', AppColors.purple, 'Rakibul · Bench Press', '4 × 12 · 65 kg', '↑ 5 kg'),
  ('SH', AppColors.success, 'Sadia · Squats', '3 × 15 · 30 kg', '↑ 2.5 kg'),
  ('MR', AppColors.warning, 'Mehedi · Deadlift', '3 × 8 · 70 kg', 'Same'),
];

const _navItems = [
  AppNavItem(Icons.grid_view_rounded, 'Home'),
  AppNavItem(Icons.groups_outlined, 'Members'),
  AppNavItem(Icons.fitness_center_rounded, 'Workouts'),
  AppNavItem(Icons.person_outline_rounded, 'Profile'),
];

// ── Page ──────────────────────────────────────────────────────

class TrainerDashboardPage extends StatelessWidget {
  const TrainerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final done = _todayPlan.where((w) => w.$3).length;

    return DashboardScaffold(
      navItems: _navItems,
      children: [
        const DashboardHeader(roleLabel: 'Trainer', fallbackName: 'Trainer'),
        const SizedBox(height: 20),
        GradientHeroCard(
          startColor: AppColors.planGradientStart,
          child: HeroFigure(
            caption: "TODAY'S WORKOUTS",
            value: '$done of ${_todayPlan.length} done',
            note: '${_trainees.length} members training today',
            badge: '12 members assigned to you',
          ),
        ),
        const SizedBox(height: 16),
        const StatGrid(items: _stats),
        const SizedBox(height: 20),
        const SectionTitle('Quick Actions'),
        const SizedBox(height: 10),
        const QuickActionRow(items: _quickActions),
        const SizedBox(height: 20),
        const SectionTitle('My Members'),
        const SizedBox(height: 10),
        for (final t in _trainees)
          DashboardListTile(
            leading: InitialsAvatar(initials: t.initials, color: t.color),
            title: t.name,
            subtitle: t.today,
            trailing: StatusChip(
              label: t.level == _Level.pro ? 'Pro' : 'Beginner',
              tone: t.level == _Level.pro ? ChipTone.info : ChipTone.success,
            ),
          ),
        const SizedBox(height: 10),
        const SectionTitle("Today's Plan"),
        const SizedBox(height: 10),
        for (final w in _todayPlan)
          DashboardListTile(
            leading: IconBadge(
              icon: w.$3 ? Icons.check_circle_outline_rounded : Icons.schedule_rounded,
              color: w.$3 ? AppColors.success : AppColors.warning,
            ),
            title: w.$1,
            subtitle: w.$2,
            trailing: StatusChip(
              label: w.$3 ? 'Done' : 'Pending',
              tone: w.$3 ? ChipTone.success : ChipTone.warning,
            ),
          ),
        const SizedBox(height: 10),
        const SectionTitle('Recent Progress'),
        const SizedBox(height: 10),
        for (final p in _recentProgress)
          DashboardListTile(
            leading: InitialsAvatar(initials: p.$1, color: p.$2),
            title: p.$3,
            subtitle: p.$4,
            trailing: StatusChip(
              label: p.$5,
              tone: p.$5.startsWith('↑') ? ChipTone.success : ChipTone.info,
            ),
          ),
      ],
    );
  }
}
