import 'package:flutter/material.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_palette.dart';

// Building blocks shared by the role dashboards (owner, admin, trainer, member).

/// Bordered surface card that follows the theme.
class SurfaceCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.palette.border),
      ),
      child: child,
    );
  }
}

/// Purple gradient "hero" card at the top of a dashboard.
class GradientHeroCard extends StatelessWidget {
  final Color startColor;
  final Widget child;

  const GradientHeroCard({
    super.key,
    this.startColor = AppColors.revenueGradientStart,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [startColor, AppColors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.purple.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Small uppercase caption, big value and a note — the usual hero content.
class HeroFigure extends StatelessWidget {
  final String caption;
  final String value;
  final String note;
  final String? badge;

  const HeroFigure({
    super.key,
    required this.caption,
    required this.value,
    required this.note,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(caption,
          style: const TextStyle(
            fontSize: 9, fontWeight: FontWeight.w600,
            color: Colors.white60, letterSpacing: 0.08,
          ),
        ),
        const SizedBox(height: 6),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(value,
            style: const TextStyle(
              fontSize: 30, fontWeight: FontWeight.w800,
              color: Colors.white, letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(note, style: const TextStyle(fontSize: 12, color: Colors.white54)),
        if (badge != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(badge!,
              style: const TextStyle(
                fontSize: 9, fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ── Stat grid ──────────────────────────────────────────────────

class StatItem {
  final IconData icon;
  final Color color;
  final String value;
  final String label;
  final String? trend;
  final bool up;

  const StatItem(this.icon, this.color, this.value, this.label,
      {this.trend, this.up = true});
}

/// 2 tiles per row on phones, 4 per row on tablets / desktop.
class StatGrid extends StatelessWidget {
  final List<StatItem> items;
  const StatGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    const spacing = 10.0;
    return LayoutBuilder(builder: (context, constraints) {
      final columns = constraints.maxWidth >= Breakpoints.compact ? 4 : 2;
      final itemWidth =
          (constraints.maxWidth - spacing * (columns - 1)) / columns;
      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: [
          for (final s in items)
            SizedBox(width: itemWidth, child: _StatTile(stat: s)),
        ],
      );
    });
  }
}

class _StatTile extends StatelessWidget {
  final StatItem stat;
  const _StatTile({required this.stat});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return SurfaceCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconBadge(icon: stat.icon, color: stat.color, size: 32),
          const SizedBox(height: 12),
          Text(stat.value,
            style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w800,
              color: palette.textPrimary, letterSpacing: -0.3,
            ),
          ),
          Text(stat.label,
            style: TextStyle(fontSize: 10, color: palette.textMuted),
          ),
          if (stat.trend != null) ...[
            const SizedBox(height: 2),
            Text(stat.trend!,
              style: TextStyle(
                fontSize: 9, fontWeight: FontWeight.w600,
                color: stat.up ? AppColors.success : AppColors.danger,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Tinted rounded square holding an icon.
class IconBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const IconBadge({
    super.key,
    required this.icon,
    required this.color,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: context.isDarkTheme ? 0.2 : 0.12),
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Icon(icon, color: color, size: size / 2),
    );
  }
}

// ── Quick actions ──────────────────────────────────────────────

class QuickActionItem {
  final IconData icon;
  final String label;
  final Color color;
  const QuickActionItem(this.icon, this.label, this.color);
}

class QuickActionRow extends StatelessWidget {
  final List<QuickActionItem> items;
  const QuickActionRow({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < items.length; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i < items.length - 1 ? 8 : 0),
              child: Material(
                color: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: palette.border),
                ),
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(14),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14, horizontal: 4,
                    ),
                    child: Column(children: [
                      IconBadge(icon: items[i].icon, color: items[i].color),
                      const SizedBox(height: 6),
                      Text(items[i].label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 9, fontWeight: FontWeight.w600,
                          color: palette.textMuted,
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ── List rows ──────────────────────────────────────────────────

enum ChipTone { success, warning, danger, info }

/// Small coloured pill, e.g. "Active" / "Due" / "Low stock".
class StatusChip extends StatelessWidget {
  final String label;
  final ChipTone tone;

  const StatusChip({super.key, required this.label, required this.tone});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final (fg, bg) = switch (tone) {
      ChipTone.success => (AppColors.success, palette.tintGreen),
      ChipTone.warning => (AppColors.warning, palette.tintAmber),
      ChipTone.danger  => (AppColors.danger, palette.tintRed),
      ChipTone.info    => (AppColors.purple, palette.tintPurple),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}

/// Coloured initials square used as a person's avatar in lists.
class InitialsAvatar extends StatelessWidget {
  final String initials;
  final Color color;

  const InitialsAvatar({super.key, required this.initials, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38, height: 38,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(initials,
            style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// One row of a dashboard list: leading widget, title/subtitle, trailing chip.
class DashboardListTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String subtitle;
  final Widget? trailing;

  const DashboardListTile({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SurfaceCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                    style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600,
                      color: palette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle,
                    style: TextStyle(fontSize: 11, color: palette.textMuted),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              Flexible(child: trailing!),
            ],
          ],
        ),
      ),
    );
  }
}
