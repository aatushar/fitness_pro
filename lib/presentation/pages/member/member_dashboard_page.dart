import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/di/injection.dart';
import '../../../core/storage/token_storage.dart';
import '../../../core/theme/app_colors.dart';
import '../../blocs/theme/theme_cubit.dart';

class MemberDashboardPage extends StatefulWidget {
  const MemberDashboardPage({super.key});
  @override
  State<MemberDashboardPage> createState() => _MemberDashboardPageState();
}

class _MemberDashboardPageState extends State<MemberDashboardPage> {
  int _currentIndex = 0;
  String _username  = '';

  // Static sample data — later API থেকে আসবে
  final double _height    = 175;
  final double _weight    = 68;
  final double _goalWeight= 65;
  final double _bmi       = 22.4;
  final double _bodyFat   = 18.5;
  final int    _daysLeft  = 23;
  final int    _totalDays = 90;
  final String _planName  = 'Premium · 3 Months';
  final String _startDate = 'Oct 1, 2025';
  final String _endDate   = 'Dec 31, 2025';

  // Weight history (month, weight)
  final List<Map<String, dynamic>> _weightHistory = [
    {'month': 'May', 'weight': 74.0},
    {'month': 'Jun', 'weight': 73.0},
    {'month': 'Jul', 'weight': 71.5},
    {'month': 'Aug', 'weight': 70.0},
    {'month': 'Sep', 'weight': 69.0},
    {'month': 'Oct', 'weight': 68.0},
  ];

