import 'package:flutter/material.dart';
import '../../core/theme/app_palette.dart';

/// ───── text ───── divider used under the auth forms.
class LabeledDivider extends StatelessWidget {
  final String text;
  const LabeledDivider({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(children: [
      Expanded(child: Divider(color: palette.border)),
      Flexible(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: palette.textMuted),
          ),
        ),
      ),
      Expanded(child: Divider(color: palette.border)),
    ]);
  }
}
