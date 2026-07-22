/// Central place for API constants.
/// Change [baseUrl] whenever the backend host changes.
class ApiConstants {
  ApiConstants._();

  // ── Base ────────────────────────────────────────────────────────────────────
  static const String baseUrl = 'https://innohub-hrms-platform.onrender.com';

  // ── Auth endpoints ──────────────────────────────────────────────────────────
  static const String login = '$baseUrl/auth/login';
  static const String refreshToken = '$baseUrl/auth/refresh-token';
  static const String employees = '$baseUrl/employees';
  static String employeeDetail(int id) => '$baseUrl/employees/$id';
  static String employeeDeactivate(int id) => '$baseUrl/employees/$id/deactivate';

  // ── Common headers ──────────────────────────────────────────────────────────
  static Map<String, String> get jsonHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Returns headers with a Bearer [token] attached.
  static Map<String, String> authHeaders(String token) => {
    ...jsonHeaders,
    'Authorization': 'Bearer $token',
  };
}
