import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_palette.dart';
import '../../core/l10n/app_strings.dart';

/// Bordered square back button used in page top bars.
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Semantics(
      button: true,
      label: 'Back'.tr(context),
      child: GestureDetector(
        // Opened directly by URL on web there is nothing to pop.
        onTap: () => context.canPop()
            ? context.pop()
            : context.go(AppRoutes.dashboard),
        child: Container(
          width: 38, height: 38,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: palette.border),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: palette.textPrimary, size: 16,
          ),
        ),
      ),
    );
  }
}
