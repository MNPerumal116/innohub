import 'package:flutter/material.dart';

/// A custom calendar screen that lets the user pick a start and end date.
/// Returns a [DateTimeRange] via Navigator.pop when confirmed.
///
/// Selection flow:
///  1. First tap  → sets START date; enters "picking end" mode
///  2. Second tap → if date >= start, sets END date; if date < start, resets start
///  3. When both dates are set, any tap resets to a fresh start
class SelectDateScreen extends StatefulWidget {
  final DateTime? initialStart;
  final DateTime? initialEnd;

  const SelectDateScreen({super.key, this.initialStart, this.initialEnd});

  @override
  State<SelectDateScreen> createState() => _SelectDateScreenState();
}

class _SelectDateScreenState extends State<SelectDateScreen> {
  late DateTime _viewMonth;
  DateTime? _startDate;
  DateTime? _endDate;

  /// true  = start chosen, waiting for user to pick end date
  /// false = nothing chosen yet, OR both dates already chosen
  bool _pickingEnd = false;

  static const Color _primary = Color(0xFF2563EB);
  static const Color _rangeColor = Color(0xFFDBEAFE);

  static const _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  static const _shortMonthNames = [
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
  static const _dayLabels = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    if (widget.initialStart != null && widget.initialEnd != null) {
      _startDate = _stripTime(widget.initialStart!);
      _endDate = _stripTime(widget.initialEnd!);
      _pickingEnd = false;
    }
    _viewMonth = DateTime((_startDate ?? now).year, (_startDate ?? now).month);
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  DateTime _stripTime(DateTime d) => DateTime(d.year, d.month, d.day);

  String _formatShort(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')} ${_shortMonthNames[dt.month - 1]} ${dt.year}';

  String _formatDisplay(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')} ${_shortMonthNames[dt.month - 1]}';

  int get _dayCount {
    if (_startDate == null || _endDate == null) return 0;
    return _endDate!.difference(_startDate!).inDays + 1;
  }

  void _onDayTap(DateTime day) {
    day = _stripTime(day);
    setState(() {
      if (!_pickingEnd) {
        // Phase 1: set start date, enter "picking end" mode
        _startDate = day;
        _endDate = null;
        _pickingEnd = true;
      } else {
        // Phase 2: picking end date
        if (day.isBefore(_startDate!)) {
          // Tapped before start → treat as new start
          _startDate = day;

          _endDate = null;
          // _pickingEnd stays true
        } else {
          // Valid end date (same day or later)
          _endDate = day;
          _pickingEnd = false;
        }
      }
    });
  }

  List<DateTime?> _buildCalendarDays() {
    final firstOfMonth = DateTime(_viewMonth.year, _viewMonth.month, 1);
    final leadingBlanks = (firstOfMonth.weekday - 1) % 7;
    final daysInMonth = DateUtils.getDaysInMonth(
      _viewMonth.year,
      _viewMonth.month,
    );
    final lastOfMonth = DateTime(
      _viewMonth.year,
      _viewMonth.month,
      daysInMonth,
    );
    final trailingBlanks = (7 - lastOfMonth.weekday) % 7;

    final result = <DateTime?>[];
    for (int i = 0; i < leadingBlanks; i++) {
      result.add(firstOfMonth.subtract(Duration(days: leadingBlanks - i)));
    }
    for (int d = 1; d <= daysInMonth; d++) {
      result.add(DateTime(_viewMonth.year, _viewMonth.month, d));
    }
    for (int i = 1; i <= trailingBlanks; i++) {
      result.add(DateTime(_viewMonth.year, _viewMonth.month + 1, i));
    }
    while (result.length % 7 != 0) {
      final last = result.last!;
      result.add(last.add(const Duration(days: 1)));
    }
    return result;
  }

  bool _isInMonth(DateTime? d) =>
      d != null && d.month == _viewMonth.month && d.year == _viewMonth.year;

  bool _isStart(DateTime d) =>
      _startDate != null && DateUtils.isSameDay(d, _startDate);

  /// True only when end date is confirmed (not hover)
  bool _isEffectiveEnd(DateTime d) =>
      _endDate != null && DateUtils.isSameDay(d, _endDate);

  /// Strictly between start and CONFIRMED end only
  bool _isInRange(DateTime d) {
    if (_startDate == null || _endDate == null) return false;
    return d.isAfter(_startDate!) && d.isBefore(_endDate!);
  }

  @override
  Widget build(BuildContext context) {
    final days = _buildCalendarDays();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
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
          _buildDateRangeHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildCalendarCard(days),
            ),
          ),
          _buildConfirmButton(),
        ],
      ),
    );
  }

  Widget _buildDateRangeHeader() {
    final startStr = _startDate != null ? _formatShort(_startDate!) : '--';
    final endStr = _endDate != null ? _formatShort(_endDate!) : '--';
    final dayCount = _dayCount;
    final dayLabel = dayCount == 0
        ? '-- Days'
        : '$dayCount ${dayCount == 1 ? 'Day' : 'Days'}';

    // Active label color = blue for whichever side is currently being picked
    final Color startLabelColor = (_startDate == null || _pickingEnd)
        ? _primary
        : const Color(0xFF94A3B8);
    final Color endLabelColor = (_pickingEnd && _endDate == null)
        ? _primary
        : const Color(0xFF94A3B8);

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
            // START DATE
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'START DATE',
                      style: TextStyle(
                        fontSize: 10,
                        color: startLabelColor,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      startStr,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: _startDate != null
                            ? _primary
                            : const Color(0xFFCBD5E1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(width: 1, color: const Color(0xFFE2E8F0)),
            // DAY COUNT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Center(
                child: Text(
                  dayLabel,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF475569),
                  ),
                ),
              ),
            ),
            Container(width: 1, color: const Color(0xFFE2E8F0)),
            // END DATE
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'END DATE',
                      style: TextStyle(
                        fontSize: 10,
                        color: endLabelColor,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      endStr,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: _endDate != null
                            ? _primary
                            : const Color(0xFFCBD5E1),
                      ),
                    ),
                  ],
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
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Month / year navigation
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => setState(() {
                    _viewMonth = DateTime(
                      _viewMonth.year,
                      _viewMonth.month - 1,
                    );
                  }),
                  child: const Icon(
                    Icons.chevron_left,
                    color: Color(0xFF64748B),
                  ),
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
                    _viewMonth = DateTime(
                      _viewMonth.year,
                      _viewMonth.month + 1,
                    );
                  }),
                  child: const Icon(
                    Icons.chevron_right,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          // Weekday labels
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: _dayLabels
                  .map(
                    (label) => Expanded(
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
                    ),
                  )
                  .toList(),
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

                if (!inMonth) {
                  return Center(
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFCBD5E1),
                      ),
                    ),
                  );
                }

                final isStart = _isStart(day);
                final isEnd = _isEffectiveEnd(day);
                final inRange = _isInRange(day);
                final isSelected = isStart || isEnd;

                // Only highlight when end date is confirmed
                final bool hasRange = _startDate != null && _endDate != null;

                // Half-strip sides
                final bool leftStrip = hasRange && (inRange || isEnd);
                final bool rightStrip = hasRange && (inRange || isStart);

                // Pill caps: round the left end on isStart, right end on isEnd
                const double capR = 20.0;

                return GestureDetector(
                  onTap: () => _onDayTap(day),
                  child: Stack(
                    children: [
                      // Range background — full cell but with rounded pill caps
                      if (leftStrip || rightStrip)
                        Positioned.fill(
                          child: Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                      isStart ? capR : 0,
                                    ),
                                    bottomLeft: Radius.circular(
                                      isStart ? capR : 0,
                                    ),
                                  ),
                                  child: Container(
                                    color: leftStrip
                                        ? _rangeColor
                                        : Colors.transparent,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(isEnd ? capR : 0),
                                    bottomRight: Radius.circular(
                                      isEnd ? capR : 0,
                                    ),
                                  ),
                                  child: Container(
                                    color: rightStrip
                                        ? _rangeColor
                                        : Colors.transparent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      // Circle dot for start / end
                      Center(
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: isSelected ? _primary : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w400,
                                color: isSelected
                                    ? Colors.white
                                    : inRange
                                    ? _primary
                                    : const Color(0xFF1E293B),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
    final bool canConfirm = _startDate != null && _endDate != null;

    final String buttonLabel;
    if (_startDate == null) {
      buttonLabel = 'Select a start date';
    } else if (_endDate == null) {
      buttonLabel = 'Now select an end date';
    } else {
      final startDisp = _formatDisplay(_startDate!);
      final endDisp = _formatDisplay(_endDate!);
      final days = _dayCount;
      final same = DateUtils.isSameDay(_startDate, _endDate);
      buttonLabel = same
          ? 'Selected date: $startDisp'
          : 'Selected: $startDisp \u2013 $endDisp  ($days days)';
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: canConfirm
              ? () {
                  Navigator.pop(
                    context,
                    DateTimeRange(start: _startDate!, end: _endDate!),
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: canConfirm ? _primary : const Color(0xFFCBD5E1),
            foregroundColor: Colors.white,
            disabledBackgroundColor: const Color(0xFFCBD5E1),
            disabledForegroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Text(
            buttonLabel,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
