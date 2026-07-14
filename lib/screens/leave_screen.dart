import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({super.key});

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTab = 0;

  static const Color _primary = Color(0xFF2563EB);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _currentTab = _tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String get _appBarTitle =>
      _currentTab == 0 ? 'Leave Balances' : 'Leave History';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 18, color: Color(0xFF64748B)),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          _appBarTitle,
          style: const TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Leave Balances'),
                  Tab(text: 'Leave History'),
                ],
                labelColor: _primary,
                unselectedLabelColor: const Color(0xFF94A3B8),
                labelStyle: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600),
                unselectedLabelStyle: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w400),
                indicatorColor: _primary,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 2.5,
                dividerColor: const Color(0xFFE2E8F0),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _LeaveBalancesTab(onApplyLeave: () {
            Navigator.pushNamed(context, AppRoutes.applyLeave);
          }),
          const _LeaveHistoryTab(),
        ],
      ),
    );
  }
}

// ─── Leave Balances Tab ───────────────────────────────────────────────────────

class _LeaveBalancesTab extends StatelessWidget {
  final VoidCallback onApplyLeave;
  const _LeaveBalancesTab({required this.onApplyLeave});

  static const _balances = [
    _LeaveBalance(
        name: 'Casual Leave', consumed: '4 Consumed', days: '1', unit: 'Days'),
    _LeaveBalance(
        name: 'Comp Offs', consumed: '0 Consumed', days: '0', unit: 'Days'),
    _LeaveBalance(
        name: 'Floater Leave',
        consumed: '0 Consumed',
        days: '1',
        unit: 'Day'),
    _LeaveBalance(
        name: 'Paid Leave', consumed: '0 Consumed', days: '8', unit: 'Days'),
    _LeaveBalance(
        name: 'Paternity Leave',
        consumed: '0 Consumed',
        days: '0',
        unit: 'Days'),
    _LeaveBalance(
        name: 'Unpaid Leave', consumed: '0 Consumed', days: '∞', unit: ''),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            itemCount: _balances.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
            itemBuilder: (context, i) {
              final b = _balances[i];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    // Leave type + consumed
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            b.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            b.consumed,
                            style: const TextStyle(
                                fontSize: 13, color: Color(0xFF94A3B8)),
                          ),
                        ],
                      ),
                    ),
                    // Days count
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: b.days,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          if (b.unit.isNotEmpty)
                            TextSpan(
                              text: ' ${b.unit}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF64748B),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.chevron_right,
                        color: Color(0xFF94A3B8), size: 20),
                  ],
                ),
              );
            },
          ),
        ),
        // Apply Leave button
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onApplyLeave,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Apply Leave',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LeaveBalance {
  final String name;
  final String consumed;
  final String days;
  final String unit;
  const _LeaveBalance({
    required this.name,
    required this.consumed,
    required this.days,
    required this.unit,
  });
}

// ─── Leave History Tab ────────────────────────────────────────────────────────

class _LeaveHistoryTab extends StatefulWidget {
  const _LeaveHistoryTab();

  @override
  State<_LeaveHistoryTab> createState() => _LeaveHistoryTabState();
}

class _LeaveHistoryTabState extends State<_LeaveHistoryTab> {
  String _selectedYear = '2026';

  static const _entries = [
    _LeaveHistoryEntry(
        date: '27 Mar 2026', detail: '1 day, Casual Leave', status: 'APPROVED'),
    _LeaveHistoryEntry(
        date: '12 Mar 2026', detail: '1 day, Casual Leave', status: 'APPROVED'),
    _LeaveHistoryEntry(
        date: '16 Feb 2026', detail: '1 day, Casual Leave', status: 'APPROVED'),
    _LeaveHistoryEntry(
        date: '19 Jan 2026', detail: '1 day, Casual Leave', status: 'APPROVED'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date range filter row
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (ctx) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: ['2026', '2025', '2024'].map((year) {
                    return ListTile(
                      title: Text(year),
                      trailing: year == _selectedYear
                          ? const Icon(Icons.check,
                              color: Color(0xFF2563EB), size: 18)
                          : null,
                      onTap: () {
                        setState(() => _selectedYear = year);
                        Navigator.pop(ctx);
                      },
                    );
                  }).toList(),
                ),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '01 Jan $_selectedYear - 31 Dec $_selectedYear',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down,
                    color: Color(0xFF2563EB), size: 18),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            itemCount: _entries.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
            itemBuilder: (context, i) {
              final e = _entries[i];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.date,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            e.detail,
                            style: const TextStyle(
                                fontSize: 13, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusChip(e.status),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color bg;
    Color text;
    switch (status.toUpperCase()) {
      case 'APPROVED':
        bg = const Color(0xFFDCFCE7);
        text = const Color(0xFF16A34A);
        break;
      case 'PENDING':
        bg = const Color(0xFFFEF9C3);
        text = const Color(0xFFCA8A04);
        break;
      case 'REJECTED':
        bg = const Color(0xFFFEE2E2);
        text = const Color(0xFFDC2626);
        break;
      default:
        bg = const Color(0xFFF1F5F9);
        text = const Color(0xFF64748B);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: bg),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: text,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _LeaveHistoryEntry {
  final String date;
  final String detail;
  final String status;
  const _LeaveHistoryEntry({
    required this.date,
    required this.detail,
    required this.status,
  });
}
