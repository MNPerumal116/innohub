import '../../../core/network/api_client.dart';
import '../../../core/network/api_constants.dart';
import '../model/employee_model.dart';

class EmployeeRepo {
  EmployeeRepo._();
  static final EmployeeRepo instance = EmployeeRepo._();

  final ApiClient _apiClient = ApiClient.instance;

  Future<List<Employee>> fetchEmployees() async {
    final json = await _apiClient.get(
      ApiConstants.employees,
      requiresAuth: true,
    );

    final response = EmployeeListResponse.fromJson(json);
    return response.data;
  }

  Future<Employee> fetchEmployeeById(int id) async {
    final json = await _apiClient.get(
      ApiConstants.employeeDetail(id),
      requiresAuth: true,
    );

    // The single employee fetch might return data in a specific structure.
    // Based on user snippet, response is {"message": "...", "data": { ... }}
    return Employee.fromJson(json['data']);
  }

  Future<Employee> updateEmployee(int id, Map<String, dynamic> data) async {
    final json = await _apiClient.patch(
      ApiConstants.employeeDetail(id),
      data,
      requiresAuth: true,
    );
    return Employee.fromJson(json['data']);
  }

  Future<void> deactivateEmployee(int id) async {
    await _apiClient.post(
      ApiConstants.employeeDeactivate(id),
      {},
      requiresAuth: true,
    );
  }
}
