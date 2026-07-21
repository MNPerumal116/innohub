import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class Employee {
  final String name;
  final String role;
  final String id;
  final String department;
  final String manager;
  final String joinedDate;
  final String status;
  final String location;
  final String initials;

  Employee({
    required this.name,
    required this.role,
    required this.id,
    required this.department,
    required this.manager,
    required this.joinedDate,
    required this.status,
    required this.location,
    required this.initials,
  });
}

class EmployeeDirectoryScreen extends StatefulWidget {
  const EmployeeDirectoryScreen({super.key});

  @override
  State<EmployeeDirectoryScreen> createState() =>
      _EmployeeDirectoryScreenState();
}

enum ViewMode { list, grid, orgChart }

class _EmployeeDirectoryScreenState extends State<EmployeeDirectoryScreen> {
  ViewMode _viewMode = ViewMode.grid;

  final List<Employee> _employees = [
    Employee(
      name: 'Sarah Jenkins',
      role: 'Senior Frontend Engineer',
      id: '#EMP-2045',
      department: 'Engineering',
      manager: 'Marcus Thorne',
      joinedDate: 'Jan 12, 2022',
      status: 'ACTIVE',
      location: 'SF, USA',
      initials: 'SJ',
    ),
    Employee(
      name: 'Liam Anderson',
      role: 'Lead Product Designer',
      id: '#EMP-1982',
      department: 'Design',
      manager: 'Elena Rodriguez',
      joinedDate: 'Mar 05, 2021',
      status: 'REMOTE',
      location: 'London, UK',
      initials: 'LA',
    ),
    Employee(
      name: 'Olivia Martinez',
      role: 'HR Coordinator',
      id: '#EMP-2101',
      department: 'Human Resources',
      manager: 'David Chen',
      joinedDate: 'Oct 19, 2023',
      status: 'ON LEAVE',
      location: 'Madrid, ESP',
      initials: 'OM',
    ),
    Employee(
      name: 'James Wilson',
      role: 'Accountant',
      id: '#EMP-1854',
      department: 'Sales',
      manager: 'Sarah Jenkins',
      joinedDate: 'Jun 30, 2020',
      status: 'ACTIVE',
      location: 'Seoul, KR',
      initials: 'JW',
    ),
    Employee(
      name: 'Sophia Kwok',
      role: 'Marketing Specialist',
      id: '#EMP-2231',
      department: 'Devops',
      manager: 'Elena Rodriguez',
      joinedDate: 'Feb 14, 2024',
      status: 'ACTIVE',
      location: 'Tokyo, JP',
      initials: 'SK',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Employee Directory',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black87),
            onPressed: _showFilters,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addEmployee),
        backgroundColor: const Color(0xFF2563EB),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // View Toggle Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _viewMode = ViewMode.list),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: _viewMode == ViewMode.list
                                    ? Colors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: _viewMode == ViewMode.list
                                    ? [
                                        const BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 4,
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.list,
                                    size: 16,
                                    color: _viewMode == ViewMode.list
                                        ? const Color(0xFF2563EB)
                                        : const Color(0xFF64748B),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'List',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _viewMode == ViewMode.list
                                          ? const Color(0xFF2563EB)
                                          : const Color(0xFF64748B),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _viewMode = ViewMode.grid),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: _viewMode == ViewMode.grid
                                    ? Colors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: _viewMode == ViewMode.grid
                                    ? [
                                        const BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 4,
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.grid_view,
                                    size: 16,
                                    color: _viewMode == ViewMode.grid
                                        ? const Color(0xFF2563EB)
                                        : const Color(0xFF64748B),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Grid',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _viewMode == ViewMode.grid
                                          ? const Color(0xFF2563EB)
                                          : const Color(0xFF64748B),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _viewMode = ViewMode.orgChart),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: _viewMode == ViewMode.orgChart
                                    ? Colors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: _viewMode == ViewMode.orgChart
                                    ? [
                                        const BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 4,
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.account_tree_outlined,
                                    size: 16,
                                    color: _viewMode == ViewMode.orgChart
                                        ? const Color(0xFF2563EB)
                                        : const Color(0xFF64748B),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Org',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _viewMode == ViewMode.orgChart
                                          ? const Color(0xFF2563EB)
                                          : const Color(0xFF64748B),
                                      fontWeight: FontWeight.w600,
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
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download, size: 16),
                  label: const Text('Export'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF475569),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: _viewMode == ViewMode.list
                ? _buildListView()
                : _viewMode == ViewMode.grid
                ? _buildGridView()
                : _buildOrgChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _employees.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final emp = _employees[index];
        return GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.employeeProfileView,
            arguments: emp,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color(0xFFEFF6FF),
                        child: Text(
                          emp.initials,
                          style: const TextStyle(
                            color: Color(0xFF2563EB),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              emp.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${emp.role} • ${emp.department}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildStatusPill(emp.status),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: Color(0xFFE2E8F0)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: Color(0xFF94A3B8),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            emp.location,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.badge_outlined,
                            size: 14,
                            color: Color(0xFF94A3B8),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            emp.id,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio:
            0.72, // Slightly increased vertical space to prevent overflow
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _employees.length,
      itemBuilder: (context, index) {
        final emp = _employees[index];
        return GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.employeeProfileView,
            arguments: emp,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: _buildStatusPill(emp.status),
                ),
                CircleAvatar(
                  radius: 32,
                  backgroundColor: const Color(0xFFEFF6FF),
                  child: Text(
                    emp.initials,
                    style: const TextStyle(
                      color: Color(0xFF2563EB),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        emp.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${emp.role}\n${emp.department}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 12,
                      color: Color(0xFF94A3B8),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        emp.location,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF64748B),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrgChart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.account_tree, size: 64, color: Color(0xFFCBD5E1)),
          const SizedBox(height: 16),
          const Text(
            'Org Chart View',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Detailed hierarchy mapping will be displayed here.',
            style: TextStyle(color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
            ),
            child: const Text(
              'Add Node',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(String status) {
    Color bg = const Color(0xFFDCFCE7);
    Color text = const Color(0xFF166534);

    if (status == 'ON LEAVE') {
      bg = const Color(0xFFFFEDD5);
      text = const Color(0xFF9A3412);
    } else if (status == 'REMOTE') {
      bg = const Color(0xFFDBEAFE);
      text = const Color(0xFF1E40AF);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: text,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 24,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildFilterDropdown('Department', 'All Departments'),
              const SizedBox(height: 16),
              _buildFilterDropdown('Role', 'All Roles'),
              const SizedBox(height: 16),
              _buildFilterDropdown('Location', 'All Locations'),
              const SizedBox(height: 16),
              _buildFilterDropdown('Status', 'Any Status'),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Apply Filters',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterDropdown(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF475569),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: const TextStyle(color: Color(0xFF1E293B))),
              const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B)),
            ],
          ),
        ),
      ],
    );
  }
}
