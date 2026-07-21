import 'package:flutter/material.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  static const Color _primary = Color(0xFF2563EB);
  static const Color _bg = Color(0xFFF8FAFC);
  static const Color _border = Color(0xFFE2E8F0);
  static const Color _labelColor = Color(0xFF475569);
  static const Color _dark = Color(0xFF1E293B);
  static const Color _muted = Color(0xFF94A3B8);

  // Step 1
  final _firstNameCtrl = TextEditingController();
  final _middleNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _displayNameCtrl = TextEditingController();
  final _employeeNumberCtrl = TextEditingController(text: '1900144IN');
  final _workEmailCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  String _workCountry = 'India';
  String _gender = 'Male';
  String _nationality = 'Indian';
  String _dob = '';

  // Step 2
  final _joiningDateCtrl = TextEditingController(text: '30 Jun 2026');
  final _jobTitleCtrl = TextEditingController(text: 'Consultant');
  String _timeType = 'Full Time';
  final _legalEntityCtrl = TextEditingController(text: 'InnoBoon Technologies Private Limited');
  final _businessUnitCtrl = TextEditingController(text: 'InnoBoon');
  final _departmentCtrl = TextEditingController(text: 'Technology');
  final _locationCtrl = TextEditingController(text: 'InnoBoon Technologies Private Limited');
  String _workerType = 'Permanent';
  final _managerCtrl = TextEditingController(text: 'Sonny Ben');
  String _probationPolicy = 'Default Probation Policy';
  String _noticePeriod = 'Default Notice Period';

  // Step 3
  bool _inviteToLogin = true;
  bool _enableOnboarding = false;
  String _leavePlan = '2023-2024';
  String _holidayList = 'IB Holiday 2026';
  bool _attendanceTracking = true;
  String _shift = 'Default work shift';
  String _weeklyOff = "Saturday's partial off, Sunday's off";
  final _attendanceNumberCtrl = TextEditingController(text: '144');
  String _timeTrackingPolicy = 'Default Attendance Capture Scheme';
  String _penalizationPolicy = 'InnoBoon Default Attendance Tracking Policy';
  String _overtime = 'IB - Default Overtime Policy';

  // Step 4
  bool _enablePayroll = true;
  String _payGroup = 'Default pay group';
  final _annualSalaryCtrl = TextEditingController();
  bool _bonusIncluded = false;
  bool _pfEligible = false;
  bool _eelEligible = false;
  bool _lufEligible = false;
  String _salaryStructureType = 'Range Based';
  String _taxRegime = 'New Regime (Section 115BAC)';
  bool _detailedBreakup = false;

  final List<String> _stepLabels = ['BASIC', 'JOB', 'WORK', 'COMP.'];
  final List<String> _stepFullLabels = ['Basic Details', 'Job Details', 'Work Details', 'Compensation'];

  @override
  void dispose() {
    _pageController.dispose();
    _firstNameCtrl.dispose();
    _middleNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _displayNameCtrl.dispose();
    _employeeNumberCtrl.dispose();
    _workEmailCtrl.dispose();
    _mobileCtrl.dispose();
    _joiningDateCtrl.dispose();
    _jobTitleCtrl.dispose();
    _legalEntityCtrl.dispose();
    _businessUnitCtrl.dispose();
    _departmentCtrl.dispose();
    _locationCtrl.dispose();
    _managerCtrl.dispose();
    _attendanceNumberCtrl.dispose();
    _annualSalaryCtrl.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    if (step < 0 || step > 3) return;
    setState(() => _currentStep = step);
    _pageController.animateToPage(step,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        shadowColor: _border,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: _dark, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Add Employee',
            style: TextStyle(color: _dark, fontSize: 16, fontWeight: FontWeight.w700)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: _buildStepIndicator(),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildStep1(),
          _buildStep2(),
          _buildStep3(),
          _buildStep4(),
        ],
      ),
      bottomNavigationBar: _buildNavButtons(),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: List.generate(_stepLabels.length, (i) {
          final isDone = i < _currentStep;
          final isActive = i == _currentStep;
          return Expanded(
            child: Row(
              children: [
                GestureDetector(
                  onTap: isDone ? () => _goToStep(i) : null,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDone || isActive ? _primary : Colors.transparent,
                          border: Border.all(
                            color: isDone || isActive ? _primary : _muted,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: isDone
                              ? const Icon(Icons.check, color: Colors.white, size: 15)
                              : Text('${i + 1}',
                                  style: TextStyle(
                                    color: isActive ? Colors.white : _muted,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  )),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(_stepLabels[i],
                          style: TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700,
                            color: isDone || isActive ? _primary : _muted,
                          )),
                    ],
                  ),
                ),
                if (i < _stepLabels.length - 1)
                  Expanded(
                    child: Container(
                      height: 1.5,
                      margin: const EdgeInsets.only(bottom: 16),
                      color: i < _currentStep ? _primary : _border,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNavButtons() {
    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            if (_currentStep > 0)
              OutlinedButton(
                onPressed: () => _goToStep(_currentStep - 1),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _dark,
                  side: const BorderSide(color: _border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                ),
                child: const Text('Previous', style: TextStyle(fontSize: 13)),
              ),
            const Spacer(),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: _dark,
                side: const BorderSide(color: _border),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
              ),
              child: const Text('Cancel', style: TextStyle(fontSize: 13)),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                if (_currentStep < 3) {
                  _goToStep(_currentStep + 1);
                } else {
                  Navigator.pushReplacementNamed(context, '/employee/profile-admin');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                elevation: 0,
              ),
              child: Text(
                _currentStep == 3 ? 'Complete' : 'Next: ${_stepFullLabels[_currentStep + 1]}',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STEP 1 – Basic Details
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionCard(
            icon: Icons.person_outline,
            title: 'Employee Details',
            children: [
              _dropdown('Work Country *', _workCountry,
                  ['India', 'United States', 'United Kingdom'],
                  (v) => setState(() => _workCountry = v!)),
              _textField('First Name *', _firstNameCtrl, hint: 'First Name'),
              _textField('Middle Name', _middleNameCtrl, hint: 'Middle Name'),
              _textField('Last Name *', _lastNameCtrl, hint: 'Last Name'),
              _textField('Display Name *', _displayNameCtrl, hint: 'Display Name'),
              _dropdown('Gender *', _gender, ['Male', 'Female', 'Other'],
                  (v) => setState(() => _gender = v!)),
              _datePicker('Date of Birth *', _dob, () async {
                final d = await showDatePicker(
                    context: context,
                    initialDate: DateTime(1995),
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now());
                if (d != null) {
                  setState(() => _dob =
                      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}');
                }
              }),
              _dropdown('Nationality *', _nationality,
                  ['Indian', 'American', 'British', 'Other'],
                  (v) => setState(() => _nationality = v!)),
              _textField('Employee Number *', _employeeNumberCtrl, hint: '1900144IN'),
            ],
          ),
          const SizedBox(height: 16),
          _sectionCard(
            icon: Icons.contact_phone_outlined,
            title: 'Contact Details',
            children: [
              _textField('Work Email *', _workEmailCtrl,
                  hint: 'name@company.com',
                  type: TextInputType.emailAddress),
              _phoneField('Mobile Number', _mobileCtrl),
            ],
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STEP 2 – Job Details
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _sectionCard(
            icon: Icons.work_outline,
            title: 'Employment Details',
            children: [
              _datePicker('Joining Date *', _joiningDateCtrl.text, () {}),
              _textField('Job Title *', _jobTitleCtrl, hint: 'e.g. Consultant'),
              _dropdown('Time Type *', _timeType, ['Full Time', 'Part Time', 'Contract'],
                  (v) => setState(() => _timeType = v!)),
            ],
          ),
          const SizedBox(height: 16),
          _sectionCard(
            icon: Icons.apartment_outlined,
            title: 'Organisational Details',
            children: [
              _textField('Legal Entity *', _legalEntityCtrl,
                  hint: 'e.g. InnoBoon Technologies Pvt Ltd'),
              _textField('Business Unit *', _businessUnitCtrl, hint: 'e.g. InnoBoon'),
              _textField('Department *', _departmentCtrl, hint: 'e.g. Technology'),
              _textField('Location *', _locationCtrl, hint: 'Office location'),
              _dropdown('Worker Type *', _workerType,
                  ['Permanent', 'Contract', 'Intern'],
                  (v) => setState(() => _workerType = v!)),
              _textField('Reporting Manager *', _managerCtrl,
                  hint: 'Search manager...'),
            ],
          ),
          const SizedBox(height: 16),
          _sectionCard(
            icon: Icons.gavel_outlined,
            title: 'Employment Terms',
            children: [
              _dropdown('Probation Policy *', _probationPolicy,
                  ['Default Probation Policy', 'Custom Policy'],
                  (v) => setState(() => _probationPolicy = v!)),
              const Padding(
                padding: EdgeInsets.only(bottom: 4, left: 2),
                child: Text('Duration: 3 Months',
                    style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
              ),
              _dropdown('Notice Period *', _noticePeriod,
                  ['Default Notice Period', 'Custom Period'],
                  (v) => setState(() => _noticePeriod = v!)),
              const Padding(
                padding: EdgeInsets.only(left: 2),
                child: Text('Duration: 3 Months',
                    style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STEP 3 – Work Details
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _sectionCard(
            icon: Icons.settings_outlined,
            title: 'Onboarding Settings',
            children: [
              _checkRow('Invite employee to login', _inviteToLogin,
                  (v) => setState(() => _inviteToLogin = v!)),
              _checkRow('Enable onboarding flow', _enableOnboarding,
                  (v) => setState(() => _enableOnboarding = v!)),
            ],
          ),
          const SizedBox(height: 16),
          _sectionCard(
            icon: Icons.event_note_outlined,
            title: 'Leave Settings',
            children: [
              _dropdown('Leave Plan *', _leavePlan,
                  ['2023-2024', '2024-2025', '2025-2026'],
                  (v) => setState(() => _leavePlan = v!)),
              _dropdown('Holiday List *', _holidayList,
                  ['IB Holiday 2026', 'IB Holiday 2025'],
                  (v) => setState(() => _holidayList = v!)),
            ],
          ),
          const SizedBox(height: 16),
          _sectionCard(
            icon: Icons.access_time_outlined,
            title: 'Attendance Settings',
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Attendance Tracking',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1E293B))),
                  Switch(
                    value: _attendanceTracking,
                    onChanged: (v) => setState(() => _attendanceTracking = v),
                    activeColor: const Color(0xFF2563EB),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              _dropdown('Shift *', _shift,
                  ['Default work shift', 'Night shift', 'Rotational'],
                  (v) => setState(() => _shift = v!)),
              _dropdown('Weekly Off *', _weeklyOff, [
                "Saturday's partial off, Sunday's off",
                "Sunday's off only",
                "Saturday & Sunday off",
              ], (v) => setState(() => _weeklyOff = v!)),
              _textField('Attendance Number', _attendanceNumberCtrl,
                  hint: 'e.g. 144', type: TextInputType.number),
              _dropdown('Time Tracking Policy *', _timeTrackingPolicy,
                  ['Default Attendance Capture Scheme', 'Custom Scheme'],
                  (v) => setState(() => _timeTrackingPolicy = v!)),
              _dropdown('Penalization Policy *', _penalizationPolicy,
                  ['InnoBoon Default Attendance Tracking Policy', 'Custom Policy'],
                  (v) => setState(() => _penalizationPolicy = v!)),
              _dropdown('Overtime', _overtime,
                  ['IB - Default Overtime Policy', 'Custom Overtime'],
                  (v) => setState(() => _overtime = v!)),
            ],
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STEP 4 – Compensation
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildStep4() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Enable payroll toggle
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Switch(
                  value: _enablePayroll,
                  onChanged: (v) => setState(() => _enablePayroll = v),
                  activeColor: const Color(0xFF2563EB),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text('Enable payroll for this employee',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1E293B))),
                ),
              ],
            ),
          ),

          if (_enablePayroll) ...[
            const SizedBox(height: 16),
            _sectionCard(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Pay Details',
              children: [
                _dropdown('Pay Group', _payGroup,
                    ['Default pay group', 'Custom pay group'],
                    (v) => setState(() => _payGroup = v!)),
                _textField('Annual Salary', _annualSalaryCtrl,
                    hint: 'Enter amount', type: TextInputType.number),
              ],
            ),
            const SizedBox(height: 16),
            _sectionCard(
              icon: Icons.card_giftcard_outlined,
              title: 'Bonus Details',
              children: [
                _checkRow(
                    'Bonus amount is included in the annual salary of INR 0',
                    _bonusIncluded,
                    (v) => setState(() => _bonusIncluded = v!)),
                const SizedBox(height: 4),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 14, color: Color(0xFF2563EB)),
                  label: const Text('Add Bonus',
                      style: TextStyle(color: Color(0xFF2563EB), fontSize: 13)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF2563EB)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Salary Breakup card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Salary Breakup',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B))),
                      Row(children: [
                        const Text('Detailed',
                            style: TextStyle(
                                fontSize: 11, color: Color(0xFF94A3B8))),
                        const SizedBox(width: 6),
                        Transform.scale(
                          scale: 0.75,
                          child: Switch(
                            value: _detailedBreakup,
                            onChanged: (v) =>
                                setState(() => _detailedBreakup = v),
                            activeColor: const Color(0xFF2563EB),
                          ),
                        ),
                      ]),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text('SALARY EFFECTIVE FROM',
                      style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF94A3B8),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5)),
                  const Text('30 Jun 2026',
                      style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF1E293B),
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _salaryCell('REGULAR\nSALARY', 'INR 0'),
                      const Text(' + ',
                          style: TextStyle(
                              color: Color(0xFF94A3B8), fontSize: 18)),
                      _salaryCell('BONUS', 'INR 0'),
                      const Text(' = ',
                          style: TextStyle(
                              color: Color(0xFF94A3B8), fontSize: 18)),
                      _salaryCell('TOTAL', 'INR 0', bold: true),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _sectionCard(
              icon: Icons.settings_outlined,
              title: 'Payroll Settings',
              children: [
                Column(
                  children: [
                    _checkRow('Provident Fund (PF) eligible', _pfEligible,
                        (v) => setState(() => _pfEligible = v!)),
                    _checkRow('ESI eligible', _eelEligible,
                        (v) => setState(() => _eelEligible = v!)),
                    _checkRow('LuF eligible', _lufEligible,
                        (v) => setState(() => _lufEligible = v!)),
                  ],
                ),
                _dropdown('Salary Structure Type', _salaryStructureType,
                    ['Range Based', 'Fixed'],
                    (v) => setState(() => _salaryStructureType = v!)),
                _dropdown('Tax Regime', _taxRegime,
                    ['New Regime (Section 115BAC)', 'Old Regime'],
                    (v) => setState(() => _taxRegime = v!)),
              ],
            ),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // Shared Helpers
  // ══════════════════════════════════════════════════════════════════════════

  Widget _sectionCard({
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
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: _dark)),
          ]),
          const SizedBox(height: 4),
          const Divider(color: Color(0xFFE2E8F0)),
          const SizedBox(height: 8),
          ...children.map((w) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: w,
              )),
        ],
      ),
    );
  }

  Widget _textField(String label, TextEditingController ctrl,
      {String? hint, TextInputType type = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: _labelColor)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          keyboardType: type,
          style: const TextStyle(fontSize: 14, color: _dark),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: _muted, fontSize: 13),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: _border)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: _border)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: _primary, width: 1.5)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _dropdown(String label, String value, List<String> options,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: _labelColor)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            border: Border.all(color: _border),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: DropdownButton<String>(
            value: options.contains(value) ? value : options.first,
            onChanged: onChanged,
            isExpanded: true,
            underline: const SizedBox(),
            style: const TextStyle(fontSize: 14, color: _dark),
            icon: const Icon(Icons.keyboard_arrow_down, color: _muted),
            items: options
                .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _datePicker(String label, String value, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: _labelColor)),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              border: Border.all(color: _border),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value.isEmpty ? 'dd/mm/yyyy' : value,
                    style: TextStyle(
                        fontSize: 14,
                        color: value.isEmpty ? _muted : _dark)),
                const Icon(Icons.calendar_today_outlined,
                    size: 16, color: _muted),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _phoneField(String label, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: _labelColor)),
        const SizedBox(height: 6),
        Row(children: [
          Container(
            height: 49,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: _border),
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(8)),
              color: const Color(0xFFF8FAFC),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('+91', style: TextStyle(fontSize: 14, color: _dark)),
                SizedBox(width: 4),
                Icon(Icons.arrow_drop_down, size: 18, color: _muted),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 49,
              child: TextField(
                controller: ctrl,
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 14, color: _dark),
                decoration: InputDecoration(
                  hintText: 'Mobile Number',
                  hintStyle: const TextStyle(color: _muted, fontSize: 13),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 13),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(8)),
                      borderSide: BorderSide(color: _border)),
                  enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(8)),
                      borderSide: BorderSide(color: _border)),
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(8)),
                      borderSide:
                          BorderSide(color: _primary, width: 1.5)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ),
        ]),
      ],
    );
  }

  Widget _checkRow(String label, bool value, ValueChanged<bool?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: _primary,
              side: const BorderSide(color: _border, width: 1.5),
              visualDensity: VisualDensity.compact,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label,
                style: const TextStyle(fontSize: 13, color: _dark)),
          ),
        ],
      ),
    );
  }

  Widget _salaryCell(String label, String value, {bool bold = false}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 9,
                  color: _muted,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3)),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  fontSize: 14,
                  color: _dark,
                  fontWeight:
                      bold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
