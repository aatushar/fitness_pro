import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/router/app_routes.dart';
import '../app_bottom_nav.dart';

/// Shared page shell for every role dashboard: scrolling, width-capped
/// content plus a bottom nav whose last item opens the profile page.
class DashboardScaffold extends StatefulWidget {
  final List<AppNavItem> navItems;
  final List<Widget> children;

  /// Bottom-nav index -> page to open when that item is tapped. Items not
  /// listed here only highlight (their content is not built yet).
  final Map<int, String> navRoutes;

  /// When set, pulling the page down calls this to reload its data.
  final Future<void> Function()? onRefresh;

  const DashboardScaffold({
    super.key,
    required this.navItems,
    required this.children,
    this.navRoutes = const {},
    this.onRefresh,
  });

  @override
  State<DashboardScaffold> createState() => _DashboardScaffoldState();
}

class _DashboardScaffoldState extends State<DashboardScaffold>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  // One controller drives every block: each starts a little after the one
  // above it, so the page builds itself from the top down.
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  Widget _entering(int index, Widget child) {
    final start = (index * 0.05).clamp(0.0, 0.45);
    final curve = _entrance.drive(CurveTween(
      curve: Interval(start, (start + 0.5).clamp(0.0, 1.0),
          curve: Curves.easeOutCubic),
    ));
    return FadeTransition(
      opacity: curve,
      child: SlideTransition(
        position: Tween(begin: const Offset(0, 0.06), end: Offset.zero)
            .animate(curve),
        child: child,
      ),
    );
  }

  void _onNavTap(int index) {
    if (index == widget.navItems.length - 1) {
      context.push(AppRoutes.profile);
      return;
    }
    final route = widget.navRoutes[index];
    if (route != null) {
      context.push(route);
      return;
    }
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final content = SingleChildScrollView(
      // Lets the pull-down gesture work even when the page fits the screen.
      physics: widget.onRefresh == null
          ? null
          : const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: ResponsiveCenter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final (i, child) in widget.children.indexed) _entering(i, child),
          ],
        ),
      ),
    );

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: widget.onRefresh == null
            ? content
            : RefreshIndicator(onRefresh: widget.onRefresh!, child: content),
      ),
      bottomNavigationBar: AppBottomNav(
        items: widget.navItems,
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
