/// Request payload for POST /auth/login
class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

/// Response model for POST /auth/login and POST /auth/refresh-token
class LoginResponse {
  final String message;
  final String sessionId;
  final String authToken;
  final String refreshToken;
  final String username;
  final String role;
  final bool mustChangePassword;

  const LoginResponse({
    required this.message,
    required this.sessionId,
    required this.authToken,
    required this.refreshToken,
    required this.username,
    required this.role,
    required this.mustChangePassword,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        message:             json['message'] as String? ?? '',
        sessionId:           json['session_id'] as String? ?? '',
        authToken:           json['auth_token'] as String? ?? '',
        refreshToken:        json['refresh_token'] as String? ?? '',
        username:            json['username'] as String? ?? '',
        role:                json['role'] as String? ?? '',
        mustChangePassword:  json['must_change_password'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'message':              message,
        'session_id':           sessionId,
        'auth_token':           authToken,
        'refresh_token':        refreshToken,
        'username':             username,
        'role':                 role,
        'must_change_password': mustChangePassword,
      };
}
