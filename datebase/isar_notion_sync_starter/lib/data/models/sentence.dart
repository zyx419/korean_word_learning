import 'package:isar/isar.dart';
import 'package:isar_notion_sync_starter/data/adapters/notion_mappers.dart';

part 'sentence.g.dart';

enum FamiliarState { familiar, unfamiliar, neutral }

@collection
class Sentence {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? notionPageId;

  @Index(unique: true, replace: true, caseSensitive: false)
  String? externalKey;

  @Index(caseSensitive: false)
  late String text;

  @Enumerated(EnumType.name)
  FamiliarState familiarState = FamiliarState.neutral;

  @Index()
  DateTime updatedAtLocal = DateTime.now();

  DateTime? updatedAtRemote;
  DateTime createdAt = DateTime.now();
  DateTime? deletedAt;

  Map<String, dynamic> toNotion() => {
    'properties': {
      'Title': { 'title': [ { 'text': { 'content': text } } ] },
      'Familiar': { 'select': { 'name': familiarState.name } },
      'Created': { 'date': { 'start': createdAt.toIso8601String() } },
      if (externalKey != null && externalKey!.isNotEmpty)
        'ExternalKey': {
          'rich_text': [
            {
              'text': {'content': externalKey}
            }
          ]
        },
    }
  };

  static Sentence fromNotion(Map<String, dynamic> page) {
    final s = Sentence();
    s.notionPageId = page['id'] as String?;
    final properties = page['properties'] as Map<String, dynamic>?;
    s.externalKey =
        readTextProperty(properties?['ExternalKey'] as Map<String, dynamic>?);
    s.text = (page['properties']?['Title']?['title']?[0]?['plain_text'] ?? '') as String;
    final fam = page['properties']?['Familiar']?['select']?['name'] as String?;
    if (fam != null) {
      s.familiarState = FamiliarState.values.firstWhere(
        (e) => e.name == fam,
        orElse: () => FamiliarState.neutral,
      );
    }
    s.updatedAtRemote = DateTime.tryParse(page['last_edited_time'] ?? '');
    final createdAt = DateTime.tryParse(page['created_time'] ?? '');
    if (createdAt != null) {
      s.createdAt = createdAt;
    }
    return s;
  }

  void ensureExternalKey() {
    externalKey ??= 'sent-${DateTime.now().microsecondsSinceEpoch}';
  }
}
