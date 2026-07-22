import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/employee_repo.dart';
import 'employee_detail_event.dart';
import 'employee_detail_state.dart';

class EmployeeDetailBloc extends Bloc<EmployeeDetailEvent, EmployeeDetailState> {
  final EmployeeRepo _repo = EmployeeRepo.instance;

  EmployeeDetailBloc() : super(EmployeeDetailInitial()) {
    on<FetchEmployeeDetail>(_onFetchDetail);
    on<UpdateEmployeeDetail>(_onUpdateDetail);
    on<DeactivateEmployee>(_onDeactivate);
  }

  Future<void> _onFetchDetail(FetchEmployeeDetail event, Emitter<EmployeeDetailState> emit) async {
    emit(EmployeeDetailLoading());
    try {
      final employee = await _repo.fetchEmployeeById(event.id);
      emit(EmployeeDetailLoaded(employee));
    } catch (e) {
      emit(EmployeeDetailError(e.toString()));
    }
  }

  Future<void> _onUpdateDetail(UpdateEmployeeDetail event, Emitter<EmployeeDetailState> emit) async {
    emit(EmployeeDetailLoading());
    try {
      final updated = await _repo.updateEmployee(event.id, event.data);
      emit(EmployeeActionSuccess('Employee updated successfully.', updatedEmployee: updated));
      emit(EmployeeDetailLoaded(updated));
    } catch (e) {
      emit(EmployeeDetailError(e.toString()));
    }
  }

  Future<void> _onDeactivate(DeactivateEmployee event, Emitter<EmployeeDetailState> emit) async {
    // We could capture the previous state to restore if it fails, or just emit loading.
    emit(EmployeeDetailLoading());
    try {
      await _repo.deactivateEmployee(event.id);
      emit(EmployeeActionSuccess('Employee deactivated successfully.'));
      // After deactivation, ideally fetch the fresh details to reflect the INACTIVE status.
      final employee = await _repo.fetchEmployeeById(event.id);
      emit(EmployeeDetailLoaded(employee));
    } catch (e) {
      emit(EmployeeDetailError(e.toString()));
    }
  }
}
