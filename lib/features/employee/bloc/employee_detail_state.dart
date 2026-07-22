import '../model/employee_model.dart';

abstract class EmployeeDetailState {}

class EmployeeDetailInitial extends EmployeeDetailState {}

class EmployeeDetailLoading extends EmployeeDetailState {}

class EmployeeDetailLoaded extends EmployeeDetailState {
  final Employee employee;
  EmployeeDetailLoaded(this.employee);
}

class EmployeeDetailError extends EmployeeDetailState {
  final String message;
  EmployeeDetailError(this.message);
}

class EmployeeActionSuccess extends EmployeeDetailState {
  final String message;
  final Employee? updatedEmployee; // Optionally include updated data to refresh UI

  EmployeeActionSuccess(this.message, {this.updatedEmployee});
}
