import 'package:flutter/material.dart';

class Breakpoints {
  Breakpoints._();

  static const double compact = 600;
  static const double medium  = 1024;

  /// Max width for single-column forms (sign in / sign up).
  static const double formMaxWidth    = 480;

  /// Max width for scrolling content pages (dashboards, profile).
  static const double contentMaxWidth = 840;

  static bool isCompact(BuildContext context) =>
      MediaQuery.sizeOf(context).width < compact;
}

/// Centers [child] and caps its width so forms and content
/// don't stretch edge to edge on tablets and desktop browsers.
class ResponsiveCenter extends StatelessWidget {
  final double maxWidth;
  final Widget child;

  const ResponsiveCenter({
    super.key,
    this.maxWidth = Breakpoints.contentMaxWidth,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
