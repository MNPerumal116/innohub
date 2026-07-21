import 'package:equatable/equatable.dart';
import '../model/login_model.dart';

/// Base state for LoginBloc.
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

/// Initial state, before any action is taken.
class LoginInitial extends LoginState {
  const LoginInitial();
}

/// State when the login API call is in progress.
class LoginLoading extends LoginState {
  const LoginLoading();
}

/// State when login is successful.
class LoginSuccess extends LoginState {
  final LoginResponse response;

  const LoginSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

/// State when login or token refresh fails.
class LoginFailure extends LoginState {
  final String error;

  const LoginFailure(this.error);

  @override
  List<Object?> get props => [error];
}

/// State when token refresh is in progress.
class LoginTokenRefreshLoading extends LoginState {
  const LoginTokenRefreshLoading();
}

/// State when token refresh is successful.
class LoginTokenRefreshSuccess extends LoginState {
  final LoginResponse response;

  const LoginTokenRefreshSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

/// State indicating the user is already authenticated (used on app start).
class LoginAuthenticated extends LoginState {
  const LoginAuthenticated();
}

/// State indicating the user is not authenticated (used on app start).
class LoginUnauthenticated extends LoginState {
  const LoginUnauthenticated();
}
