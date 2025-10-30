import 'package:isar/isar.dart';
import '../data/remote/notion_api.dart';
import '../data/models/sentence.dart';
import '../data/models/highlight.dart';
import '../data/local/isar_service.dart';
import 'sync_scheduler.dart';

class SentenceSyncHandler implements SyncHandler {
  SentenceSyncHandler(this.isar, this.api, this.databaseId);
  final Isar isar;
  final NotionApi api;
  final String databaseId;

  @override
  Future<SyncResult> handle(SyncJob job) async {
    try {
      final id = int.parse(job.entityLocalKey);
      final entity = await isar.sentences.get(id);
      if (entity == null) return const SyncResult.err('NOT_FOUND', 'local sentence missing');

      if (job.op == 'delete') {
        // 这里可改为 Notion archive 或直接忽略
        return const SyncResult.ok();
      }

      if (entity.notionPageId == null) {
        final resp = await api.createPage(databaseId, entity.toNotion());
        final pageId = resp['id'] as String?;
        return SyncResult.ok(newRemoteId: pageId);
      } else {
        final resp = await api.updatePage(entity.notionPageId!, entity.toNotion());
        return SyncResult.ok(remoteEditedAt: DateTime.tryParse(resp['last_edited_time'] ?? ''));
      }
    } catch (e) {
      return SyncResult.err('HTTP', '$e');
    }
  }
}
