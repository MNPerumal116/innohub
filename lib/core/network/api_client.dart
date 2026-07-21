import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'api_constants.dart';
import '../storage/token_storage.dart';

/// A thin HTTP wrapper that:
///  • Attaches the current auth token to every request.
///  • On a 401 response, silently refreshes the token once and retries.
///  • Logs every request and response to the debug console.
///  • Throws [ApiException] for non-2xx responses after retrying.
class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  final http.Client _client = http.Client();
  final TokenStorage _storage = TokenStorage.instance;

  // ── Public methods ──────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> body, {
    bool requiresAuth = true,
  }) async {
    return _executeWithRetry('POST', url, body, requiresAuth);
  }

  Future<Map<String, dynamic>> get(
    String url, {
    bool requiresAuth = true,
  }) async {
    return _executeWithRetry('GET', url, null, requiresAuth);
  }

  Future<Map<String, dynamic>> put(
    String url,
    Map<String, dynamic> body, {
    bool requiresAuth = true,
  }) async {
    return _executeWithRetry('PUT', url, body, requiresAuth);
  }

  Future<Map<String, dynamic>> delete(
    String url, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    return _executeWithRetry('DELETE', url, body, requiresAuth);
  }

  // ── Private helpers ─────────────────────────────────────────────────────────

  Future<http.Response> _rawCall(
    String method,
    String url,
    Map<String, dynamic>? body,
    bool requiresAuth,
  ) async {
    final headers = await _buildHeaders(requiresAuth);
    final uri = Uri.parse(url);
    final encodedBody = body != null ? jsonEncode(body) : null;

    _logRequest(method, url, headers, body);

    switch (method) {
      case 'GET':
        return _client.get(uri, headers: headers);
      case 'POST':
        return _client.post(uri, headers: headers, body: encodedBody);
      case 'PUT':
        return _client.put(uri, headers: headers, body: encodedBody);
      case 'DELETE':
        return encodedBody != null
            ? _client.delete(uri, headers: headers, body: encodedBody)
            : _client.delete(uri, headers: headers);
      default:
        throw ApiException(
            message: 'Unsupported HTTP method: $method', statusCode: 0);
    }
  }

  Future<Map<String, String>> _buildHeaders(bool requiresAuth) async {
    final headers = Map<String, String>.from(ApiConstants.jsonHeaders);
    if (requiresAuth) {
      final token = await _storage.getAuthToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  /// Executes the HTTP call with optional 401→refresh→retry logic.
  Future<Map<String, dynamic>> _executeWithRetry(
    String method,
    String url,
    Map<String, dynamic>? body,
    bool requiresAuth,
  ) async {
    try {
      var response = await _rawCall(method, url, body, requiresAuth);

      if (response.statusCode == 401 && requiresAuth) {
        final refreshed = await _tryRefreshToken();
        if (refreshed) {
          response = await _rawCall(method, url, body, requiresAuth);
        }
      }

      _logResponse(method, url, response);
      return _handleResponse(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      _logError(method, url, e);
      throw ApiException(
        message: _networkErrorMessage(e),
        statusCode: 0,
      );
    }
  }

  /// Calls the refresh-token endpoint silently. Returns true if successful.
  Future<bool> _tryRefreshToken() async {
    try {
      final sessionId = await _storage.getSessionId();
      final refreshToken = await _storage.getRefreshToken();
      if (sessionId == null || refreshToken == null) return false;

      final reqBody = {
        'session_id': sessionId,
        'refresh_token': refreshToken,
      };
      _logRequest('POST [REFRESH]', ApiConstants.refreshToken,
          ApiConstants.jsonHeaders, reqBody);

      final response = await _client.post(
        Uri.parse(ApiConstants.refreshToken),
        headers: ApiConstants.jsonHeaders,
        body: jsonEncode(reqBody),
      );

      _logResponse('POST [REFRESH]', ApiConstants.refreshToken, response);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        await _storage.saveTokens(
          authToken: data['auth_token'] as String,
          refreshToken: data['refresh_token'] as String,
          sessionId: data['session_id'] as String,
        );
        return true;
      }
    } catch (e) {
      _logError('POST [REFRESH]', ApiConstants.refreshToken, e);
    }
    return false;
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    Map<String, dynamic>? decoded;
    try {
      final body = jsonDecode(response.body);
      if (body is Map<String, dynamic>) decoded = body;
    } catch (_) {}

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded ?? {};
    }

    // Extract error message: check all known error key names the API may use
    final message = decoded?['detail'] as String? ??
        decoded?['message'] as String? ??
        decoded?['error'] as String? ??
        decoded?['error_description'] as String? ??
        _statusCodeMessage(response.statusCode);

    throw ApiException(message: message, statusCode: response.statusCode);
  }

  // ── Logging ─────────────────────────────────────────────────────────────────

  void _logRequest(
    String method,
    String url,
    Map<String, String> headers,
    Map<String, dynamic>? body,
  ) {
    // Truncate Authorization token for readability
    final safeHeaders = Map<String, String>.from(headers);
    if (safeHeaders.containsKey('Authorization')) {
      final token = safeHeaders['Authorization']!;
      safeHeaders['Authorization'] =
          token.length > 30 ? '${token.substring(0, 30)}…' : token;
    }

    final prettyBody = body != null
        ? const JsonEncoder.withIndent('  ').convert(body)
        : 'none';

    developer.log(
      '\n┌─────────────────────────────────────────────────\n'
      '│ ➡  REQUEST  [$method]\n'
      '│ URL     : $url\n'
      '│ HEADERS : $safeHeaders\n'
      '│ BODY    :\n'
      '$prettyBody\n'
      '└─────────────────────────────────────────────────',
      name: 'ApiClient',
    );
  }

  void _logResponse(String method, String url, http.Response response) {
    String prettyBody;
    try {
      final decoded = jsonDecode(response.body);
      prettyBody = const JsonEncoder.withIndent('  ').convert(decoded);
    } catch (_) {
      prettyBody = response.body;
    }

    final icon =
        response.statusCode >= 200 && response.statusCode < 300 ? '✅' : '❌';

    developer.log(
      '\n┌─────────────────────────────────────────────────\n'
      '│ $icon RESPONSE [$method]\n'
      '│ URL    : $url\n'
      '│ STATUS : ${response.statusCode}\n'
      '│ BODY   :\n'
      '$prettyBody\n'
      '└─────────────────────────────────────────────────',
      name: 'ApiClient',
    );
  }

  void _logError(String method, String url, Object error) {
    developer.log(
      '\n┌─────────────────────────────────────────────────\n'
      '│ 💥 NETWORK ERROR [$method]\n'
      '│ URL : $url\n'
      '│ ERR : $error\n'
      '└─────────────────────────────────────────────────',
      name: 'ApiClient',
      error: error,
    );
  }

  // ── Status code messages ──────────────────────────────────────────────────

  String _statusCodeMessage(int code) {
    switch (code) {
      case 400: return 'Bad request. Please check your input.';
      case 401: return 'Incorrect email or password.';
      case 403: return 'You do not have permission to perform this action.';
      case 404: return 'The requested resource was not found.';
      case 408: return 'The request timed out. Please try again.';
      case 422: return 'Validation error. Please check your input.';
      case 429: return 'Too many requests. Please wait and try again.';
      case 500: return 'A server error occurred. Please try again later.';
      case 502: return 'Server is temporarily unavailable. Please try again.';
      case 503: return 'Service unavailable. Please try again later.';
      default:  return 'Something went wrong (HTTP $code).';
    }
  }

  String _networkErrorMessage(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('socketexception') || msg.contains('network')) {
      return 'No internet connection. Please check your network.';
    }
    if (msg.contains('timeout') || msg.contains('timed out')) {
      return 'The request timed out. Please try again.';
    }
    return 'Network error. Please try again.';
  }
}

/// Thrown by [ApiClient] for non-2xx HTTP responses.
class ApiException implements Exception {
  final String message;
  final int statusCode;

  const ApiException({required this.message, required this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}
