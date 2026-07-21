import 'dart:async';
import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isClockedIn = false;
  bool _isOnBreak = false;
  Duration _elapsed = Duration.zero;
  Duration _totalBreakDuration = Duration.zero;
  Timer? _timer;
  DateTime? _clockInTime;
  DateTime? _breakStartTime;

  static const Color _primary = Color(0xFF2563EB);
  static const Color _bg = Color(0xFFF3F5F9);

  Future<void> _handleClockIn() async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.selfieVerification,
    );
    if (result == true) {
      setState(() {
        _isClockedIn = true;
        _isOnBreak = false;
        _clockInTime = DateTime.now();
        _elapsed = Duration.zero;
        _totalBreakDuration = Duration.zero;
        _breakStartTime = null;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          _elapsed = DateTime.now().difference(_clockInTime!);
        });
      });
    }
  }

  void _handleClockOut() {
    _timer?.cancel();
    setState(() {
      _isClockedIn = false;
      _isOnBreak = false;
      _elapsed = Duration.zero;
      _totalBreakDuration = Duration.zero;
      _clockInTime = null;
      _breakStartTime = null;
    });
  }

  void _toggleBreak() {
    setState(() {
      if (_isOnBreak) {
        // Ending break (Break In)
        _isOnBreak = false;
        if (_breakStartTime != null) {
          _totalBreakDuration += DateTime.now().difference(_breakStartTime!);
          _breakStartTime = null;
        }
      } else {
        // Starting break (Break Out)
        _isOnBreak = true;
        _breakStartTime = DateTime.now();
      }
    });
  }

  Duration get _currentBreakDuration => _isOnBreak && _breakStartTime != null
      ? DateTime.now().difference(_breakStartTime!)
      : Duration.zero;

  Duration get _totalBreak => _totalBreakDuration + _currentBreakDuration;
  Duration get _effectiveHours => _elapsed - _totalBreak;

  String _formatElapsed(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final dayOfWeek = dayNames[now.weekday - 1];
    final dayStr =
        '${now.day.toString().padLeft(2, '0')} ${monthNames[now.month - 1]}';

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildQuickActions(context),
                    const SizedBox(height: 16),
                    _buildShiftCard(dayStr, dayOfWeek),
                    const SizedBox(height: 16),
                    _buildOffThisWeekCard(),
                    const SizedBox(height: 20),
                    const Text(
                      'Wish them',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildWishThemCard(),
                    const SizedBox(height: 16),
                    _buildUpcomingHolidaysCard(),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFFCA5A5),
            child: const Text(
              'SR',
              style: TextStyle(
                color: Color(0xFF991B1B),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  SizedBox(width: 14),
                  Text(
                    'Search your colleagues',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Icon(Icons.search, color: Colors.grey.shade500, size: 22),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      _QuickAction(
        icon: Icons.flight_takeoff_outlined,
        label: 'Apply\nLeave',
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.applyLeave);
        },
      ),
      _QuickAction(
        icon: Icons.home_work_outlined,
        label: 'Apply\nWFH',
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.wfhRequest);
        },
      ),
      // _QuickAction(icon: Icons.receipt_long_outlined, label: 'View\nPayslip', onTap: () {
      //   Navigator.pushNamed(context, AppRoutes.payslips);
      // }),
      _QuickAction(
        icon: Icons.assignment_outlined,
        label: 'Leave\nBalance',
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.leave);
        },
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: actions.map((a) => _buildActionItem(a)).toList(),
      ),
    );
  }

  Widget _buildActionItem(_QuickAction action) {
    return GestureDetector(
      onTap: action.onTap,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              shape: BoxShape.circle,
            ),
            child: Icon(action.icon, color: const Color(0xFF2563EB), size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            action.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF475569),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShiftCard(String dayStr, String dayOfWeek) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shift header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: const Row(
              children: [
                Text(
                  'SHIFT TODAY : GENERAL (9:00 AM - 6:30 PM)',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _isClockedIn
                            ? const Color(0xFFEF4444)
                            : const Color(0xFF22C55E),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.open_in_new,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dayStr,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          dayOfWeek,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      _isClockedIn
                          ? '${_effectiveHours.inHours}h ${_effectiveHours.inMinutes.remainder(60)}m / 8h 25m'
                          : '0h / 8h 25m',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (!_isClockedIn)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleClockIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Clock In',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                else
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildSplitStat('Gross', _formatElapsed(_elapsed)),
                            Container(
                              width: 1,
                              height: 30,
                              color: const Color(0xFFCBD5E1),
                            ),
                            _buildSplitStat(
                              'Break',
                              _formatElapsed(_totalBreak),
                              isWarning: _isOnBreak,
                            ),
                            Container(
                              width: 1,
                              height: 30,
                              color: const Color(0xFFCBD5E1),
                            ),
                            _buildSplitStat(
                              'Effective',
                              _formatElapsed(_effectiveHours),
                              isPrimary: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isOnBreak ? null : _handleClockOut,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFEF4444),
                                disabledBackgroundColor: const Color(
                                  0xFFEF4444,
                                ).withOpacity(0.5),
                                foregroundColor: Colors.white,
                                disabledForegroundColor: Colors.white
                                    .withOpacity(0.7),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Clock Out',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _toggleBreak,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isOnBreak
                                    ? const Color(0xFFEAB308)
                                    : const Color(0xFF3B82F6),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                _isOnBreak ? 'Break In' : 'Break Out',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSplitStat(
    String label,
    String value, {
    bool isPrimary = false,
    bool isWarning = false,
  }) {
    Color valColor = const Color(0xFF1E293B);
    if (isPrimary) valColor = const Color(0xFF2563EB);
    if (isWarning) valColor = const Color(0xFFEAB308);

    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  Widget _buildOffThisWeekCard() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.nightlight_round,
            color: Color(0xFF2563EB),
            size: 20,
          ),
        ),
        title: const Text(
          'Off this week',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF1E293B),
          ),
        ),
        subtitle: const Text(
          'See which of your coworkers are off this week',
          style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        ),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
        onTap: () {},
      ),
    );
  }

  Widget _buildWishThemCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(
            Icons.sentiment_satisfied_alt_outlined,
            size: 44,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            'No upcoming celebrations in next 7 days, till\nthen celebrate the small wins!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingHolidaysCard() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.auto_awesome,
            color: Color(0xFF2563EB),
            size: 20,
          ),
        ),
        title: const Text(
          'Upcoming holidays',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF1E293B),
          ),
        ),
        subtitle: const Text(
          'Find out what holidays are coming up',
          style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        ),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
        onTap: () {},
      ),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}