  final List<Map<String, dynamic>> _workouts = [
    {'icon': '🏋️', 'color': 0xFF7B2FBE, 'name': 'Bench Press',
      'detail': '4 sets · 12 reps · 60 kg', 'done': true},
    {'icon': '🏃', 'color': 0xFF10B981, 'name': 'Treadmill',
      'detail': '30 mins · 6 km/h', 'done': true},
    {'icon': '💪', 'color': 0xFF3B82F6, 'name': 'Bicep Curls',
      'detail': '3 sets · 15 reps · 15 kg', 'done': false},
    {'icon': '🧘', 'color': 0xFFF59E0B, 'name': 'Stretching',
      'detail': '15 mins cool down', 'done': false},
  ];

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final name = await sl<TokenStorage>().getUsername();
    if (mounted) setState(() => _username = name ?? 'Member');
  }

  bool get _isDark =>
      context.read<ThemeCubit>().state == ThemeMode.dark;

  Color get _bg        => _isDark ? AppColors.darkBg        : AppColors.lightBg;
  Color get _surface   => _isDark ? AppColors.darkSurface    : AppColors.lightSurface;
  Color get _surfaceAlt=> _isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt;
  Color get _border    => _isDark ? AppColors.darkBorder     : AppColors.lightBorder;
  Color get _textPrim  => _isDark ? AppColors.darkTextPrim   : AppColors.lightTextPrim;
  Color get _textMuted => _isDark ? AppColors.darkTextMuted  : AppColors.lightTextMuted;

  double get _progressPercent =>
      (_totalDays - _daysLeft) / _totalDays;

  String get _bmiStatus {
    if (_bmi < 18.5) return 'Underweight';
    if (_bmi < 25)   return 'Normal';
    if (_bmi < 30)   return 'Overweight';
    return 'Obese';
  }

  Color get _bmiColor {
    if (_bmi < 18.5) return const Color(0xFF3B82F6);
    if (_bmi < 25)   return const Color(0xFF10B981);
    if (_bmi < 30)   return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ThemeCubit, ThemeMode>(
      listener: (_, __) => setState(() {}),
      builder: (context, _) => Scaffold(
        backgroundColor: _bg,
        body: SafeArea(
          child: Column(children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildSubscriptionCard(),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Body Stats'),
                    const SizedBox(height: 10),
                    _buildBMIRow(),
                    const SizedBox(height: 10),
                    _buildBodyStatsRow(),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Weight Progress'),
                    const SizedBox(height: 10),
                    _buildWeightGraph(),
                    const SizedBox(height: 20),
                    _buildSectionTitle("Today's Workout"),
                    const SizedBox(height: 10),
                    _buildWorkoutCard(),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            _buildBottomNav(),
          ]),
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────
  Widget _buildHeader() {
    final initial = _username.isNotEmpty
        ? _username[0].toUpperCase() : 'M';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7B2FBE), Color(0xFFA855F7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Center(
              child: Text(initial,
                style: GoogleFonts.inter(
                  fontSize: 18, fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_username,
              style: GoogleFonts.inter(
                fontSize: 16, fontWeight: FontWeight.w700,
                color: _textPrim, letterSpacing: -0.3,
              ),
            ),
            Text('Premium Member',
              style: GoogleFonts.inter(
                fontSize: 11, color: _textMuted,
              ),
            ),
          ]),
        ]),
        Row(children: [
          // Theme toggle
          GestureDetector(
            onTap: () => context.read<ThemeCubit>().toggleTheme(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 46, height: 26,
              decoration: BoxDecoration(
                color: _surfaceAlt,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _border),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                alignment: _isDark
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Container(
                  width: 20, height: 20,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: AppColors.purple,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isDark
                        ? Icons.dark_mode_rounded
                        : Icons.light_mode_rounded,
                    color: Colors.white, size: 11,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: _border),
            ),
            child: Stack(alignment: Alignment.center, children: [
              Icon(Icons.notifications_none_rounded,
                  color: AppColors.purple, size: 20),
              Positioned(
                top: 8, right: 8,
                child: Container(
                  width: 7, height: 7,
                  decoration: const BoxDecoration(
                    color: AppColors.purple,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ]),
          ),
        ]),
      ],
    );
  }

  // ── Subscription Card ───────────────────────────────────────
  Widget _buildSubscriptionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E0A4E), Color(0xFF7B2FBE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(
          color: AppColors.purple.withOpacity(0.3),
          blurRadius: 20, offset: const Offset(0, 8),
        )],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('MEMBERSHIP PLAN',
                  style: GoogleFonts.inter(
                    fontSize: 10, fontWeight: FontWeight.w600,
                    color: Colors.white60, letterSpacing: 0.08,
                  ),
                ),
                const SizedBox(height: 3),
                Text(_planName,
                  style: GoogleFonts.inter(
                    fontSize: 15, fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ]),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('✓ Active',
                  style: GoogleFonts.inter(
                    fontSize: 11, fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          RichText(text: TextSpan(
            children: [
              TextSpan(
                text: '$_daysLeft ',
                style: GoogleFonts.inter(
                  fontSize: 32, fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              TextSpan(
                text: 'days left',
                style: GoogleFonts.inter(
                  fontSize: 15, fontWeight: FontWeight.w500,
                  color: Colors.white60,
                ),
              ),
            ],
          )),

          const SizedBox(height: 12),

          // Progress bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_startDate,
                style: GoogleFonts.inter(
                  fontSize: 10, color: Colors.white54,
                ),
              ),
              Text(_endDate,
                style: GoogleFonts.inter(
                  fontSize: 10, color: Colors.white54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: _progressPercent,
              minHeight: 7,
              backgroundColor: Colors.white.withOpacity(0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${(_progressPercent * 100).toInt()}% completed',
                style: GoogleFonts.inter(
                  fontSize: 10, color: Colors.white54,
                ),
              ),
              Text('Renew now →',
                style: GoogleFonts.inter(
                  fontSize: 10, fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── BMI Row ─────────────────────────────────────────────────
  Widget _buildBMIRow() {
    return Row(children: [
      Expanded(child: _buildStatCard(
        emoji: '⚖️',
        emojiColor: _isDark ? const Color(0xFF1E1040) : const Color(0xFFEDE9FE),
        value: _bmi.toStringAsFixed(1),
        label: 'BMI Index',
        statusText: _bmiStatus,
        statusColor: _bmiColor,
      )),
      const SizedBox(width: 10),
      Expanded(child: _buildStatCard(
        emoji: '💪',
        emojiColor: _isDark ? const Color(0xFF0D3D28) : const Color(0xFFD1FAE5),
        value: '${_bodyFat.toStringAsFixed(1)}%',
        label: 'Body Fat',
        statusText: 'Healthy',
        statusColor: const Color(0xFF10B981),
      )),
    ]);
  }

  Widget _buildStatCard({
    required String emoji,
    required Color emojiColor,
    required String value,
    required String label,
    required String statusText,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: emojiColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Text(emoji,
              style: const TextStyle(fontSize: 16))),
        ),
        const SizedBox(height: 10),
        Text(value,
          style: GoogleFonts.inter(
            fontSize: 22, fontWeight: FontWeight.w800,
            color: _textPrim, letterSpacing: -0.3,
          ),
        ),
        Text(label,
          style: GoogleFonts.inter(fontSize: 11, color: _textMuted),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(statusText,
            style: GoogleFonts.inter(
              fontSize: 9, fontWeight: FontWeight.w700,
              color: statusColor,
            ),
          ),
        ),
      ]),
    );
  }

  // ── Body Stats Row ──────────────────────────────────────────
  Widget _buildBodyStatsRow() {
    final stats = [
      {'emoji': '📏', 'value': '${_height.toInt()}', 'unit': 'cm', 'label': 'Height'},
      {'emoji': '⚖️', 'value': '${_weight.toInt()}', 'unit': 'kg', 'label': 'Weight'},
      {'emoji': '🎯', 'value': '${_goalWeight.toInt()}', 'unit': 'kg', 'label': 'Goal'},
    ];

    return Row(
      children: stats.map((s) => Expanded(
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _border),
          ),
          child: Column(children: [
            Text(s['emoji']!, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 6),
            RichText(text: TextSpan(
              children: [
                TextSpan(text: s['value'],
                  style: GoogleFonts.inter(
                    fontSize: 18, fontWeight: FontWeight.w800,
                    color: _textPrim,
                  ),
                ),
                TextSpan(text: ' ${s['unit']}',
                  style: GoogleFonts.inter(
                    fontSize: 10, color: _textMuted,
                  ),
                ),
              ],
            )),
            const SizedBox(height: 2),
            Text(s['label']!,
              style: GoogleFonts.inter(
                fontSize: 9, color: _textMuted,
              ),
            ),
          ]),
        ),
      )).toList(),
    );
  }

  // ── Weight Graph ────────────────────────────────────────────
  Widget _buildWeightGraph() {
    final maxW = _weightHistory
        .map((e) => e['weight'] as double)
        .reduce((a, b) => a > b ? a : b);
    final minW = _weightHistory
        .map((e) => e['weight'] as double)
        .reduce((a, b) => a < b ? a : b);
    final range = maxW - minW + 4;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Last 6 Months',
                style: GoogleFonts.inter(
                  fontSize: 13, fontWeight: FontWeight.w700,
                  color: _textPrim,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.purple.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('Weight (kg)',
                  style: GoogleFonts.inter(
                    fontSize: 10, fontWeight: FontWeight.w600,
                    color: AppColors.purple,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Graph
          SizedBox(
            height: 100,
            child: CustomPaint(
              size: const Size(double.infinity, 100),
              painter: _WeightGraphPainter(
                data: _weightHistory
                    .map((e) => e['weight'] as double)
                    .toList(),
                minVal: minW - 2,
                maxVal: maxW + 2,
                lineColor: AppColors.purple,
                fillColor: AppColors.purple.withOpacity(
                  _isDark ? 0.2 : 0.1,
                ),
                dotColor: AppColors.purple,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Month labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _weightHistory.map((e) => Text(
              e['month'] as String,
              style: GoogleFonts.inter(
                fontSize: 9, color: _textMuted,
              ),
            )).toList(),
          ),

          const SizedBox(height: 12),

          // Summary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _graphStat('Start', '74 kg', _textMuted),
              _graphStat('Lost', '↓ 6 kg', const Color(0xFF10B981)),
              _graphStat('Current', '68 kg', AppColors.purple),
              _graphStat('Goal', '65 kg', const Color(0xFFF59E0B)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _graphStat(String label, String value, Color color) {
    return Column(children: [
      Text(value,
        style: GoogleFonts.inter(
          fontSize: 13, fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
      Text(label,
        style: GoogleFonts.inter(fontSize: 9, color: _textMuted),
      ),
    ]);
  }

  // ── Workout Card ────────────────────────────────────────────
  Widget _buildWorkoutCard() {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final dayStatus = ['done', 'done', 'done', 'today', 'rest', 'rest', 'rest'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
      ),
      child: Column(children: [
        // Day chips
        Row(
          children: List.generate(7, (i) {
            final status = dayStatus[i];
            Color bg, fg;
            if (status == 'today') {
              bg = AppColors.purple; fg = Colors.white;
            } else if (status == 'done') {
              bg = _isDark
                  ? const Color(0xFF1E1040)
                  : const Color(0xFFEDE9FE);
              fg = AppColors.purple;
            } else {
              bg = _isDark
                  ? const Color(0xFF1A1A2E)
                  : const Color(0xFFF0EEF8);
              fg = _textMuted;
            }
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i < 6 ? 5 : 0),
                padding: const EdgeInsets.symmetric(vertical: 7),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(days[i],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 11, fontWeight: FontWeight.w700,
                    color: fg,
                  ),
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 14),

        // Workout items
        ..._workouts.asMap().entries.map((e) {
          final w = e.value;
          final isLast = e.key == _workouts.length - 1;
          return Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: Color(w['color'] as int).withOpacity(
                      _isDark ? 0.2 : 0.12,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(w['icon'] as String,
                        style: const TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(w['name'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 13, fontWeight: FontWeight.w600,
                        color: _textPrim,
                      ),
                    ),
                    Text(w['detail'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 10, color: _textMuted,
                      ),
                    ),
                  ],
                )),
                Text(
                  (w['done'] as bool) ? '✅' : '⏳',
                  style: const TextStyle(fontSize: 18),
                ),
              ]),
            ),
            if (!isLast) Divider(height: 1, color: _border),
          ]);
        }),
      ]),
    );
  }

  // ── Section Title ───────────────────────────────────────────
  Widget _buildSectionTitle(String title) {
    return Text(title,
      style: GoogleFonts.inter(
        fontSize: 15, fontWeight: FontWeight.w700,
        color: _textPrim, letterSpacing: -0.2,
      ),
    );
  }

  // ── Bottom Nav ──────────────────────────────────────────────
  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.grid_view_rounded,       'label': 'Home'},
      {'icon': Icons.fitness_center_rounded,  'label': 'Workout'},
      {'icon': Icons.calendar_month_outlined, 'label': 'Schedule'},
      {'icon': Icons.person_outline_rounded,  'label': 'Profile'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: _surface,
        border: Border(top: BorderSide(color: _border)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.asMap().entries.map((e) {
          final active = _currentIndex == e.key;
          return GestureDetector(
            onTap: () => setState(() => _currentIndex = e.key),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(e.value['icon'] as IconData,
                color: active ? AppColors.purple : _textMuted,
                size: 22,
              ),
              const SizedBox(height: 4),
              active
                  ? Container(
                width: 4, height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.purple,
                  shape: BoxShape.circle,
                ),
              )
                  : Text(e.value['label'] as String,
                style: GoogleFonts.inter(
                  fontSize: 9, color: _textMuted,
                ),
              ),
            ]),
          );
        }).toList(),
      ),
    );
  }
}

