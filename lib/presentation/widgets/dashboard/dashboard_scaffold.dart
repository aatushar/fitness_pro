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

  const DashboardScaffold({
    super.key,
    required this.navItems,
    required this.children,
  });

  @override
  State<DashboardScaffold> createState() => _DashboardScaffoldState();
}

class _DashboardScaffoldState extends State<DashboardScaffold> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    if (index == widget.navItems.length - 1) {
      context.push(AppRoutes.profile);
      return;
    }
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ResponsiveCenter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.children,
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        items: widget.navItems,
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
