import 'package:flutter/material.dart';
import '../../../core/l10n/app_strings.dart';
import '../../../core/theme/app_colors.dart';

/// Gym-style banner at the top of the sign-in page: a purple gradient, a
/// dumbbell that "lifts" gently, the brand name and a few selling points.
class AuthHero extends StatefulWidget {
  const AuthHero({super.key});

  @override
  State<AuthHero> createState() => _AuthHeroState();
}

class _AuthHeroState extends State<AuthHero>
    with SingleTickerProviderStateMixin {
  late final AnimationController _lift = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _lift.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lift = CurvedAnimation(parent: _lift, curve: Curves.easeInOut);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.planGradientStart,
            AppColors.purpleDeep,
            AppColors.purpleLight,
          ],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(36)),
        child: Stack(children: [
          // Faint weights in the corners for a gym feel.
          Positioned(
            right: -24, top: 24,
            child: _Faint(Icons.fitness_center_rounded, 130, 0.35),
          ),
          Positioned(
            left: -30, bottom: -20,
            child: _Faint(Icons.fitness_center_rounded, 110, -0.5),
          ),
          Positioned(
            left: 40, top: 8,
            child: _Faint(Icons.bolt_rounded, 54, 0),
          ),
          SafeArea(
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ExcludeSemantics(
                        child: AnimatedBuilder(
                          animation: lift,
                          builder: (_, child) => Transform.translate(
                            offset: Offset(0, -8 * lift.value),
                            child: Transform.rotate(
                              angle: -0.18 + 0.36 * lift.value,
                              child: child,
                            ),
                          ),
                          child: Container(
                            width: 84, height: 84,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.5),
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.fitness_center_rounded,
                              color: Colors.white, size: 44,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'FITNESS PRO',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26, fontWeight: FontWeight.w900,
                          color: Colors.white, letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Train hard. Stay strong.'.tr(context),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8, runSpacing: 8,
                        children: [
                          _Pill(Icons.groups_rounded, 'Members'.tr(context)),
                          _Pill(Icons.sports_gymnastics_rounded,
                              'Trainers'.tr(context)),
                          _Pill(Icons.payments_rounded,
                              'Payments'.tr(context)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _Faint extends StatelessWidget {
  final IconData icon;
  final double size;
  final double angle;
  const _Faint(this.icon, this.size, this.angle);

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
        child: Transform.rotate(
          angle: angle,
          child: Icon(icon,
              size: size, color: Colors.white.withValues(alpha: 0.08)),
        ),
      );
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Pill(this.icon, this.label);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 15, color: Colors.white),
          const SizedBox(width: 6),
          Flexible(
            child: Text(label,
                style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w700,
                  color: Colors.white,
                )),
          ),
        ]),
      );
}
