import 'package:isar/isar.dart';
import 'package:isar_notion_sync_starter/data/adapters/notion_mappers.dart';
import 'package:isar_notion_sync_starter/data/models/sentence.dart';

part 'reading_prefs.g.dart';

@collection
class ReadingPrefs {
  static const defaultExternalKey = 'reading-prefs';

  Id id = 1;
  @Index(caseSensitive: false)
  String? notionPageId;

  @Index(unique: true, replace: true, caseSensitive: false)
  String externalKey = defaultExternalKey;
  String theme = 'light';
  int fontSize = 16;
  double lineHeight = 1.6;
  int paragraphSpacing = 8;

  @Enumerated(EnumType.name)
  FamiliarState? filterState;

  double scrollOffsetAll = 0;
  double scrollOffsetFamiliar = 0;
  double scrollOffsetUnfamiliar = 0;
  double scrollOffsetNeutral = 0;

  @Index()
  DateTime updatedAtLocal = DateTime.now();
  DateTime? updatedAtRemote;

  void ensureExternalKey() {
    if (externalKey.isEmpty) {
      externalKey = defaultExternalKey;
    }
  }

  double _safeNumber(num value, {double fallback = 0}) {
    final v = value.toDouble();
    return v.isFinite ? v : fallback;
  }

  Map<String, dynamic> toNotion({
    bool legacyThemeAsTitle = false,
    bool includeOffsets = true,
    bool includeStyle = true,
    bool includeExternalKey = true,
  }) {
    final props = <String, dynamic>{};
    if (includeStyle) {
      if (legacyThemeAsTitle) {
        props['Theme'] = {
          'title': [
            {
              'text': {'content': theme},
            }
          ]
        };
      } else {
        props['Theme'] = {'select': {'name': theme}};
      }
      props['FontSize'] = {'number': fontSize};
      props['LineHeight'] = {'number': _safeNumber(lineHeight, fallback: 1.6)};
      props['ParagraphSpacing'] = {'number': paragraphSpacing};
      props['FilterState'] = {
        'select': filterState == null
            ? null
            : {
                'name': filterState!.name,
              }
      };
    }
    if (includeOffsets) {
      props['ScrollOffsetAll'] = {'number': _safeNumber(scrollOffsetAll)};
      props['ScrollOffsetFamiliar'] = {
        'number': _safeNumber(scrollOffsetFamiliar)
      };
      props['ScrollOffsetUnfamiliar'] = {
        'number': _safeNumber(scrollOffsetUnfamiliar)
      };
      props['ScrollOffsetNeutral'] = {
        'number': _safeNumber(scrollOffsetNeutral)
      };
    }
    if (includeExternalKey) {
      props['ExternalKey'] = {
        'rich_text': [
          {
            'text': {'content': externalKey},
          }
        ]
      };
    }

    return {
      'properties': props,
    };
  }

  static ReadingPrefs fromNotion(Map<String, dynamic> page) {
    final p = ReadingPrefs();
    p.notionPageId = page['id'] as String?;
    final props = page['properties'] as Map<String, dynamic>?;
    p.theme = props?['Theme']?['select']?['name'] ??
        (props?['Theme']?['title']?[0]?['plain_text'] as String?) ??
        'light';
    p.fontSize = (props?['FontSize']?['number'] ?? 16) as int;
    final lh = (props?['LineHeight']?['number'] ?? 1.6) as num;
    p.lineHeight = lh.toDouble().isFinite ? lh.toDouble() : 1.6;
    p.paragraphSpacing =
        (props?['ParagraphSpacing']?['number'] ?? 8) as int;
    final filter = props?['FilterState']?['select']?['name'] as String?;
    if (filter != null && filter.isNotEmpty) {
      p.filterState = FamiliarState.values.firstWhere(
        (e) => e.name == filter,
        orElse: () => FamiliarState.neutral,
      );
    }
    p.scrollOffsetAll =
        ((props?['ScrollOffsetAll']?['number'] ?? 0) as num).toDouble();
    p.scrollOffsetFamiliar =
        ((props?['ScrollOffsetFamiliar']?['number'] ?? 0) as num).toDouble();
    p.scrollOffsetUnfamiliar =
        ((props?['ScrollOffsetUnfamiliar']?['number'] ?? 0) as num).toDouble();
    p.scrollOffsetNeutral =
        ((props?['ScrollOffsetNeutral']?['number'] ?? 0) as num).toDouble();
    if (!p.scrollOffsetAll.isFinite) p.scrollOffsetAll = 0;
    if (!p.scrollOffsetFamiliar.isFinite) p.scrollOffsetFamiliar = 0;
    if (!p.scrollOffsetUnfamiliar.isFinite) p.scrollOffsetUnfamiliar = 0;
    if (!p.scrollOffsetNeutral.isFinite) p.scrollOffsetNeutral = 0;
    p.externalKey =
        readTextProperty(props?['ExternalKey'] as Map<String, dynamic>?) ??
            defaultExternalKey;
    p.updatedAtRemote = DateTime.tryParse(page['last_edited_time'] ?? '');
    return p;
  }
}
