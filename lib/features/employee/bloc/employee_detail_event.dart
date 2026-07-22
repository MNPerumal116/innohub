abstract class EmployeeDetailEvent {}

class FetchEmployeeDetail extends EmployeeDetailEvent {
  final int id;
  FetchEmployeeDetail(this.id);
}

class UpdateEmployeeDetail extends EmployeeDetailEvent {
  final int id;
  final Map<String, dynamic> data;
  UpdateEmployeeDetail(this.id, this.data);
}

class DeactivateEmployee extends EmployeeDetailEvent {
  final int id;
  DeactivateEmployee(this.id);
}
