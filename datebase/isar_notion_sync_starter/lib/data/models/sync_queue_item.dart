import 'package:isar/isar.dart';

part 'sync_queue_item.g.dart';

@collection
class SyncQueueItem {
  Id id = Isar.autoIncrement;

  @Index(caseSensitive: false)
  String queueId = '';

  @Index(caseSensitive: false)
  String entityType = ''; // sentence|highlight|pref

  String op = 'update'; // create|update|delete
  String entityLocalKey = '';
  String? entityNotionPageId;

  // JSON 字符串以便 Isar 存储，使用时自行 decode/encode
  String payload = '{}';

  @Index(caseSensitive: false)
  String status = 'pending'; // pending|syncing|success|failed|canceled|skipped

  int attempt = 0;
  int maxAttempt = 5;

  String? lastErrorCode;
  String? lastErrorMessage;
  String? lastErrorMeta; // JSON string

  @Index()
  DateTime createdAt = DateTime.now();

  @Index()
  DateTime updatedAt = DateTime.now();

  @Index()
  int priority = 0;
}
