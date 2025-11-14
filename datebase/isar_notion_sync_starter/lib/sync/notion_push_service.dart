import 'dart:async';

import 'package:isar/isar.dart';
import 'package:isar_notion_sync_starter/data/models/highlight.dart';
import 'package:isar_notion_sync_starter/data/models/notion_auth.dart';
import 'package:isar_notion_sync_starter/data/models/notion_binding.dart';
import 'package:isar_notion_sync_starter/data/models/sentence.dart';
import 'package:isar_notion_sync_starter/data/remote/notion_api.dart';
import 'package:isar_notion_sync_starter/sync/sync_scheduler.dart';
import 'package:isar_notion_sync_starter/utils/app_logger.dart';

/// Pushes local mutations (highlight updates, sentence deletions, etc.) to Notion.
class NotionPushService {
  NotionPushService(this._isar, {SyncScheduler? scheduler})
      : _scheduler = scheduler;

  final Isar _isar;
  final AppLogger _logger = AppLogger.instance;
  final SyncScheduler? _scheduler;

  Future<NotionPushResult> upsertHighlight(Highlight highlight) async {
    final ctx = await _loadContext();
    if (ctx == null) {
      return const NotionPushResult.error('未配置 Notion token，无法同步高亮。');
    }
    final dbId = ctx.highlightsDbId;
    if (dbId == null || dbId.isEmpty) {
      return const NotionPushResult.error('未绑定高亮数据库，无法同步。');
    }
    final isCreate = highlight.notionPageId == null;
    try {
      final generatedKey =
          highlight.externalKey == null || highlight.externalKey!.isEmpty;
      if (generatedKey) {
        highlight.ensureExternalKey();
      }
      final payload = highlight.toNotion();
      _logger.debug('Pushing highlight to Notion',
          data: {'id': highlight.id, 'body': payload});
      final resp = isCreate
          ? await ctx.api.createPage(dbId, payload)
          : await ctx.api.updatePage(highlight.notionPageId!, payload);
      final remoteId = resp['id'] as String? ?? highlight.notionPageId;
      final remoteEditedAt = DateTime.tryParse(resp['last_edited_time'] ?? '');
      await _isar.writeTxn(() async {
        final local = await _isar.highlights.get(highlight.id);
        if (local == null) return;
        if (remoteId != null) local.notionPageId = remoteId;
        if ((local.externalKey == null || local.externalKey!.isEmpty) &&
            highlight.externalKey != null) {
          local.externalKey = highlight.externalKey;
        }
        local.updatedAtRemote = remoteEditedAt;
        await _isar.highlights.put(local);
      });
      _logger.info('Pushed highlight ${highlight.id} to Notion',
          data: {'op': isCreate ? 'create' : 'update', 'remoteId': remoteId});
      return const NotionPushResult.success();
    } catch (e, st) {
      _logger.error('Failed to push highlight ${highlight.id}',
          error: e, stackTrace: st);
      await _enqueueFailure(
        entityType: 'highlight',
        op: isCreate ? 'create' : 'update',
        localKey: '${highlight.id}',
        remoteId: highlight.notionPageId,
        payload: {
          'externalKey': highlight.externalKey,
          'sentenceExternalKey': highlight.sentenceExternalKey,
          'color': highlight.color,
          'start': highlight.start,
          'end': highlight.end,
        },
        error: e,
        status: 'failed',
        errorCode: 'PUSH',
        errorMessage: '$e',
      );
      return NotionPushResult.error('同步高亮到 Notion 失败：$e');
    }
  }

  Future<NotionPushResult> deleteHighlight(Highlight highlight) async {
    if (highlight.notionPageId == null) {
      return const NotionPushResult.skipped();
    }
    final ctx = await _loadContext();
    if (ctx == null) {
      return const NotionPushResult.error('未配置 Notion token，无法同步高亮删除。');
    }
    try {
      final resp =
          await ctx.api.updatePage(highlight.notionPageId!, {'archived': true});
      final remoteEditedAt = DateTime.tryParse(resp['last_edited_time'] ?? '');
      await _isar.writeTxn(() async {
        final local = await _isar.highlights.get(highlight.id);
        if (local == null) return;
        local.updatedAtRemote = remoteEditedAt;
        await _isar.highlights.put(local);
      });
      _logger.info('Archived highlight ${highlight.id} in Notion',
          data: {'remoteId': highlight.notionPageId});
      return const NotionPushResult.success();
    } catch (e, st) {
      _logger.error('Failed to delete highlight ${highlight.id} remotely',
          error: e, stackTrace: st);
      await _enqueueFailure(
        entityType: 'highlight',
        op: 'delete',
        localKey: '${highlight.id}',
        remoteId: highlight.notionPageId,
        payload: {
          'externalKey': highlight.externalKey,
          'sentenceExternalKey': highlight.sentenceExternalKey,
        },
        error: e,
        status: 'failed',
        errorCode: 'PUSH',
        errorMessage: '$e',
      );
      return NotionPushResult.error('删除高亮时同步 Notion 失败：$e');
    }
  }

