import 'package:isar/isar.dart';
import 'package:isar_notion_sync_starter/data/models/highlight.dart';
import 'package:isar_notion_sync_starter/data/models/sentence.dart';
import 'package:isar_notion_sync_starter/sync/notion_push_service.dart';
import 'package:isar_notion_sync_starter/sync/sync_scheduler.dart';

class NotionRetrySyncHandler implements SyncHandler {
  NotionRetrySyncHandler(this._isar);

  final Isar _isar;
  late final NotionPushService _push = NotionPushService(_isar);

  @override
  Future<SyncResult> handle(SyncJob job) async {
    final localId = int.tryParse(job.entityLocalKey);
    if (localId == null) {
      return const SyncResult.err('BAD_KEY', '无效的本地 ID');
    }
    switch (job.entityType) {
      case 'highlight':
        return _handleHighlight(job, localId);
      case 'sentence':
        return _handleSentence(job, localId);
      default:
        return SyncResult.err('UNSUPPORTED', '未知类型 ${job.entityType}');
    }
  }

  Future<SyncResult> _handleHighlight(SyncJob job, int localId) async {
    final highlight = await _isar.highlights.get(localId);
    if (highlight == null) {
      return const SyncResult.err('NOT_FOUND', '高亮不存在');
    }
    final res = job.op == 'delete'
        ? await _push.deleteHighlight(highlight)
        : await _push.upsertHighlight(highlight);
    return _mapResult(res);
  }

  Future<SyncResult> _handleSentence(SyncJob job, int localId) async {
    final sentence = await _isar.sentences.get(localId);
    if (sentence == null) {
      return const SyncResult.err('NOT_FOUND', '句子不存在');
    }
    final res = await _push.deleteSentence(sentence);
    return _mapResult(res);
  }

  SyncResult _mapResult(NotionPushResult res) {
    if (res.ok || res.skipped) {
      return const SyncResult.ok();
    }
    return SyncResult.err('PUSH', res.message ?? 'Notion 同步失败');
  }
}
