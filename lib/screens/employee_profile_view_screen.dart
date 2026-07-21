import 'package:flutter/material.dart';
import 'employee_directory_screen.dart';

/// Read-only employee profile view — shown when tapping an employee card.
class EmployeeProfileViewScreen extends StatefulWidget {
  final Employee employee;
  const EmployeeProfileViewScreen({super.key, required this.employee});

  @override
  State<EmployeeProfileViewScreen> createState() =>
      _EmployeeProfileViewScreenState();
}

class _EmployeeProfileViewScreenState extends State<EmployeeProfileViewScreen>
    with SingleTickerProviderStateMixin {
  static const Color _primary = Color(0xFF2563EB);
  static const Color _border = Color(0xFFE2E8F0);
  static const Color _dark = Color(0xFF1E293B);
  static const Color _muted = Color(0xFF94A3B8);
  static const Color _labelColor = Color(0xFF475569);

  late TabController _tabController;
  int _summaryTab = 0; // 0=Summary, 1=Timeline, 2=Wall Activity

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

  Employee get emp => widget.employee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: _primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF1E40AF), Color(0xFF3B82F6), Color(0xFF7C3AED)],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 12,
                    right: 16,
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: const Color(0xFFEFF6FF),
                            child: Text(emp.initials,
                                style: const TextStyle(
                                    color: _primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(children: [
                                Flexible(
                                  child: Text(emp.name,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text('IN',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ]),
                              const SizedBox(height: 2),
                              Row(children: [
                                const Icon(Icons.work_outline,
                                    size: 12, color: Colors.white70),
                                const SizedBox(width: 4),
                                Text(emp.role,
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 11)),
                              ]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Info strip
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Row(children: [
                    const Icon(Icons.email_outlined, size: 13, color: _muted),
                    const SizedBox(width: 5),
                    Text('${emp.initials.toLowerCase()}.person@gmail.com',
                        style: const TextStyle(fontSize: 12, color: _labelColor)),
                  ]),
                  const SizedBox(height: 6),
                  Row(children: [
                    const Icon(Icons.phone_outlined, size: 13, color: _muted),
                    const SizedBox(width: 5),
                    const Text('+91 98765 43210',
                        style: TextStyle(fontSize: 12, color: _labelColor)),
                    const SizedBox(width: 16),
                    const Icon(Icons.badge_outlined, size: 13, color: _muted),
                    const SizedBox(width: 5),
                    Text(emp.id,
                        style: const TextStyle(fontSize: 12, color: _labelColor)),
                  ]),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _metaBlock('BUSINESS UNIT', 'InnoBoon'),
                      _metaBlock('DEPARTMENT', emp.department),
                      _metaBlock('MANAGER', emp.manager),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Tabs
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: _primary,
                unselectedLabelColor: _muted,
                indicatorColor: _primary,
                indicatorWeight: 2.5,
                labelStyle:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                tabs: const [
                  Tab(text: 'About'),
                  Tab(text: 'Performance'),
                  Tab(text: 'Documents'),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildAboutTab(),
            _buildPlaceholderTab('Performance', Icons.show_chart),
            _buildPlaceholderTab('Documents', Icons.description_outlined),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Sub-tabs: Summary / Timeline / Wall Activity
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _border),
            ),
            child: Row(
              children: ['Summary', 'Timeline', 'Wall Activity']
                  .asMap()
                  .entries
                  .map((e) {
                final isActive = _summaryTab == e.key;
                return GestureDetector(
                  onTap: () => setState(() => _summaryTab = e.key),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isActive ? _primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(e.value,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isActive ? Colors.white : _muted)),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          if (_summaryTab == 0) ...[
            // About card
            _viewCard(
              icon: Icons.info_outline,
              title: 'About',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Who am I?',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: _primary)),
                  const SizedBox(height: 6),
                  const Text(
                    'A passionate professional dedicated to building scalable and user-centric solutions. With a focus on performance and clean architecture, I enjoy tackling complex challenges.',
                    style: TextStyle(fontSize: 13, color: _labelColor, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Personal / Contact / Bank - info rows
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _viewCard(
                    icon: Icons.person_outline,
                    title: 'Personal Information',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoRow('Date of Birth', '15 May 1998'),
                        _infoRow('Gender', 'Male'),
                        _infoRow('Nationality', 'Indian'),
                        _infoRow('Marital Status', 'Single'),
                        _infoRow('Blood Group', 'O Positive'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _viewCard(
              icon: Icons.contact_phone_outlined,
              title: 'Contact Information',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow('Personal Email', 'person@gmail.com'),
                  _infoRow('Mobile Number', '+91 98765 43210'),
                  _infoRow('Emergency Contact', 'Sri Raam (Father)'),
                  _infoRow('Emergency Phone', '+91 98765 43211'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _viewCard(
              icon: Icons.account_balance_outlined,
              title: 'Bank Information',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow('Bank Name', 'HDFC Bank Ltd.'),
                  _infoRow('Account Number', '•••• •••• 5679'),
                  _infoRow('IFSC Code', 'HDFC0001234'),
                  _infoRow('Branch', 'Gandhipuram'),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1FAE5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle,
                            size: 14, color: Color(0xFF065F46)),
                        SizedBox(width: 4),
                        Text('VERIFIED FOR PAYROLL',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF065F46))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ] else if (_summaryTab == 1) ...[
            _buildTimeline(),
          ] else ...[
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Text('No wall activity yet.',
                    style: TextStyle(color: _muted)),
              ),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    final events = [
      _TimelineEvent(
          title: 'Promoted to Senior Software Engineer',
          subtitle: 'Projected: Q1 2024',
          tag: 'GOAL',
          tagColor: const Color(0xFF3B82F6),
          dotColor: _primary),
      _TimelineEvent(
          title: '1 Year Anniversary at InnoBoon',
          subtitle: 'Dec 12, 2023',
          tag: 'COMPLETED',
          tagColor: const Color(0xFF10B981),
          dotColor: Colors.green),
      _TimelineEvent(
          title: 'Joined as Software Engineer',
          subtitle: 'Dec 12, 2023',
          tag: 'MILESTONE',
          tagColor: _muted,
          dotColor: _muted),
    ];

    return Column(
      children: events.map((e) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: e.dotColor),
                ),
                Container(
                    width: 2, height: 48, color: const Color(0xFFE2E8F0)),
              ]),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.title,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: _dark)),
                            const SizedBox(height: 2),
                            Text(e.subtitle,
                                style: const TextStyle(
                                    fontSize: 11, color: _muted)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: e.tagColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(e.tag,
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: e.tagColor)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _viewCard(
      {required IconData icon,
      required String title,
      required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, size: 16, color: _primary),
            const SizedBox(width: 8),
            Text(title,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
          ]),
          const SizedBox(height: 4),
          const Divider(color: Color(0xFFE2E8F0)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, color: _muted)),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _dark),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _metaBlock(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: _muted,
                  letterSpacing: 0.3)),
          const SizedBox(height: 2),
          Text(value,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _dark),
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildPlaceholderTab(String title, IconData icon) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, size: 56, color: const Color(0xFFCBD5E1)),
        const SizedBox(height: 12),
        Text(title,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
        const SizedBox(height: 6),
        const Text('Content coming soon.',
            style: TextStyle(color: Color(0xFF94A3B8))),
      ]),
    );
  }
}

class _TimelineEvent {
  final String title, subtitle, tag;
  final Color tagColor, dotColor;
  _TimelineEvent({
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.tagColor,
    required this.dotColor,
  });
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _TabBarDelegate(this.tabBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) =>
      Container(color: Colors.white, child: tabBar);

  @override
  double get maxExtent => tabBar.preferredSize.height;
  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}
