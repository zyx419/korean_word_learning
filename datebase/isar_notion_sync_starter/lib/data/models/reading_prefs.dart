import 'package:isar/isar.dart';

part 'reading_prefs.g.dart';

@collection
class ReadingPrefs {
  Id id = 1;
  String theme = 'light';
  int fontSize = 16;
  double lineHeight = 1.6;
  int paragraphSpacing = 8;

  @Index()
  DateTime updatedAtLocal = DateTime.now();
  DateTime? updatedAtRemote;

  Map<String, dynamic> toNotion() => {
    'properties': {
      'Theme': {'select': {'name': theme}},
      'FontSize': {'number': fontSize},
      'LineHeight': {'number': lineHeight},
      'ParagraphSpacing': {'number': paragraphSpacing},
    }
  };

  static ReadingPrefs fromNotion(Map<String, dynamic> page) {
    final p = ReadingPrefs();
    p.theme = page['properties']?['Theme']?['select']?['name'] ?? 'light';
    p.fontSize = (page['properties']?['FontSize']?['number'] ?? 16) as int;
    p.lineHeight = (page['properties']?['LineHeight']?['number'] ?? 1.6).toDouble();
    p.paragraphSpacing = (page['properties']?['ParagraphSpacing']?['number'] ?? 8) as int;
    p.updatedAtRemote = DateTime.tryParse(page['last_edited_time'] ?? '');
    return p;
  }
}
