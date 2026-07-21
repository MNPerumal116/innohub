import '../../../core/network/api_client.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/storage/token_storage.dart';
import '../model/login_model.dart';

/// Data layer for the login feature.
///
/// Responsibilities:
///  • Call POST /auth/login
///  • Persist returned tokens via [TokenStorage]
///  • Expose [refreshToken] for manual refresh (the [ApiClient] also handles
///    automatic silent refresh on 401, but this can be called explicitly).
class LoginRepo {
  LoginRepo._();
  static final LoginRepo instance = LoginRepo._();

  final ApiClient _apiClient = ApiClient.instance;
  final TokenStorage _storage = TokenStorage.instance;

  // ── Login ───────────────────────────────────────────────────────────────────

  /// Authenticates the user and stores all tokens.
  /// Throws [ApiException] on failure.
  Future<LoginResponse> login(LoginRequest request, {bool rememberMe = false}) async {
    final json = await _apiClient.post(
      ApiConstants.login,
      request.toJson(),
      requiresAuth: false, // no token needed for login itself
    );

    final response = LoginResponse.fromJson(json);

    // Persist tokens immediately after successful login
    await _storage.saveTokens(
      authToken:    response.authToken,
      refreshToken: response.refreshToken,
      sessionId:    response.sessionId,
      username:     response.username,
      role:         response.role,
      rememberMe:   rememberMe,
    );

    return response;
  }

  // ── Refresh token ───────────────────────────────────────────────────────────

  /// Explicitly refreshes the auth token using the stored session_id and
  /// refresh_token. Updates storage on success.
  /// Throws [ApiException] on failure.
  Future<LoginResponse> refreshToken() async {
    final sessionId    = await _storage.getSessionId();
    final refreshTkn   = await _storage.getRefreshToken();

    if (sessionId == null || refreshTkn == null) {
      throw const ApiException(
        message: 'No session found. Please log in again.',
        statusCode: 401,
      );
    }

    final json = await _apiClient.post(
      ApiConstants.refreshToken,
      {
        'session_id':     sessionId,
        'refresh_token':  refreshTkn,
      },
      requiresAuth: false,
    );

    final response = LoginResponse.fromJson(json);

    await _storage.saveTokens(
      authToken:    response.authToken,
      refreshToken: response.refreshToken,
      sessionId:    response.sessionId,
      username:     response.username,
      role:         response.role,
      rememberMe:   true, // Refreshing keeps session alive for next 30 days
    );

    return response;
  }

  // ── Logout ──────────────────────────────────────────────────────────────────

  /// Clears all stored tokens.
  Future<void> logout() => _storage.clearAll();

  // ── Auth check ──────────────────────────────────────────────────────────────

  /// Returns true if a token is already stored (used on app start).
  Future<bool> isLoggedIn() => _storage.isLoggedIn();
}
