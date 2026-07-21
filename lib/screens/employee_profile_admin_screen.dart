import 'package:flutter/material.dart';

/// Admin-facing editable employee profile page.
/// Shown after completing the Add Employee flow.
class EmployeeProfileAdminScreen extends StatefulWidget {
  const EmployeeProfileAdminScreen({super.key});

  @override
  State<EmployeeProfileAdminScreen> createState() =>
      _EmployeeProfileAdminScreenState();
}

class _EmployeeProfileAdminScreenState
    extends State<EmployeeProfileAdminScreen>
    with SingleTickerProviderStateMixin {
  static const Color _primary = Color(0xFF2563EB);
  static const Color _border = Color(0xFFE2E8F0);
  static const Color _dark = Color(0xFF1E293B);
  static const Color _muted = Color(0xFF94A3B8);
  static const Color _labelColor = Color(0xFF475569);

  late TabController _tabController;
  bool _isEditing = false;

  // Employment editable fields
  final _empIdCtrl = TextEditingController(text: 'EMP-2024-0892');
  final _jobTitleCtrl = TextEditingController(text: 'Senior Product Designer');
  final _deptCtrl = TextEditingController(text: 'Product & Design');
  final _reportingCtrl = TextEditingController(text: 'Sarah Chen');
  final _workLocationCtrl = TextEditingController(text: 'San Francisco, CA');
  final _joiningCtrl = TextEditingController(text: '03/15/2021');
  String _empType = 'Full-time';

  // Personal editable fields
  final _workEmailCtrl = TextEditingController(text: 'eleanor.vance@innohub.io');
  final _lastNameCtrl = TextEditingController(text: 'Vance');
  final _dobCtrl = TextEditingController(text: '05/14/1992');
  String _gender = 'Female';
  String _maritalStatus = 'Single';
  final _bloodGroupCtrl = TextEditingController(text: 'O+ Positive');

  // Contact
  final _personalEmailCtrl = TextEditingController(text: 'vance.elle@gmail.com');
  final _mobileCtrl = TextEditingController(text: '+1 (555) 0123-4567');
  final _emergencyContactCtrl = TextEditingController(text: 'Arthur Vance (Father)');
  final _emergencyPhoneCtrl = TextEditingController(text: '+1 (555) 0987-6543');

  // Financials
  final _bankNameCtrl = TextEditingController(text: 'Chase Manhattan');
  final _accountCtrl = TextEditingController(text: '••••••••4567');
  final _ifscCtrl = TextEditingController(text: 'CHASUS33XXX');
  final _branchCtrl = TextEditingController(text: 'Gandhipuram');
  final _panCtrl = TextEditingController(text: 'ABCDE1234F');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _empIdCtrl.dispose();
    _jobTitleCtrl.dispose();
    _deptCtrl.dispose();
    _reportingCtrl.dispose();
    _workLocationCtrl.dispose();
    _joiningCtrl.dispose();
    _workEmailCtrl.dispose();
    _lastNameCtrl.dispose();
    _dobCtrl.dispose();
    _bloodGroupCtrl.dispose();
    _personalEmailCtrl.dispose();
    _mobileCtrl.dispose();
    _emergencyContactCtrl.dispose();
    _emergencyPhoneCtrl.dispose();
    _bankNameCtrl.dispose();
    _accountCtrl.dispose();
    _ifscCtrl.dispose();
    _branchCtrl.dispose();
    _panCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: _primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              TextButton.icon(
                onPressed: () => setState(() => _isEditing = !_isEditing),
                icon: Icon(_isEditing ? Icons.check : Icons.edit,
                    color: Colors.white, size: 16),
                label: Text(_isEditing ? 'Save' : 'Edit Profile',
                    style: const TextStyle(color: Colors.white, fontSize: 13)),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Cover gradient
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF1E40AF), Color(0xFF3B82F6), Color(0xFF7C3AED)],
                      ),
                    ),
                  ),
                  // Profile info at bottom of appbar
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
                          child: const CircleAvatar(
                            radius: 32,
                            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=8'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(children: [
                                const Flexible(
                                  child: Text('Arawind Sri Raam S',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
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
                              const Row(children: [
                                Icon(Icons.work_outline, size: 12, color: Colors.white70),
                                SizedBox(width: 4),
                                Text('Software Engineer',
                                    style: TextStyle(color: Colors.white70, fontSize: 12)),
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
          // Contact strip
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                children: [
                  _infoChip(Icons.email_outlined, 'arawindsriraam.s@innoboon.com'),
                  const SizedBox(height: 6),
                  Row(children: [
                    Expanded(child: _infoChip(Icons.apartment_outlined, 'InnoBoon Technologies Pvt Ltd')),
                    const SizedBox(width: 12),
                    _infoChip(Icons.badge_outlined, '1900135IN'),
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    _metaChip('BUSINESS UNIT', 'InnoBoon'),
                    const SizedBox(width: 12),
                    _metaChip('DEPARTMENT', 'Technology'),
                    const SizedBox(width: 12),
                    _metaChip('REPORTING MANAGER', 'Selvamani Pandiyan'),
                  ]),
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
                labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
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
          _buildEmploymentSection(),
          const SizedBox(height: 16),
          _buildPersonalSection(),
          const SizedBox(height: 16),
          _buildContactSection(),
          const SizedBox(height: 16),
          _buildFinancialSection(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildEmploymentSection() {
    return _profileCard(
      icon: Icons.badge_outlined,
      title: 'Employment Details',
      children: [
        _fieldRow('Employee ID', _empIdCtrl),
        _fieldRow('Job Title / Designation', _jobTitleCtrl),
        _dropdownField('Department', _deptCtrl.text,
            ['Product & Design', 'Engineering', 'Sales', 'HR'],
            (v) => setState(() => _deptCtrl.text = v!)),
        _fieldRow('Reporting Manager', _reportingCtrl,
            prefix: const Icon(Icons.search, size: 16, color: Color(0xFF94A3B8))),
        _fieldRow('Work Location', _workLocationCtrl),
        _fieldRow('Joining Date', _joiningCtrl),
        _dropdownField('Employment Type', _empType,
            ['Full-time', 'Part-time', 'Contract'],
            (v) => setState(() => _empType = v!)),
      ],
    );
  }

  Widget _buildPersonalSection() {
    return _profileCard(
      icon: Icons.person_outline,
      title: 'Personal Details',
      children: [
        _fieldRow('Work Email', _workEmailCtrl),
        _fieldRow('Last Name', _lastNameCtrl),
        _fieldRow('Date of Birth', _dobCtrl),
        _dropdownField('Gender', _gender, ['Male', 'Female', 'Other'],
            (v) => setState(() => _gender = v!)),
        _dropdownField('Marital Status', _maritalStatus,
            ['Single', 'Married', 'Divorced'],
            (v) => setState(() => _maritalStatus = v!)),
        _fieldRow('Blood Group', _bloodGroupCtrl),
      ],
    );
  }

  Widget _buildContactSection() {
    return _profileCard(
      icon: Icons.contact_phone_outlined,
      title: 'Contact Information',
      children: [
        _readOnlyField('Work Email (Read Only)', _workEmailCtrl.text),
        _fieldRow('Personal Email', _personalEmailCtrl),
        _fieldRow('Mobile Number', _mobileCtrl),
        _fieldRow('Emergency Contact', _emergencyContactCtrl),
        _fieldRow('Emergency Phone', _emergencyPhoneCtrl),
      ],
    );
  }

  Widget _buildFinancialSection() {
    return _profileCard(
      icon: Icons.account_balance_outlined,
      title: 'Financials',
      children: [
        _fieldRow('Bank Name', _bankNameCtrl),
        _fieldRow('Account Number', _accountCtrl),
        _fieldRow('IFSC / Swift Code', _ifscCtrl),
        _fieldRow('Branch', _branchCtrl),
        _fieldRow('PAN / Tax ID', _panCtrl),
      ],
    );
  }

  Widget _profileCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
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
            Icon(icon, size: 18, color: _primary),
            const SizedBox(width: 8),
            Text(title,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold, color: _dark)),
          ]),
          const SizedBox(height: 4),
          const Divider(color: Color(0xFFE2E8F0)),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _fieldRow(String label, TextEditingController ctrl,
      {Widget? prefix}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w600, color: _labelColor)),
          const SizedBox(height: 6),
          TextField(
            controller: ctrl,
            enabled: _isEditing,
            style: const TextStyle(fontSize: 13, color: _dark),
            decoration: InputDecoration(
              prefixIcon: prefix,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              filled: true,
              fillColor: _isEditing ? Colors.white : const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: _border)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: _border)),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: _border)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: _primary, width: 1.5)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _readOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w600, color: _labelColor)),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _border),
            ),
            child: Text(value,
                style: const TextStyle(fontSize: 13, color: _muted)),
          ),
        ],
      ),
    );
  }

  Widget _dropdownField(
      String label, String value, List<String> options, ValueChanged<String?> cb) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w600, color: _labelColor)),
          const SizedBox(height: 6),
          IgnorePointer(
            ignoring: !_isEditing,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: _isEditing ? Colors.white : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _border),
              ),
              child: DropdownButton<String>(
                value: options.contains(value) ? value : options.first,
                onChanged: _isEditing ? cb : null,
                isExpanded: true,
                underline: const SizedBox(),
                style: const TextStyle(fontSize: 13, color: _dark),
                icon: const Icon(Icons.keyboard_arrow_down, color: _muted),
                items: options
                    .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                    .toList(),
              ),
            ),
          ),
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
        const Text('Content will be available soon.',
            style: TextStyle(color: Color(0xFF94A3B8))),
      ]),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: _muted),
        const SizedBox(width: 5),
        Flexible(
          child: Text(text,
              style: const TextStyle(fontSize: 12, color: _labelColor),
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  Widget _metaChip(String label, String value) {
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
              style: const TextStyle(fontSize: 11, color: _dark, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _TabBarDelegate(this.tabBar);

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      Container(color: Colors.white, child: tabBar);

  @override
  double get maxExtent => tabBar.preferredSize.height;
  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}
