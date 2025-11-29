import 'package:isar/isar.dart';

part 'notion_auth.g.dart';

@collection
class NotionAuth {
  Id id = 1;
  // Token 已迁移到安全存储 (SecureTokenStorage)
  // 不再在此模型中存储敏感信息
  String status = 'untested'; // untested|success|error
  DateTime? testedAt;
  String? errorMessage;
  DateTime? lastSyncedAt;
}
