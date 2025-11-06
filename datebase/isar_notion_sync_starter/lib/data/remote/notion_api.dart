import 'dart:convert';
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

  /// Common headers for all requests, including token and API version.
  Map<String, String> get _headers => {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
        'Notion-Version': ver,
      };

  /// Lightweight connectivity check. Does not create/modify data.
  /// Retrieves database metadata by id.
  Future<Map<String, dynamic>> getDatabase(String databaseId) async {
    final uri = Uri.parse('$base/databases/$databaseId');
    final res = await http.get(uri, headers: _headers);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw HttpException('HTTP_${res.statusCode}', res.body);
  }

  /// Create a new page under a given database (used by sync handlers).
  Future<Map<String, dynamic>> createPage(
      String databaseId, Map<String, dynamic> body) async {
    final uri = Uri.parse('$base/pages');
    final payload = {
      'parent': {'database_id': databaseId},
      ...body
    };
    final res =
        await http.post(uri, headers: _headers, body: jsonEncode(payload));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw HttpException('HTTP_${res.statusCode}', res.body);
  }

  /// Update an existing page properties.
  Future<Map<String, dynamic>> updatePage(
      String pageId, Map<String, dynamic> body) async {
    final uri = Uri.parse('$base/pages/$pageId');
    final res =
        await http.patch(uri, headers: _headers, body: jsonEncode(body));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw HttpException('HTTP_${res.statusCode}', res.body);
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
      final res =
          await http.post(uri, headers: _headers, body: jsonEncode(payload));
      if (res.statusCode < 200 || res.statusCode >= 300) {
        throw HttpException('HTTP_${res.statusCode}', res.body);
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

/// Simple exception carrying HTTP status code and body for debugging.
class HttpException implements Exception {
  HttpException(this.code, this.message);
  final String code;
  final String message;
  @override
  String toString() => '$code: $message';
}
