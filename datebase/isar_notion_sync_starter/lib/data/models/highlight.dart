import 'package:isar/isar.dart';
import 'package:isar_notion_sync_starter/data/adapters/notion_mappers.dart';

part 'highlight.g.dart';

@collection
class Highlight {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? notionPageId;

  @Index()
  late int sentenceLocalId;

  String? sentenceNotionPageId;
  String? sentenceExternalKey;
  @Index(unique: true, replace: true, caseSensitive: false)
  String? externalKey;

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

  Map<String, dynamic> toNotion() => {
        'properties': {
          if (externalKey != null && externalKey!.isNotEmpty)
            'ExternalKey': {
              'rich_text': [
                {
                  'text': {'content': externalKey}
                }
              ]
            },
          if (sentenceExternalKey != null && sentenceExternalKey!.isNotEmpty)
            'SentenceExternalKey': {
              'title': [
                {
                  'text': {'content': sentenceExternalKey}
                }
              ]
            },
          'RangeStart': {'number': start},
          'RangeEnd': {'number': end},
          'Color': {
            'rich_text': [
              {
                'text': {'content': color}
              }
            ]
          },
          if (note != null && note!.isNotEmpty)
            'Note': {
              'rich_text': [
                {
                  'text': {'content': note}
                }
              ]
            },
        }
      };

  static Highlight fromNotion(Map<String, dynamic> page) {
    final h = Highlight();
    h.notionPageId = page['id'] as String?;
    final properties = page['properties'] as Map<String, dynamic>?;
    h.externalKey =
        readTextProperty(properties?['ExternalKey'] as Map<String, dynamic>?);
    final rel = properties?['Sentence']?['relation'];
    if (rel is List && rel.isNotEmpty) {
      h.sentenceNotionPageId = rel[0]?['id'] as String?;
    }
    h.sentenceExternalKey = readTextProperty(
        properties?['SentenceExternalKey'] as Map<String, dynamic>?);
    h.start = (properties?['RangeStart']?['number'] ?? 0) as int;
    h.end = (properties?['RangeEnd']?['number'] ?? 0) as int;
    h.color = readTextProperty(properties?['Color'] as Map<String, dynamic>?) ??
        (properties?['Color']?['select']?['name'] ?? 'yellow') as String;
    h.note = readTextProperty(properties?['Note'] as Map<String, dynamic>?);
    h.updatedAtRemote = DateTime.tryParse(page['last_edited_time'] ?? '');
    return h;
  }

  void ensureExternalKey() {
    externalKey ??= 'hl-${DateTime.now().microsecondsSinceEpoch}';
  }
}