  Future<NotionPushResult> deleteSentence(Sentence sentence) async {
    if (sentence.notionPageId == null) {
      return const NotionPushResult.skipped();
    }
    final ctx = await _loadContext();
    if (ctx == null) {
      return const NotionPushResult.error('未配置 Notion token，无法同步句子删除。');
    }
    try {
      final resp =
          await ctx.api.updatePage(sentence.notionPageId!, {'archived': true});
      final remoteEditedAt = DateTime.tryParse(resp['last_edited_time'] ?? '');
      final local = await _isar.sentences.get(sentence.id);
      if (local != null) {
        local.updatedAtRemote = remoteEditedAt;
        await _isar.writeTxn(() async {
          await _isar.sentences.put(local);
        });
      }
      _logger.info('Archived sentence ${sentence.id} in Notion',
          data: {'remoteId': sentence.notionPageId});
      return const NotionPushResult.success();
    } catch (e, st) {
      _logger.error('Failed to delete sentence ${sentence.id} remotely',
          error: e, stackTrace: st);
      await _enqueueFailure(
        entityType: 'sentence',
        op: 'delete',
        localKey: '${sentence.id}',
        remoteId: sentence.notionPageId,
        payload: {
          'externalKey': sentence.externalKey,
          'text': sentence.text,
        },
        error: e,
        status: 'failed',
        errorCode: 'PUSH',
        errorMessage: '$e',
      );
      return NotionPushResult.error('删除句子时同步 Notion 失败：$e');
    }
  }

  Future<NotionPushResult> upsertSentence(Sentence sentence) async {
    final ctx = await _loadContext();
    if (ctx == null) {
      return const NotionPushResult.error('未配置 Notion token，无法同步句子。');
    }
    final dbId = ctx.sentencesDbId;
    if (dbId == null || dbId.isEmpty) {
      return const NotionPushResult.error('未绑定句子数据库，无法同步。');
    }
    sentence.ensureExternalKey();
    final isCreate = sentence.notionPageId == null;
    final payload = sentence.toNotion();
    try {
      final resp = isCreate
          ? await ctx.api.createPage(dbId, payload)
          : await ctx.api.updatePage(sentence.notionPageId!, payload);
      final remoteId = resp['id'] as String? ?? sentence.notionPageId;
      final remoteEditedAt = DateTime.tryParse(resp['last_edited_time'] ?? '');
      final local = await _isar.sentences.get(sentence.id);
      if (local != null) {
        if (remoteId != null) local.notionPageId = remoteId;
        local.updatedAtRemote = remoteEditedAt;
        await _isar.writeTxn(() async {
          await _isar.sentences.put(local);
        });
      }
      _logger.info('Pushed sentence ${sentence.id} to Notion',
          data: {'op': isCreate ? 'create' : 'update', 'remoteId': remoteId});
      return const NotionPushResult.success();
    } catch (e, st) {
      _logger.error('Failed to push sentence ${sentence.id}',
          error: e, stackTrace: st);
      await _enqueueFailure(
        entityType: 'sentence',
        op: isCreate ? 'create' : 'update',
        localKey: '${sentence.id}',
        remoteId: sentence.notionPageId,
        payload: {
          'externalKey': sentence.externalKey,
          'text': sentence.text,
        },
        error: e,
        status: 'failed',
        errorCode: 'PUSH',
        errorMessage: '$e',
      );
      return NotionPushResult.error('同步句子到 Notion 失败：$e');
    }
  }

  Future<_NotionContext?> _loadContext() async {
    final auth = await _isar.notionAuths.get(1);
    if (auth == null || auth.token.isEmpty) return null;
    final bindings = await _isar.notionDatabaseBindings.getAll([1, 2]);
    final sentencesDb = bindings.isNotEmpty ? bindings[0] : null;
    final highlightDb = bindings.length > 1 ? bindings[1] : null;
    return _NotionContext(
      api: NotionApi(auth.token),
      sentencesDbId: _normalizeDbId(sentencesDb?.databaseId),
      highlightsDbId: _normalizeDbId(highlightDb?.databaseId),
    );
  }

  String? _normalizeDbId(String? id) => (id == null || id.isEmpty) ? null : id;

  Future<void> _enqueueFailure({
    required String entityType,
    required String op,
    required String localKey,
    required Object error,
    String? remoteId,
    Map<String, dynamic>? payload,
    String status = 'failed',
    String? errorCode,
    String? errorMessage,
  }) async {
    final scheduler = _scheduler;
    if (scheduler == null) return;
    try {
      await scheduler.enqueue(
        entityType: entityType,
        op: op,
        entityLocalKey: localKey,
        remoteId: remoteId,
        payload: {
          ...?payload,
          'lastError': '$error',
        },
        priority: 5,
        status: status,
        errorCode: errorCode,
        errorMessage: errorMessage,
      );
      unawaited(scheduler.runOnce());
    } catch (e, st) {
      _logger.error('Failed to enqueue sync job',
          error: e,
          stackTrace: st,
          data: {'entityType': entityType, 'op': op, 'localKey': localKey});
    }
  }
}

class _NotionContext {
  _NotionContext({
    required this.api,
    this.sentencesDbId,
    this.highlightsDbId,
  });
  final NotionApi api;
  final String? sentencesDbId;
  final String? highlightsDbId;
}

class NotionPushResult {
  final bool ok;
  final bool skipped;
  final String? message;

  const NotionPushResult._(this.ok, this.skipped, this.message);
  const NotionPushResult.success() : this._(true, false, null);
  const NotionPushResult.skipped([String? message])
      : this._(true, true, message);
  const NotionPushResult.error(String message) : this._(false, false, message);
}
