import 'package:isar/isar.dart';

part 'sentence.g.dart';

enum FamiliarState { familiar, unfamiliar, neutral }

@collection
class Sentence {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? notionPageId;

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
    }
  };

  static Sentence fromNotion(Map<String, dynamic> page) {
    final s = Sentence();
    s.notionPageId = page['id'] as String?;
    s.text = (page['properties']?['Title']?['title']?[0]?['plain_text'] ?? '') as String;
    final fam = page['properties']?['Familiar']?['select']?['name'] as String?;
    if (fam != null) {
      s.familiarState = FamiliarState.values.firstWhere(
        (e) => e.name == fam,
        orElse: () => FamiliarState.neutral,
      );
    }
    s.updatedAtRemote = DateTime.tryParse(page['last_edited_time'] ?? '');
    return s;
  }
}
