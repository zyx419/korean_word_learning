extension JsonPick on Map<String, dynamic> {
  T? pick<T>(List<String> path) {
    dynamic cur = this;
    for (final k in path) {
      if (cur is Map<String, dynamic>) {
        cur = cur[k];
      } else {
        return null;
      }
    }
    return cur as T?;
  }
}

String? readTextProperty(Map<String, dynamic>? property) {
  if (property == null) return null;

  String? readFromList(dynamic maybeList) {
    if (maybeList is List && maybeList.isNotEmpty) {
      final first = maybeList.first;
      final plain = first['plain_text'];
      if (plain is String && plain.isNotEmpty) return plain;
      final text = first['text'];
      if (text is Map<String, dynamic>) {
        final content = text['content'];
        if (content is String && content.isNotEmpty) return content;
      }
    }
    return null;
  }

  return readFromList(property['rich_text']) ?? readFromList(property['title']);
}
