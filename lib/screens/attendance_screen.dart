import 'package:flutter/material.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String _selectedPeriod = 'Last 30 Days';

  static const Color _primary = Color(0xFF2563EB);
  static const Color _bg = Color(0xFFF3F5F9);

  final List<_AttendanceEntry> _entries = const [
    _AttendanceEntry(
      date: 'Wednesday, 8 Jul 2026',
      type: 'Remote Clock In',
      shift: '09:00 AM - 06:30 PM',
      shiftNote: '(Default w...)',
      clockIn: null,
      clockOut: null,
      effectiveTime: null,
      grossTime: null,
      status: _EntryStatus.processing,
      noEntries: true,
      pendingBanner: true,
    ),
    _AttendanceEntry(
      date: 'Tuesday, 7 Jul 2026',
      type: 'Office Presence',
      shift: '09:00 AM - 06:30 PM',
      shiftNote: '(Default w...)',
      clockIn: '09 : 18 AM',
      clockOut: '06 : 39 PM',
      effectiveTime: '9h 21m',
      grossTime: '9h 21m',
      lateBy: '0:18:51',
      status: _EntryStatus.late,
    ),
    _AttendanceEntry(
      date: 'Monday, 6 Jul 2026',
      type: 'Office Presence',
      shift: '09:00 AM - 06:30 PM',
      shiftNote: '(Default w...)',
      clockIn: '09 : 38 AM',
      clockOut: '06 : 57 PM',
      effectiveTime: '9h 19m',
      grossTime: '9h 19m',
      lateBy: '0:38:44',
      status: _EntryStatus.late,
    ),
    _AttendanceEntry(
      date: 'Sunday, 21 Jun 2026',
      type: '',
      shift: '',
      shiftNote: '',
      clockIn: null,
      clockOut: null,
      effectiveTime: null,
      grossTime: null,
      status: _EntryStatus.weekOff,
    ),
    _AttendanceEntry(
      date: 'Saturday, 20 Jun 2026',
      type: '',
      shift: '',
      shiftNote: '',
      clockIn: null,
      clockOut: null,
      effectiveTime: null,
      grossTime: null,
      status: _EntryStatus.weekOff,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dayOfWeek = dayNames[now.weekday - 1];
    final dateStr = '$dayOfWeek, ${now.day} ${monthNames[now.month - 1]} ${now.year}';

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  // Header
                  const Text(
                    'Attendance',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(dateStr, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                  const Text(
                    'Today\'s Schedule',
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 12),
                  // Pending banner
                  _buildPendingBanner(),
                  const SizedBox(height: 12),
                  // Today's shift card
                  _buildTodayShiftCard(),
                  const SizedBox(height: 20),
                  // Last 30 days header
                  _buildPeriodHeader(),
                  const SizedBox(height: 12),
                  // Entries
                  ..._entries.map((e) => _buildEntryCard(e)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFFFCA5A5),
            child: Text(
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

  Widget _buildPendingBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time_rounded, color: _primary, size: 18),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Remote Clock In request Pending',
              style: TextStyle(fontSize: 13, color: Color(0xFF1E293B), fontWeight: FontWeight.w500),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'View Request',
              style: TextStyle(
                fontSize: 13,
                color: _primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayShiftCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Work Shift',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '09:00 AM - 06:30 PM',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const Text(
            '(Default work shift)',
            style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CLOCK IN',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '-- : --',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'CLOCK OUT',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '-- : --',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                'Effective:  ',
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
              const Text(
                '0h 0m',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
              ),
              const Spacer(),
              const Text(
                'Gross:  ',
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
              const Text(
                '0h 0m',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodHeader() {
    final now = DateTime.now();
    final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final endStr = '${monthNames[now.month - 1]} ${now.day}';
    final start = now.subtract(const Duration(days: 30));
    final startStr = '${monthNames[start.month - 1]} ${start.day}';

    return Row(
      children: [
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (ctx) => Column(
                mainAxisSize: MainAxisSize.min,
                children: ['Last 30 Days', 'Last 60 Days', 'Last 90 Days'].map((p) => ListTile(
                  title: Text(p),
                  onTap: () {
                    setState(() => _selectedPeriod = p);
                    Navigator.pop(ctx);
                  },
                )).toList(),
              ),
            );
          },
          child: Row(
            children: [
              Text(
                _selectedPeriod,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down, size: 18, color: Color(0xFF64748B)),
            ],
          ),
        ),
        const Spacer(),
        Text(
          '($startStr - $endStr)',
          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  Widget _buildEntryCard(_AttendanceEntry entry) {
    if (entry.status == _EntryStatus.weekOff) {
      return _buildWeekOffCard(entry);
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date + status badge
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.date,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                    _buildStatusBadge(entry.status, entry.lateBy),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  entry.type,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 8),
                // Shift time
                Row(
                  children: [
                    Text(
                      entry.shift,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      entry.shiftNote,
                      style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (entry.noEntries == true) ...[
                  const Text(
                    'No entries logged',
                    style: TextStyle(fontSize: 12, color: Color(0xFFEF4444), fontWeight: FontWeight.w500),
                  ),
                ] else if (entry.clockIn != null) ...[
                  Row(
                    children: [
                      // Clock In
                      Row(
                        children: [
                          const Icon(Icons.south_west, color: Color(0xFF22C55E), size: 14),
                          const SizedBox(width: 4),
                          Text(
                            entry.clockIn!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF22C55E),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Clock Out
                      Row(
                        children: [
                          const Icon(Icons.north_east, color: Color(0xFF475569), size: 14),
                          const SizedBox(width: 4),
                          Text(
                            entry.clockOut ?? '--:--',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF475569),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 1, color: Color(0xFFE2E8F0)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('Effective:', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                      const SizedBox(width: 4),
                      Text(
                        entry.effectiveTime ?? '0h 0m',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                      ),
                      const Spacer(),
                      const Text('Gross:', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                      const SizedBox(width: 4),
                      Text(
                        entry.grossTime ?? '0h 0m',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                      ),
                    ],
                  ),
                ],
                if (entry.pendingBanner == true) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, size: 14, color: Color(0xFF64748B)),
                        const SizedBox(width: 6),
                        const Text(
                          'Remote clock in request is under approval',
                          style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekOffCard(_AttendanceEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              entry.date,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'WEEK OFF',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF2563EB),
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(_EntryStatus status, String? lateBy) {
    switch (status) {
      case _EntryStatus.processing:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.info_outline, size: 12, color: Color(0xFF64748B)),
              SizedBox(width: 4),
              Text(
                'Processing',
                style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
              ),
            ],
          ),
        );
      case _EntryStatus.late:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF2F2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '${lateBy ?? ''} LATE',
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFFDC2626),
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        );
      case _EntryStatus.weekOff:
        return const SizedBox.shrink();
    }
  }
}

enum _EntryStatus { processing, late, weekOff }

class _AttendanceEntry {
  final String date;
  final String type;
  final String shift;
  final String shiftNote;
  final String? clockIn;
  final String? clockOut;
  final String? effectiveTime;
  final String? grossTime;
  final String? lateBy;
  final _EntryStatus status;
  final bool? noEntries;
  final bool? pendingBanner;

  const _AttendanceEntry({
    required this.date,
    required this.type,
    required this.shift,
    required this.shiftNote,
    required this.clockIn,
    required this.clockOut,
    required this.effectiveTime,
    required this.grossTime,
    required this.status,
    this.lateBy,
    this.noEntries,
    this.pendingBanner,
  });
}
