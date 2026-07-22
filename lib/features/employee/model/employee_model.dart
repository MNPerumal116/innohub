class EmployeeListResponse {
  final String message;
  final List<Employee> data;

  EmployeeListResponse({required this.message, required this.data});

  factory EmployeeListResponse.fromJson(Map<String, dynamic> json) {
    return EmployeeListResponse(
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => Employee.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Employee {
  final int id;
  final String employeeNumber;
  final String displayName;
  final String jobTitle;
  final String department;
  final String location;
  final int? managerId;
  final String email;
  final String role;
  final bool isActive;

  Employee({
    required this.id,
    required this.employeeNumber,
    required this.displayName,
    required this.jobTitle,
    required this.department,
    required this.location,
    this.managerId,
    required this.email,
    required this.role,
    required this.isActive,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] as int? ?? 0,
      employeeNumber: json['employee_number'] as String? ?? '',
      displayName: json['display_name'] as String? ?? '',
      jobTitle: json['job_title'] as String? ?? '',
      department: json['department'] as String? ?? '',
      location: json['location'] as String? ?? '',
      managerId: json['manager_id'] as int?,
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? false,
    );
  }
}
