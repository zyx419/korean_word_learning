import 'package:isar/isar.dart';
import 'package:isar_notion_sync_starter/data/models/highlight.dart';
import 'package:isar_notion_sync_starter/data/models/sentence.dart';
import 'package:isar_notion_sync_starter/sync/notion_push_service.dart';
import 'package:isar_notion_sync_starter/sync/sync_scheduler.dart';
import 'package:isar_notion_sync_starter/utils/app_logger.dart';

class NotionRetrySyncHandler implements SyncHandler {
  NotionRetrySyncHandler(this._isar);

  final Isar _isar;
  late final NotionPushService _push = NotionPushService(_isar);
  final AppLogger _logger = AppLogger.instance;

  @override
  Future<SyncResult> handle(SyncJob job) async {
    switch (job.entityType) {
      case 'highlight':
        return _handleHighlight(job, int.tryParse(job.entityLocalKey));
      case 'sentence':
        return _handleSentence(job, job.entityLocalKey);
      default:
        _logger.warn('1117-debug unsupported entity type',
            data: {'job': job, 'entityType': job.entityType});
        return SyncResult.err('UNSUPPORTED', '未知类型 ${job.entityType}');
    }
  }

  Future<SyncResult> _handleHighlight(SyncJob job, int? localId) async {
    if (localId == null) {
      _logger.warn('1117-debug invalid highlight key',
          data: {'job': job, 'key': job.entityLocalKey});
      return const SyncResult.err('BAD_KEY', '无效的本地 ID');
    }
    final highlight = await _isar.highlights.get(localId);
    if (highlight == null) {
      _logger.warn('1117-debug highlight missing locally, marking success',
          data: {'job': job, 'localId': localId});
      return const SyncResult.err('NOT_FOUND', '本地找不到对应的高亮');
    }
    final res = job.op == 'delete'
        ? await _push.deleteHighlight(highlight)
        : await _push.upsertHighlight(highlight);
    return _mapResult(res);
  }

  Future<SyncResult> _handleSentence(SyncJob job, String key) async {
    final sentence = await _findSentenceByKey(key);
    if (sentence == null) {
      _logger.warn('1117-debug sentence missing locally, marking success',
          data: {'job': job, 'key': key});
      return const SyncResult.err('NOT_FOUND', '本地找不到对应的句子');
    }
    final res = job.op == 'delete'
        ? await _push.deleteSentence(sentence)
        : await _push.upsertSentence(sentence);
    return _mapResult(res);
  }

  Future<Sentence?> _findSentenceByKey(String key) async {
    final trimmed = key.trim();
    if (trimmed.isEmpty) return null;
    final external = await _isar.sentences
        .filter()
        .externalKeyEqualTo(trimmed, caseSensitive: false)
        .findFirst();
    if (external != null) return external;
    final localId = int.tryParse(trimmed);
    if (localId != null) {
      return _isar.sentences.get(localId);
    }
    return null;
  }

  SyncResult _mapResult(NotionPushResult res) {
    if (res.ok || res.skipped) {
      return const SyncResult.ok();
    }
    return SyncResult.err('PUSH', res.message ?? 'Notion 同步失败');
  }
}
