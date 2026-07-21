import 'package:equatable/equatable.dart';

/// All events that [LoginBloc] can receive.
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered when the user taps "Sign In".
class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;
  final bool rememberMe;

  const LoginSubmitted({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  @override
  List<Object?> get props => [email, password, rememberMe];
}

/// Triggered to explicitly refresh the token (e.g., from a background check).
/// Note: [ApiClient] already handles silent 401 refresh automatically.
class LoginTokenRefreshRequested extends LoginEvent {
  const LoginTokenRefreshRequested();
}

/// Triggered when the user logs out.
class LoginLogoutRequested extends LoginEvent {
  const LoginLogoutRequested();
}

/// Triggered on app start to check if user is already authenticated.
class LoginAuthCheckRequested extends LoginEvent {
  const LoginAuthCheckRequested();
}
