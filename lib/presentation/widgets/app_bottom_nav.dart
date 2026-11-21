import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_palette.dart';
import '../../core/l10n/app_strings.dart';

class AppNavItem {
  final IconData icon;
  final String label;
  const AppNavItem(this.icon, this.label);
}

/// Bottom navigation bar: active item shows a dot, the others their label.
class AppBottomNav extends StatelessWidget {
  final List<AppNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(top: BorderSide(color: palette.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: InkWell(
                    onTap: () => onTap(i),
                    borderRadius: BorderRadius.circular(12),
                    child: Semantics(
                      selected: i == currentIndex,
                      label: items[i].label.tr(context),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Icon(items[i].icon,
                          color: i == currentIndex
                              ? AppColors.purple
                              : palette.textMuted,
                          size: 22,
                        ),
                        const SizedBox(height: 4),
                        if (i == currentIndex)
                          Container(
                            width: 4, height: 4,
                            decoration: const BoxDecoration(
                              color: AppColors.purple,
                              shape: BoxShape.circle,
                            ),
                          )
                        else
                          // Scales down instead of cutting the label off.
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(items[i].label.tr(context),
                              style: TextStyle(
                                fontSize: 9, color: palette.textMuted,
                              ),
                            ),
                          ),
                      ]),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
