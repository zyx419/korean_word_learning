import 'package:isar/isar.dart';
import 'package:isar_notion_sync_starter/data/adapters/notion_mappers.dart';

part 'sentence.g.dart';

enum FamiliarState { familiar, unfamiliar, neutral }
enum SyncStatus { unknown, success, failed }

@collection
class Sentence {
  Id id = Isar.autoIncrement;

  @Index(caseSensitive: false)
  String? notionPageId;

  @Index(unique: true, replace: true, caseSensitive: false)
  String? externalKey;

  @Index(caseSensitive: false)
  late String text;

  @Enumerated(EnumType.name)
  FamiliarState familiarState = FamiliarState.neutral;

  @Enumerated(EnumType.name)
  SyncStatus syncStatus = SyncStatus.unknown;

  @Index()
  DateTime updatedAtLocal = DateTime.now();

  DateTime? updatedAtRemote;
  DateTime createdAt = DateTime.now();
  DateTime? deletedAt;
  String? extra;

  static int _extKeyNonce = 0;

  Map<String, dynamic> toNotion() => {
        'properties': {
          'Title': {
            'title': [
              {
                'text': {'content': text}
              }
            ]
          },
          'Familiar': {
            'rich_text': [
              {
                'text': {'content': familiarState.name}
              }
            ]
          },
          'Created': {
            'date': {'start': createdAt.toIso8601String()}
          },
          if (externalKey != null && externalKey!.isNotEmpty)
            'ExternalKey': {
              'rich_text': [
                {
                  'text': {'content': externalKey}
                }
              ]
            },
          if (extra != null && extra!.isNotEmpty)
            'Extra': {
              'rich_text': [
                {
                  'text': {'content': extra}
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
    s.text = (page['properties']?['Title']?['title']?[0]?['plain_text'] ?? '')
        as String;
    final fam =
        readTextProperty(properties?['Familiar'] as Map<String, dynamic>?) ??
            properties?['Familiar']?['select']?['name'] as String?;
    if (fam != null && fam.isNotEmpty) {
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
    s.extra = readTextProperty(properties?['Extra'] as Map<String, dynamic>?);
    s.syncStatus = SyncStatus.success;
    return s;
  }

  void ensureExternalKey() {
    if (externalKey != null && externalKey!.isNotEmpty) return;
    final ts = DateTime.now().microsecondsSinceEpoch;
    _extKeyNonce = (_extKeyNonce + 1) % 1000000;
    externalKey = 'sent-$ts-$_extKeyNonce';
  }
}
