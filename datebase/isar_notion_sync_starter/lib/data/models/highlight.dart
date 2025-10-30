import 'package:isar/isar.dart';

part 'highlight.g.dart';

@collection
class Highlight {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? notionPageId;

  @Index()
  late int sentenceLocalId;

  String? sentenceNotionPageId;

  @Index(composite: [CompositeIndex('end')])
  late int start;
  late int end;

  @Index(caseSensitive: false)
  String color = 'yellow';

  String? note;

  @Index()
  DateTime updatedAtLocal = DateTime.now();
  DateTime? updatedAtRemote;

  @Index()
  DateTime? deletedAt;

  Map<String, dynamic> toNotion(String? sentenceRemoteId) => {
    'properties': {
      'Sentence': {
        'relation': sentenceRemoteId == null ? [] : [{'id': sentenceRemoteId}]
      },
      'RangeStart': {'number': start},
      'RangeEnd': {'number': end},
      'Color': {'select': {'name': color}},
      if (note != null) 'Note': {'rich_text': [{'text': {'content': note}}]},
    }
  };

  static Highlight fromNotion(Map<String, dynamic> page) {
    final h = Highlight();
    h.notionPageId = page['id'] as String?;
    final rel = page['properties']?['Sentence']?['relation'];
    if (rel is List && rel.isNotEmpty) {
      h.sentenceNotionPageId = rel[0]?['id'] as String?;
    }
    h.start = (page['properties']?['RangeStart']?['number'] ?? 0) as int;
    h.end = (page['properties']?['RangeEnd']?['number'] ?? 0) as int;
    h.color = (page['properties']?['Color']?['select']?['name'] ?? 'yellow') as String;
    h.note = page['properties']?['Note']?['rich_text']?[0]?['plain_text'] as String?;
    h.updatedAtRemote = DateTime.tryParse(page['last_edited_time'] ?? '');
    return h;
  }
}
