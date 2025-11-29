import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

/// Minimal Notion API client used by the app.
///
/// Notes for Java devs:
/// - `http` is a lightweight client; each call builds headers and hits REST.
/// - Methods return parsed Map<String, dynamic> (akin to `Map<String, Object?>`).
class NotionApi {
  NotionApi(this.token);
  final String token;

  final String base = 'https://api.notion.com/v1';
  final String ver = '2022-06-28';

  /// Maximum number of retry attempts for rate-limited requests.
  static const int _maxRetries = 5;
  
  /// Base delay for exponential backoff (in seconds).
  static const int _baseDelaySeconds = 1;

  /// Common headers for all requests, including token and API version.
  Map<String, String> get _headers => {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
        'Notion-Version': ver,
      };

  /// Execute an HTTP request with automatic retry on rate limit (429) errors.
  /// 
  /// Implements exponential backoff with jitter. If the response includes
  /// a `Retry-After` header, uses that value; otherwise uses exponential backoff.
  Future<http.Response> _executeWithRetry(
    Future<http.Response> Function() requestFn,
  ) async {
    int attempt = 0;
    
    while (attempt < _maxRetries) {
      final response = await requestFn();
      
      // Success or non-rate-limit error: return immediately
      if (response.statusCode != 429) {
        return response;
      }
      
      // Rate limited: calculate wait time
      int waitSeconds = _baseDelaySeconds;
      
      // Try to read Retry-After header
      final retryAfter = response.headers['retry-after'];
      if (retryAfter != null) {
        final parsed = int.tryParse(retryAfter);
        if (parsed != null && parsed > 0) {
          waitSeconds = parsed;
        }
      } else {
        // Exponential backoff: 1s, 2s, 4s, 8s, 16s
        waitSeconds = _baseDelaySeconds * pow(2, attempt).toInt();
      }
      
      // Add jitter (random 0-1 second) to avoid thundering herd
      final jitter = Random().nextInt(1000);
      final waitDuration = Duration(
        seconds: waitSeconds,
        milliseconds: jitter,
      );
      
      // Wait before retrying
      await Future.delayed(waitDuration);
      attempt++;
    }
    
    // Max retries exceeded, return the last response
    return await requestFn();
  }

  /// Lightweight connectivity check. Does not create/modify data.
  /// Retrieves database metadata by id.
  Future<Map<String, dynamic>> getDatabase(String databaseId) async {
    final uri = Uri.parse('$base/databases/$databaseId');
    final res = await _executeWithRetry(() => http.get(uri, headers: _headers));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw HttpException(
      'HTTP_${res.statusCode}',
      res.body,
      statusCode: res.statusCode,
      headers: res.headers,
    );
  }

  /// Create a new page under a given database (used by sync handlers).
  Future<Map<String, dynamic>> createPage(
      String databaseId, Map<String, dynamic> body) async {
    final uri = Uri.parse('$base/pages');
    final payload = {
      'parent': {'database_id': databaseId},
      ...body
    };
    final res = await _executeWithRetry(
      () => http.post(uri, headers: _headers, body: jsonEncode(payload)),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw HttpException(
      'HTTP_${res.statusCode}',
      res.body,
      statusCode: res.statusCode,
      headers: res.headers,
    );
  }

  /// Update an existing page properties.
  Future<Map<String, dynamic>> updatePage(
      String pageId, Map<String, dynamic> body) async {
    final uri = Uri.parse('$base/pages/$pageId');
    final res = await _executeWithRetry(
      () => http.patch(uri, headers: _headers, body: jsonEncode(body)),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw HttpException(
      'HTTP_${res.statusCode}',
      res.body,
      statusCode: res.statusCode,
      headers: res.headers,
    );
  }

  /// Query a database and return all pages (handles pagination internally).
  Future<List<Map<String, dynamic>>> queryDatabase(String databaseId,
      {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$base/databases/$databaseId/query');
    final results = <Map<String, dynamic>>[];
    String? cursor;

    do {
      final payload = <String, dynamic>{...?body};
      if (cursor != null) payload['start_cursor'] = cursor;
      final res = await _executeWithRetry(
        () => http.post(uri, headers: _headers, body: jsonEncode(payload)),
      );
      if (res.statusCode < 200 || res.statusCode >= 300) {
        throw HttpException(
          'HTTP_${res.statusCode}',
          res.body,
          statusCode: res.statusCode,
          headers: res.headers,
        );
      }
      final decoded = jsonDecode(res.body) as Map<String, dynamic>;
      final items = (decoded['results'] as List?) ?? const [];
      for (final item in items) {
        if (item is Map<String, dynamic>) results.add(item);
      }
      cursor = decoded['next_cursor'] as String?;
      final hasMore = decoded['has_more'] == true;
      if (!hasMore) break;
    } while (cursor != null);

    return results;
  }
}

/// Exception carrying HTTP status code, body, and headers for debugging.
class HttpException implements Exception {
  HttpException(
    this.code,
    this.message, {
    this.statusCode,
    this.headers,
  });
  
  final String code;
  final String message;
  final int? statusCode;
  final Map<String, String>? headers;
  
  /// Returns true if this exception represents a rate limit error (429).
  bool get isRateLimited => statusCode == 429;
  
  @override
  String toString() {
    if (statusCode != null) {
      return '$code ($statusCode): $message';
    }
    return '$code: $message';
  }
}
