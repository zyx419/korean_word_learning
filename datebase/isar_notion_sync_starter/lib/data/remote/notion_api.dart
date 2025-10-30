import 'dart:convert';
import 'package:http/http.dart' as http;

class NotionApi {
  NotionApi(this.token);
  final String token;

  final String base = 'https://api.notion.com/v1';
  final String ver = '2022-06-28';

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json; charset=utf-8',
    'Notion-Version': ver,
  };

  Future<Map<String, dynamic>> createPage(String databaseId, Map<String, dynamic> body) async {
    final uri = Uri.parse('$base/pages');
    final payload = {'parent': {'database_id': databaseId}, ...body};
    final res = await http.post(uri, headers: _headers, body: jsonEncode(payload));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw HttpException('HTTP_${res.statusCode}', res.body);
  }

  Future<Map<String, dynamic>> updatePage(String pageId, Map<String, dynamic> body) async {
    final uri = Uri.parse('$base/pages/$pageId');
    final res = await http.patch(uri, headers: _headers, body: jsonEncode(body));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw HttpException('HTTP_${res.statusCode}', res.body);
  }
}

class HttpException implements Exception {
  HttpException(this.code, this.message);
  final String code;
  final String message;
  @override
  String toString() => '$code: $message';
}
