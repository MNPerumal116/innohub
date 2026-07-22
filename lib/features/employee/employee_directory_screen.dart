import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/employee_bloc.dart';
import 'bloc/employee_event.dart';
import 'bloc/employee_state.dart';
import 'model/employee_model.dart';
import '../../../widgets/common_loader.dart';

class EmployeeDirectoryScreen extends StatefulWidget {
  const EmployeeDirectoryScreen({super.key});

  @override
  State<EmployeeDirectoryScreen> createState() =>
      _EmployeeDirectoryScreenState();
}

enum ViewMode { list, grid, orgChart }

class _EmployeeDirectoryScreenState extends State<EmployeeDirectoryScreen> {
  ViewMode _viewMode = ViewMode.grid;

  @override
  void initState() {
    super.initState();
    context.read<EmployeeBloc>().add(FetchEmployees());
  }

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
            child: BlocBuilder<EmployeeBloc, EmployeeState>(
              builder: (context, state) {
                if (state is EmployeeLoading) {
                  return const CommonLoader(message: 'Loading employees...');
                } else if (state is EmployeeError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else if (state is EmployeeLoaded) {
                  final emps = state.employees;
                  if (emps.isEmpty)
                    return const Center(child: Text('No employees found.'));

                  if (_viewMode == ViewMode.list) {
                    return _buildListView(emps);
                  } else if (_viewMode == ViewMode.grid) {
                    return _buildGridView(emps);
                  } else {
                    return _buildOrgChart(emps);
                  }
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List<Employee> employees) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: employees.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        var emp = employees[index];
        var initials = emp.displayName.isNotEmpty ? emp.displayName[0] : 'U';
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
                          initials,
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
                              emp.displayName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${emp.jobTitle} • ${emp.department}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildStatusPill(emp.isActive ? 'ACTIVE' : 'INACTIVE'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: Color(0xFFE2E8F0)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: Color(0xFF94A3B8),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                emp.location,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.badge_outlined,
                              size: 14,
                              color: Color(0xFF94A3B8),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                emp.employeeNumber,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildGridView(List<Employee> employees) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio:
            0.72, // Slightly increased vertical space to prevent overflow
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: employees.length,
      itemBuilder: (context, index) {
        final emp = employees[index];
        final initials = emp.displayName.isNotEmpty ? emp.displayName[0] : 'U';
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
                  child: _buildStatusPill(emp.isActive ? 'ACTIVE' : 'INACTIVE'),
                ),
                CircleAvatar(
                  radius: 32,
                  backgroundColor: const Color(0xFFEFF6FF),
                  child: Text(
                    initials,
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
                        emp.displayName,
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
                        '${emp.jobTitle}\n${emp.department}',
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

  // ─── Org Chart ────────────────────────────────────────────────────────────

  static const List<Color> _avatarColors = [
    Color(0xFF2563EB), Color(0xFF7C3AED), Color(0xFF059669),
    Color(0xFFD97706), Color(0xFFDC2626), Color(0xFF0891B2),
    Color(0xFFDB2777), Color(0xFF65A30D), Color(0xFF9333EA),
  ];

  Widget _buildOrgChart(List<Employee> employees) {
    if (employees.isEmpty) {
      return const Center(child: Text('No hierarchy data available.'));
    }

    final ids = employees.map((e) => e.id).toSet();

    // 1. Identify ALL owners
    final owners = employees.where((e) =>
        (e.managerId == null || e.managerId == 0) && e.role == 'admin').toList();

    // 2. Build manager→children map
    final Map<int?, List<Employee>> childrenOf = {};
    final Set<int> ownerIds = owners.map((o) => o.id).toSet();

    for (final e in employees) {
      if (ownerIds.contains(e.id)) continue;

      int? effectiveManagerId = e.managerId;

      // Attach to owner group (-1) if they have no manager, or their manager is an owner, or their manager is invalid
      if (owners.isNotEmpty &&
          (effectiveManagerId == null ||
              effectiveManagerId == 0 ||
              ownerIds.contains(effectiveManagerId) ||
              !ids.contains(effectiveManagerId))) {
        effectiveManagerId = -1;
      }

      childrenOf.putIfAbsent(effectiveManagerId, () => []).add(e);
    }

    // 3. Define roots
    List<Employee> roots = [];
    if (owners.isEmpty) {
      roots = employees.where((e) =>
          e.managerId == null ||
          e.managerId == 0 ||
          !ids.contains(e.managerId)).toList();
    }

    if (owners.isEmpty && roots.isEmpty) {
      return const Center(child: Text('No hierarchy data available.'));
    }

    return InteractiveViewer(
      constrained: false,
      boundaryMargin: const EdgeInsets.all(64),
      minScale: 0.4,
      maxScale: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _OrgTreeWidget(
            owners: owners,
            roots: roots,
            topLevelChildren: childrenOf[-1] ?? [],
            childrenOf: childrenOf,
            avatarColors: _avatarColors,
            onTap: (emp) => Navigator.pushNamed(
              context,
              AppRoutes.employeeProfileView,
              arguments: emp,
            ),
          ),
        ),
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

// ════════════════════════════════════════════════════════════════════
// Org Tree Widget – renders a recursive top-down hierarchy
// ════════════════════════════════════════════════════════════════════

class _OrgTreeWidget extends StatelessWidget {
  final List<Employee> owners;
  final List<Employee> roots;
  final List<Employee> topLevelChildren;
  final Map<int?, List<Employee>> childrenOf;
  final List<Color> avatarColors;
  final void Function(Employee) onTap;

  const _OrgTreeWidget({
    required this.owners,
    required this.roots,
    required this.topLevelChildren,
    required this.childrenOf,
    required this.avatarColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (owners.isNotEmpty) {
      int totalOwnerDescendants = topLevelChildren.length;
      for (final c in topLevelChildren) {
        totalOwnerDescendants += _countDescendants(c.id);
      }

      final ownersRow = Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF64748B).withOpacity(0.4), width: 1.5, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFFF8FAFC),
        ),
        child: Column(
          children: [
            const Text(
              'BOARD OF DIRECTORS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Color(0xFF64748B),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: owners
                  .map((o) => _buildNodeCard(o, forcedChildCount: totalOwnerDescendants))
                  .toList(),
            ),
          ],
        ),
      );

      if (topLevelChildren.isEmpty) {
        return ownersRow;
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ownersRow,
          CustomPaint(
            size: const Size(2, 28),
            painter: _VLinePainter(),
          ),
          _buildChildrenRow(topLevelChildren, 1),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: roots.map((root) => _buildSubtree(root, 0)).toList(),
    );
  }

  Widget _buildNodeCard(Employee node, {int? forcedChildCount}) {
    final color = avatarColors[node.id % avatarColors.length];
    final initials = _initials(node.displayName);
    final childCount = forcedChildCount ?? _countDescendants(node.id);

    return GestureDetector(
      onTap: () => onTap(node),
      child: Container(
        width: 200,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // Avatar
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Name
            Text(
              node.displayName,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 3),
            // Job title
            Text(
              node.jobTitle,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 2),
            // Department chip
            Text(
              node.department.toUpperCase(),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: Color(0xFF94A3B8),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 5),
            // Employee number / ID
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.badge_outlined, size: 11, color: Color(0xFFCBD5E1)),
                const SizedBox(width: 3),
                Flexible(
                  child: Text(
                    node.employeeNumber.isNotEmpty
                        ? node.employeeNumber
                        : '#${node.id}',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFFCBD5E1),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            // Subordinate count badge
            if (childCount > 0) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$childCount',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSubtree(Employee node, int depth) {
    final children = childrenOf[node.id] ?? [];
    final nodeCard = _buildNodeCard(node);

    if (children.isEmpty) {
      return nodeCard;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        nodeCard,
        // Vertical connector from card to horizontal bar
        CustomPaint(
          size: const Size(2, 28),
          painter: _VLinePainter(),
        ),
        // Children row with connectors
        _buildChildrenRow(children, depth + 1),
      ],
    );
  }

  Widget _buildChildrenRow(List<Employee> children, int depth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(children.length, (index) {
        final isFirst = index == 0;
        final isLast = index == children.length - 1;
        final isOnly = children.length == 1;

        return CustomPaint(
          painter: _NodeConnectorPainter(
            isFirst: isFirst,
            isLast: isLast,
            isOnly: isOnly,
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: _buildSubtree(children[index], depth),
          ),
        );
      }),
    );
  }

  int _countDescendants(int id) {
    final directChildren = childrenOf[id] ?? [];
    int count = directChildren.length;
    for (final c in directChildren) {
      count += _countDescendants(c.id);
    }
    return count;
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}

// ─── Painters ────────────────────────────────────────────────────────────────

class _VLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _NodeConnectorPainter extends CustomPainter {
  final bool isFirst;
  final bool isLast;
  final bool isOnly;

  const _NodeConnectorPainter({
    required this.isFirst,
    required this.isLast,
    required this.isOnly,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;

    // Always draw a vertical drop to the child card
    canvas.drawLine(
      Offset(centerX, 0),
      Offset(centerX, 28), // Matches the padding applied in the row
      paint,
    );

    // If there's only one child, we don't need a horizontal crossbar at all
    if (isOnly) return;

    // Draw the horizontal bar piece for this specific child
    if (isFirst) {
      // First child: horizontal line from center to right edge
      canvas.drawLine(Offset(centerX, 0), Offset(size.width, 0), paint);
    } else if (isLast) {
      // Last child: horizontal line from left edge to center
      canvas.drawLine(Offset(0, 0), Offset(centerX, 0), paint);
    } else {
      // Middle child: horizontal line entirely across
      canvas.drawLine(Offset(0, 0), Offset(size.width, 0), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