// ── Custom Graph Painter ────────────────────────────────────
class _WeightGraphPainter extends CustomPainter {
  final List<double> data;
  final double minVal;
  final double maxVal;
  final Color lineColor;
  final Color fillColor;
  final Color dotColor;

  _WeightGraphPainter({
    required this.data,
    required this.minVal,
    required this.maxVal,
    required this.lineColor,
    required this.fillColor,
    required this.dotColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final range = maxVal - minVal;
    final points = <Offset>[];

    for (int i = 0; i < data.length; i++) {
      final x = i / (data.length - 1) * size.width;
      final y = size.height -
          ((data[i] - minVal) / range * size.height);
      points.add(Offset(x, y));
    }

    // Fill
    final fillPath = Path()..moveTo(points.first.dx, size.height);
    for (final p in points) fillPath.lineTo(p.dx, p.dy);
    fillPath
      ..lineTo(points.last.dx, size.height)
      ..close();

    canvas.drawPath(fillPath, Paint()..color = fillColor);

    // Line
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      final cp1 = Offset(
        (points[i - 1].dx + points[i].dx) / 2,
        points[i - 1].dy,
      );
      final cp2 = Offset(
        (points[i - 1].dx + points[i].dx) / 2,
        points[i].dy,
      );
      linePath.cubicTo(
        cp1.dx, cp1.dy, cp2.dx, cp2.dy,
        points[i].dx, points[i].dy,
      );
    }
    canvas.drawPath(linePath, linePaint);

    // Dots
    for (final p in points) {
      canvas.drawCircle(p, 3.5,
          Paint()..color = dotColor..style = PaintingStyle.fill);
      canvas.drawCircle(p, 3.5,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5);
    }
  }

  @override
  bool shouldRepaint(_) => true;
}