import 'package:isar/isar.dart';

part 'notion_binding.g.dart';

@collection
class NotionDatabaseBinding {
  Id id = 1;
  String rawUrl = '';
  String databaseId = '';
  String databaseName = '';
  String? workspace;
  DateTime boundAt = DateTime.now();
}
