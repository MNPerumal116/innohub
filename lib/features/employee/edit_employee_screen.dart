import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/employee_detail_bloc.dart';
import 'bloc/employee_detail_event.dart';
import 'bloc/employee_detail_state.dart';
import 'model/employee_model.dart';

class EditEmployeeScreen extends StatefulWidget {
  final Employee employee;
  const EditEmployeeScreen({super.key, required this.employee});

  @override
  State<EditEmployeeScreen> createState() => _EditEmployeeScreenState();
}

class _EditEmployeeScreenState extends State<EditEmployeeScreen> {
  static const Color _primary = Color(0xFF2563EB);
  static const Color _bg = Color(0xFFF8FAFC);
  static const Color _dark = Color(0xFF1E293B);

  late TextEditingController _firstNameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _departmentCtrl;
  late TextEditingController _jobTitleCtrl;
  late TextEditingController _locationCtrl;

  @override
  void initState() {
    super.initState();
    _firstNameCtrl = TextEditingController(text: widget.employee.displayName);
    _lastNameCtrl = TextEditingController(text: "");
    _departmentCtrl = TextEditingController(text: widget.employee.department);
    _jobTitleCtrl = TextEditingController(text: widget.employee.jobTitle);
    _locationCtrl = TextEditingController(text: widget.employee.location);
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _departmentCtrl.dispose();
    _jobTitleCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final data = {
      "first_name": _firstNameCtrl.text,
      "last_name": _lastNameCtrl.text,
      "department": _departmentCtrl.text,
      "job_title": _jobTitleCtrl.text,
      "location": _locationCtrl.text,
    };
    context.read<EmployeeDetailBloc>().add(
      UpdateEmployeeDetail(widget.employee.id, data),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeDetailBloc, EmployeeDetailState>(
      listener: (context, state) {
        if (state is EmployeeActionSuccess) {
          Navigator.pop(context); // Go back to profile view after success
        }
      },
      child: Scaffold(
        backgroundColor: _bg,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.close, color: _dark),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Edit Employee',
            style: TextStyle(
              color: _dark,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              onPressed: _saveChanges,
              child: const Text(
                'SAVE',
                style: TextStyle(color: _primary, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildTextField('First Name', _firstNameCtrl),
              const SizedBox(height: 16),
              _buildTextField('Last Name', _lastNameCtrl),
              const SizedBox(height: 16),
              _buildTextField('Department', _departmentCtrl),
              const SizedBox(height: 16),
              _buildTextField('Job Title', _jobTitleCtrl),
              const SizedBox(height: 16),
              _buildTextField('Location', _locationCtrl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF475569),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: _primary),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}
