import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/l10n/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../blocs/current_user/current_user_cubit.dart';
import '../../widgets/welcome/lifter_painter.dart';

/// Shown right after sign-in: a barbell gets loaded plate by plate, then on
/// to the dashboard at [next]. Always dark, like a gym at night. Needs a
/// [CurrentUserCubit] above it for the name.
class WelcomePage extends StatefulWidget {
  /// Route to open when the animation ends (or is skipped).
  final String next;

  /// How long the welcome plays before moving on.
  final Duration duration;

  const WelcomePage({
    super.key,
    required this.next,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  late final AnimationController _rep;
  late final AnimationController _progress;
  late final AnimationController _plate;
  late final Animation<double> _press;
  Timer? _timer;
  int _reps = 0;
  bool _left = false;

  @override
  void initState() {
    super.initState();
    _rep = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.reverse && mounted) {
          // Reversing means the bar just locked out: count it, add a plate.
          setState(() => _reps++);
          _plate.forward(from: 0);
        }
      })
      ..repeat(reverse: true);
    _press = CurvedAnimation(parent: _rep, curve: Curves.easeInOutCubic);
    _progress =
        AnimationController(vsync: this, duration: widget.duration)..forward();
    _plate = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
      value: 1,
    );
    _timer = Timer(widget.duration, _continue);
  }

  void _continue() {
    if (_left || !mounted) return;
    _left = true;
    context.go(widget.next);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _rep.dispose();
    _progress.dispose();
    _plate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = context.watch<CurrentUserCubit>().state;
    final plates = (_reps + 1).clamp(1, 4);
    final kilos = 20 + plates * 20;

    return Scaffold(
      backgroundColor: AppColors.gymBgBottom,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.gymBgTop, AppColors.gymBgBottom],
          ),
        ),
        child: SafeArea(
          child: Stack(children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // The picture is decorative; the text below says it all.
                      ExcludeSemantics(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: AnimatedBuilder(
                            animation:
                                Listenable.merge([_press, _progress, _plate]),
                            builder: (_, __) => CustomPaint(
                              painter: LifterPainter(
                                press: _press.value,
                                progress: _progress.value,
                                plates: plates,
                                plateIn: _plate.value,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${'Welcome back'.tr(context)}'
                        '${name == null || name.isEmpty ? '' : ', $name'}!',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 26, fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text("Let's get stronger today".tr(context),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10, runSpacing: 10,
                        children: [
                          _Pill(
                            '${'REPS'.tr(context)}  ${AppStrings.digits('$_reps')}',
                          ),
                          _Pill(
                            '${AppStrings.digits('$kilos')} ${'KG'.tr(context)}',
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text('Warming up your dashboard…'.tr(context),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 4, right: 8,
              child: TextButton(
                onPressed: _continue,
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                child: Text('Skip'.tr(context)),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  const _Pill(this.text);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w800,
            color: AppColors.purpleLight,
          ),
        ),
      );
}
