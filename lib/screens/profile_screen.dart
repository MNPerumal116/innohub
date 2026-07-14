import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const Color _primary = Color(0xFF2563EB);
  static const Color _bg = Color(0xFFF3F5F9);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            // Tab bar
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Finances'),
                  Tab(text: 'Performance'),
                  Tab(text: 'Documents'),
                ],
                labelColor: _primary,
                unselectedLabelColor: const Color(0xFF94A3B8),
                labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                indicatorColor: _primary,
                indicatorWeight: 2.5,
                indicatorSize: TabBarIndicatorSize.label,
                dividerColor: const Color(0xFFE2E8F0),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _FinancesTab(),
                  _PlaceholderTab(icon: Icons.bar_chart_outlined, label: 'Performance'),
                  _PlaceholderTab(icon: Icons.folder_outlined, label: 'Documents'),
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
}

// ─── Finances Tab ─────────────────────────────────────────────────────────────

class _FinancesTab extends StatelessWidget {
  static const Color _primary = Color(0xFF2563EB);
  static const Color _bg = Color(0xFFF3F5F9);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Salary Section ──
          const Text(
            'Salary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.15,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _FinanceCard(
                icon: Icons.credit_card_outlined,
                title: 'My Pay',
                subtitle: 'View salary details and payslips here',
                onTap: () {},
              ),
              _FinanceCard(
                icon: Icons.monetization_on_outlined,
                title: 'Pay Slips',
                subtitle: 'View and download your previous payslips',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.payslips);
                },
              ),
              _FinanceCard(
                icon: Icons.description_outlined,
                title: 'Tax Forms',
                subtitle: 'View and download all your tax related forms',
                onTap: () {},
              ),
              _FinanceCard(
                icon: Icons.receipt_outlined,
                title: 'Manage Tax',
                subtitle: 'View and manage tax & declaration information',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Expenses Section ──
          const Text(
            'Expenses',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          // Full-width top card
          _FinanceCard(
            icon: Icons.monetization_on_outlined,
            title: 'Add/Claim Expenses',
            subtitle: 'Create expenses, advance requests, mileage tracking, per diem and claim them',
            onTap: () {},
            fullWidth: true,
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.15,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _FinanceCard(
                icon: Icons.access_time_outlined,
                title: 'Pending',
                subtitle: 'Expenses and payments awaiting approval',
                onTap: () {},
              ),
              _FinanceCard(
                icon: Icons.check_circle_outline,
                title: 'Past Claims',
                subtitle: 'All claims which have been settled or rejected',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FinanceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool fullWidth;

  const _FinanceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF2563EB), size: 20),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF64748B),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Placeholder Tabs ─────────────────────────────────────────────────────────

class _PlaceholderTab extends StatelessWidget {
  final IconData icon;
  final String label;
  const _PlaceholderTab({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: Color(0xFFEFF6FF),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 36, color: const Color(0xFF2563EB)),
          ),
          const SizedBox(height: 16),
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$label details will appear here.',
            style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }
}
