import 'package:flutter/material.dart';

/// A custom calendar screen that lets the user pick a start and end date.
/// Returns a [DateTimeRange] via Navigator.pop when confirmed.
class SelectDateScreen extends StatefulWidget {
  final DateTime? initialStart;
  final DateTime? initialEnd;

  const SelectDateScreen({
    super.key,
    this.initialStart,
    this.initialEnd,
  });

  @override
  State<SelectDateScreen> createState() => _SelectDateScreenState();
}

class _SelectDateScreenState extends State<SelectDateScreen> {
  late DateTime _viewMonth; // month currently shown in calendar
  DateTime? _startDate;
  DateTime? _endDate;

  static const Color _primary = Color(0xFF2563EB);
  static const _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  static const _shortMonthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  static const _dayLabels = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = widget.initialStart ?? now;
    _endDate = widget.initialEnd ?? now;
    _viewMonth = DateTime(_startDate!.year, _startDate!.month);
  }

  String _formatShort(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')} ${_shortMonthNames[dt.month - 1]} ${dt.year}';

  String _formatDisplay(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')} ${_shortMonthNames[dt.month - 1]}';

  int get _dayCount {
    if (_startDate == null || _endDate == null) return 1;
    final diff = _endDate!.difference(_startDate!).inDays;
    return diff < 0 ? 1 : diff + 1;
  }

  void _onDayTap(DateTime day) {
    setState(() {
      if (_startDate == null || (_startDate != null && _endDate != null)) {
        // Start fresh
        _startDate = day;
        _endDate = day;
      } else if (day.isBefore(_startDate!)) {
        _startDate = day;
      } else {
        _endDate = day;
      }
    });
  }

  List<DateTime?> _buildCalendarDays() {
    final firstOfMonth = DateTime(_viewMonth.year, _viewMonth.month, 1);
    // weekday: Mon=1, ... Sun=7. We want Mon as first column.
    final leadingBlanks = (firstOfMonth.weekday - 1) % 7;

    final daysInMonth = DateUtils.getDaysInMonth(_viewMonth.year, _viewMonth.month);
    final lastOfMonth = DateTime(_viewMonth.year, _viewMonth.month, daysInMonth);
    final trailingBlanks = (7 - lastOfMonth.weekday) % 7;

    final result = <DateTime?>[];
    for (int i = 0; i < leadingBlanks; i++) {
      final prev = firstOfMonth.subtract(Duration(days: leadingBlanks - i));
      result.add(prev);
    }
    for (int d = 1; d <= daysInMonth; d++) {
      result.add(DateTime(_viewMonth.year, _viewMonth.month, d));
    }
    for (int i = 1; i <= trailingBlanks; i++) {
      result.add(DateTime(_viewMonth.year, _viewMonth.month + 1, i));
    }
    // Pad to multiple of 7
    while (result.length % 7 != 0) {
      final last = result.last!;
      result.add(last.add(const Duration(days: 1)));
    }
    return result;
  }

  bool _isInMonth(DateTime? d) =>
      d != null && d.month == _viewMonth.month && d.year == _viewMonth.year;

  bool _isSelected(DateTime d) =>
      (_startDate != null && DateUtils.isSameDay(d, _startDate)) ||
      (_endDate != null && DateUtils.isSameDay(d, _endDate));

  bool _isInRange(DateTime d) {
    if (_startDate == null || _endDate == null) return false;
    return d.isAfter(_startDate!) && d.isBefore(_endDate!);
  }

  @override
  Widget build(BuildContext context) {
    final days = _buildCalendarDays();
    final dayCount = _dayCount;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF64748B), size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Select Date',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFE2E8F0)),
        ),
      ),
      body: Column(
        children: [
          // Date range header
          _buildDateRangeHeader(dayCount),
          // Calendar
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildCalendarCard(days),
                ],
              ),
            ),
          ),
          // Bottom confirm button
          _buildConfirmButton(),
        ],
      ),
    );
  }

  Widget _buildDateRangeHeader(int dayCount) {
    final startStr = _startDate != null ? _formatShort(_startDate!) : '--';
    final endStr = _endDate != null ? _formatShort(_endDate!) : '--';

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'START DATE',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF94A3B8),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        startStr,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: _primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(width: 1, color: const Color(0xFFE2E8F0)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Center(
                child: Text(
                  '$dayCount ${dayCount == 1 ? 'Day' : 'Days'}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF475569),
                  ),
                ),
              ),
            ),
            Container(width: 1, color: const Color(0xFFE2E8F0)),
            Expanded(
              child: GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'END DATE',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF94A3B8),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        endStr,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: _primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarCard(List<DateTime?> days) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Month/Year header with navigation
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => setState(() {
                    _viewMonth = DateTime(_viewMonth.year, _viewMonth.month - 1);
                  }),
                  child: const Icon(Icons.chevron_left, color: Color(0xFF64748B)),
                ),
                Text(
                  '${_monthNames[_viewMonth.month - 1]} ${_viewMonth.year}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    _viewMonth = DateTime(_viewMonth.year, _viewMonth.month + 1);
                  }),
                  child: const Icon(Icons.chevron_right, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          // Day labels
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: _dayLabels.map((label) => Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF94A3B8),
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 8),
          // Day grid
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.0,
              ),
              itemCount: days.length,
              itemBuilder: (context, i) {
                final day = days[i];
                if (day == null) return const SizedBox.shrink();

                final inMonth = _isInMonth(day);
                final isSelected = inMonth && _isSelected(day);
                final inRange = inMonth && _isInRange(day);

                return GestureDetector(
                  onTap: inMonth ? () => _onDayTap(day) : null,
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? _primary
                          : inRange
                              ? const Color(0xFFDBEAFE)
                              : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                          color: isSelected
                              ? Colors.white
                              : inRange
                                  ? _primary
                                  : inMonth
                                      ? const Color(0xFF1E293B)
                                      : const Color(0xFFCBD5E1),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    final display = _startDate != null ? _formatDisplay(_startDate!) : '--';
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            if (_startDate != null && _endDate != null) {
              Navigator.pop(
                context,
                DateTimeRange(start: _startDate!, end: _endDate!),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: RichText(
            text: TextSpan(
              text: 'Selected date: ',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              children: [
                TextSpan(
                  text: display,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
