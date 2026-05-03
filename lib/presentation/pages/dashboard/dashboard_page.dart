import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/di/injection.dart';
import '../../../core/storage/token_storage.dart';
import '../../../core/theme/app_colors.dart';
import '../../blocs/theme/theme_cubit.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
  String _username = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final name = await sl<TokenStorage>().getUsername();
    if (mounted) setState(() => _username = name ?? 'Manager');
  }

  bool get _isDark =>
      context.read<ThemeCubit>().state == ThemeMode.dark;

  Color get _bg        => _isDark ? AppColors.darkBg        : AppColors.lightBg;
  Color get _surface   => _isDark ? AppColors.darkSurface    : AppColors.lightSurface;
  Color get _surfaceAlt=> _isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt;
  Color get _border    => _isDark ? AppColors.darkBorder     : AppColors.lightBorder;
  Color get _textPrim  => _isDark ? AppColors.darkTextPrim   : AppColors.lightTextPrim;
  Color get _textMuted => _isDark ? AppColors.darkTextMuted  : AppColors.lightTextMuted;

  // ── Stats data ──────────────────────────────────────────────
  final _stats = [
    {'icon': Icons.people_outline_rounded, 'color': 0xFF7B2FBE,
      'value': '248', 'label': 'Total Members', 'trend': '↑ 8 this week', 'up': true},
    {'icon': Icons.access_time_rounded, 'color': 0xFF10B981,
      'value': '34',  'label': "Today's Check-ins", 'trend': '↑ 6 vs yesterday', 'up': true},
    {'icon': Icons.payment_rounded, 'color': 0xFFF59E0B,
      'value': '12',  'label': 'Due Payments', 'trend': '↓ Need attention', 'up': false},
    {'icon': Icons.fitness_center_rounded, 'color': 0xFF3B82F6,
      'value': '6',   'label': 'Active Trainers', 'trend': '↑ All on duty', 'up': true},
  ];

  final _members = [
    {'name': 'Rakibul Islam',  'plan': 'Premium · 3 months', 'status': 'Active',  'color': 0xFF7B2FBE, 'initials': 'RK'},
    {'name': 'Sadia Hossain',  'plan': 'Basic · 1 month',    'status': 'Due',     'color': 0xFF10B981, 'initials': 'SH'},
    {'name': 'Mehedi Rahman',  'plan': 'Premium · 6 months', 'status': 'Expired', 'color': 0xFFF59E0B, 'initials': 'MR'},
  ];

  final _quickActions = [
    {'icon': Icons.person_add_outlined,    'label': 'Add Member', 'color': 0xFF7B2FBE},
    {'icon': Icons.how_to_reg_outlined,    'label': 'Attendance', 'color': 0xFF10B981},
    {'icon': Icons.account_balance_wallet_outlined, 'label': 'Payments', 'color': 0xFFF59E0B},
    {'icon': Icons.sports_outlined,        'label': 'Trainers',   'color': 0xFF3B82F6},
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ThemeCubit, ThemeMode>(
      listener: (_, __) => setState(() {}),
      builder: (context, _) => Scaffold(
        backgroundColor: _bg,
        body: SafeArea(
          child: Column(
            children: [
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
                      _buildRevenueCard(),
                      const SizedBox(height: 16),
                      _buildStatsGrid(),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Quick Actions'),
                      const SizedBox(height: 10),
                      _buildQuickActions(),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Recent Members'),
                      const SizedBox(height: 10),
                      _buildMemberList(),
                    ],
                  ),
                ),
              ),
              _buildBottomNav(),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Good morning 👋',
            style: GoogleFonts.inter(
              fontSize: 12, color: _textMuted, fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(_username.isEmpty ? 'Manager' : _username,
            style: GoogleFonts.inter(
              fontSize: 20, fontWeight: FontWeight.w800,
              color: _textPrim, letterSpacing: -0.4,
            ),
          ),
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
                    _isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    color: Colors.white, size: 11,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Notification bell
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: _border),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
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
              ],
            ),
          ),
        ]),
      ],
    );
  }

  // ── Revenue Card ───────────────────────────────────────────
  Widget _buildRevenueCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2D1060), Color(0xFF7B2FBE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.purple.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('MONTHLY REVENUE',
                style: GoogleFonts.inter(
                  fontSize: 9, fontWeight: FontWeight.w600,
                  color: Colors.white60, letterSpacing: 0.08,
                ),
              ),
              const SizedBox(height: 6),
              Text('৳ 1,24,500',
                style: GoogleFonts.inter(
                  fontSize: 30, fontWeight: FontWeight.w800,
                  color: Colors.white, letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text('October 2025',
                style: GoogleFonts.inter(
                  fontSize: 12, color: Colors.white54,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('↑ 12.4% vs last month',
                  style: GoogleFonts.inter(
                    fontSize: 9, fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          // Mini chart
          Positioned(
            right: 0, bottom: 0,
            child: Opacity(
              opacity: 0.2,
              child: CustomPaint(
                size: const Size(90, 60),
                painter: _ChartPainter(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats Grid ─────────────────────────────────────────────
  Widget _buildStatsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.6,
      ),
      itemCount: _stats.length,
      itemBuilder: (_, i) {
        final s = _stats[i];
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: Color(s['color'] as int).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(s['icon'] as IconData,
                    color: Color(s['color'] as int), size: 17),
              ),
              const Spacer(),
              Text(s['value'] as String,
                style: GoogleFonts.inter(
                  fontSize: 20, fontWeight: FontWeight.w800,
                  color: _textPrim, letterSpacing: -0.3,
                ),
              ),
              Text(s['label'] as String,
                style: GoogleFonts.inter(
                  fontSize: 10, color: _textMuted,
                ),
                maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(s['trend'] as String,
                style: GoogleFonts.inter(
                  fontSize: 9, fontWeight: FontWeight.w600,
                  color: (s['up'] as bool)
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Quick Actions ──────────────────────────────────────────
  Widget _buildQuickActions() {
    return Row(
      children: _quickActions.map((a) {
        return Expanded(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _border),
              ),
              child: Column(
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: Color(a['color'] as int).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(a['icon'] as IconData,
                        color: Color(a['color'] as int), size: 18),
                  ),
                  const SizedBox(height: 6),
                  Text(a['label'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 9, fontWeight: FontWeight.w600,
                      color: _textMuted,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Member List ────────────────────────────────────────────
  Widget _buildMemberList() {
    return Column(
      children: _members.map((m) {
        final status = m['status'] as String;
        final statusColor = status == 'Active'
            ? const Color(0xFF10B981)
            : status == 'Due'
            ? const Color(0xFFF59E0B)
            : const Color(0xFFEF4444);
        final statusBg = status == 'Active'
            ? const Color(0xFF0D3D28)
            : status == 'Due'
            ? const Color(0xFF3D1A00)
            : const Color(0xFF3D0A0A);

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _border),
          ),
          child: Row(
            children: [
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  color: Color(m['color'] as int),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Center(
                  child: Text(m['initials'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 12, fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m['name'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 13, fontWeight: FontWeight.w600,
                        color: _textPrim,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(m['plan'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 11, color: _textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(status,
                  style: GoogleFonts.inter(
                    fontSize: 10, fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ── Section Title ──────────────────────────────────────────
  Widget _buildSectionTitle(String title) {
    return Text(title,
      style: GoogleFonts.inter(
        fontSize: 15, fontWeight: FontWeight.w700,
        color: _textPrim, letterSpacing: -0.2,
      ),
    );
  }

  // ── Bottom Nav ─────────────────────────────────────────────
  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.grid_view_rounded,      'label': 'Dashboard'},
      {'icon': Icons.people_outline_rounded, 'label': 'Members'},
      {'icon': Icons.calendar_month_outlined,'label': 'Schedule'},
      {'icon': Icons.person_outline_rounded, 'label': 'Profile'},
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
              onTap: () {
                setState(() => _currentIndex = e.key);

                if (e.key == 3) {
                  context.push('/profile'); // Profile tab click
                }
              },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(e.value['icon'] as IconData,
                  color: active ? AppColors.purple : _textMuted,
                  size: 22,
                ),
                const SizedBox(height: 4),
                if (active)
                  Container(
                    width: 4, height: 4,
                    decoration: const BoxDecoration(
                      color: AppColors.purple,
                      shape: BoxShape.circle,
                    ),
                  )
                else
                  Text(e.value['label'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 9, color: _textMuted,
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Mini Chart Painter ─────────────────────────────────────
class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(0, size.height * 0.85)
      ..lineTo(size.width * 0.2, size.height * 0.65)
      ..lineTo(size.width * 0.4, size.height * 0.75)
      ..lineTo(size.width * 0.6, size.height * 0.35)
      ..lineTo(size.width * 0.8, size.height * 0.5)
      ..lineTo(size.width, size.height * 0.1);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}