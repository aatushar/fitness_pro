import 'package:flutter/material.dart';
import '../../core/theme/app_palette.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(title,
      style: TextStyle(
        fontSize: 15, fontWeight: FontWeight.w700,
        color: context.palette.textPrimary, letterSpacing: -0.2,
      ),
    );
  }
}
