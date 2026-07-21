import 'package:shared_preferences/shared_preferences.dart';

/// Handles read/write of all auth tokens and session data.
///
/// Uses [SharedPreferences] for persistence across app restarts.
class TokenStorage {
  TokenStorage._();
  static final TokenStorage instance = TokenStorage._();

  // ── Keys ─────────────────────────────────────────────────────────────────────
  static const _keyAuthToken    = 'auth_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keySessionId    = 'session_id';
  static const _keyUsername     = 'username';
  static const _keyRole         = 'role';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  // ── Write ─────────────────────────────────────────────────────────────────────

  /// Persists all tokens returned by login / refresh-token.
  Future<void> saveTokens({
    required String authToken,
    required String refreshToken,
    required String sessionId,
    String? username,
    String? role,
  }) async {
    final prefs = await _prefs;
    await Future.wait([
      prefs.setString(_keyAuthToken,    authToken),
      prefs.setString(_keyRefreshToken, refreshToken),
      prefs.setString(_keySessionId,    sessionId),
      if (username != null) prefs.setString(_keyUsername, username),
      if (role     != null) prefs.setString(_keyRole,     role),
    ]);
  }

  /// Removes all stored credentials (called on logout).
  Future<void> clearAll() async {
    final prefs = await _prefs;
    await Future.wait([
      prefs.remove(_keyAuthToken),
      prefs.remove(_keyRefreshToken),
      prefs.remove(_keySessionId),
      prefs.remove(_keyUsername),
      prefs.remove(_keyRole),
    ]);
  }

  // ── Read ──────────────────────────────────────────────────────────────────────

  Future<String?> getAuthToken()    async => (await _prefs).getString(_keyAuthToken);
  Future<String?> getRefreshToken() async => (await _prefs).getString(_keyRefreshToken);
  Future<String?> getSessionId()    async => (await _prefs).getString(_keySessionId);
  Future<String?> getUsername()     async => (await _prefs).getString(_keyUsername);
  Future<String?> getRole()         async => (await _prefs).getString(_keyRole);

  /// Returns true if an auth token is stored (user is considered logged in).
  Future<bool> isLoggedIn() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }
}
