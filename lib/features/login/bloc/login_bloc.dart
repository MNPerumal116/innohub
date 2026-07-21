import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';
import '../model/login_model.dart';
import '../repo/login_repo.dart';
import '../../../core/network/api_client.dart';

/// BLoC that manages the login flow, token refresh, and auth checks.
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepo _repo;

  LoginBloc({LoginRepo? repo})
      : _repo = repo ?? LoginRepo.instance,
        super(const LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginTokenRefreshRequested>(_onTokenRefreshRequested);
    on<LoginLogoutRequested>(_onLogoutRequested);
    on<LoginAuthCheckRequested>(_onAuthCheckRequested);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());
    try {
      final request = LoginRequest(
        email: event.email,
        password: event.password,
      );
      final response = await _repo.login(request, rememberMe: event.rememberMe);
      emit(LoginSuccess(response));
    } on ApiException catch (e) {
      emit(LoginFailure(e.message));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  Future<void> _onTokenRefreshRequested(
    LoginTokenRefreshRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginTokenRefreshLoading());
    try {
      final response = await _repo.refreshToken();
      emit(LoginTokenRefreshSuccess(response));
    } on ApiException catch (e) {
      emit(LoginFailure(e.message));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LoginLogoutRequested event,
    Emitter<LoginState> emit,
  ) async {
    await _repo.logout();
    emit(const LoginUnauthenticated());
  }

  Future<void> _onAuthCheckRequested(
    LoginAuthCheckRequested event,
    Emitter<LoginState> emit,
  ) async {
    final isLoggedIn = await _repo.isLoggedIn();
    if (isLoggedIn) {
      emit(const LoginAuthenticated());
    } else {
      emit(const LoginUnauthenticated());
    }
  }
}
