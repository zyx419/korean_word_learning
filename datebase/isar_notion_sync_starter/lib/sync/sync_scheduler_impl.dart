import 'dart:convert';
import 'dart:async';
import 'package:isar/isar.dart';
import 'package:isar_notion_sync_starter/data/models/sync_queue_item.dart';
import 'package:isar_notion_sync_starter/sync/sync_progress_notifier.dart';
import 'package:isar_notion_sync_starter/utils/app_logger.dart';

import 'sync_scheduler.dart';

class SyncSchedulerImpl implements SyncScheduler {
  static const Duration _pollInterval = Duration(milliseconds: 300);
  static const int _batchSize = 10;

  SyncSchedulerImpl(this._isar, {SyncProgressNotifier? progressNotifier})
      : _progressNotifier = progressNotifier;
  final Isar _isar;
  final _handlers = <String, SyncHandler>{};
  bool _online = true;
  bool _running = false;
  Completer<void>? _stopCompleter;
  final AppLogger _logger = AppLogger.instance;
  final SyncProgressNotifier? _progressNotifier;

  @override
  void registerHandler(String entityType, SyncHandler handler) {
    _handlers[entityType] = handler;
  }

  @override
  Future<void> enqueue({
    required String entityType,
    required String op,
    required String entityLocalKey,
    String? remoteId,
    Map<String, dynamic>? payload,
    int priority = 0,
    String status = 'pending',
    String? errorCode,
    String? errorMessage,
  }) async {
    final item = SyncQueueItem()
      ..queueId = 'sq_${DateTime.now().microsecondsSinceEpoch}'
      ..entityType = entityType
      ..op = op
      ..entityLocalKey = entityLocalKey
      ..entityNotionPageId = remoteId
      ..payload = jsonEncode(payload ?? {})
      ..status = status
      ..priority = priority
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now()
      ..lastErrorCode = errorCode
      ..lastErrorMessage = errorMessage;

    await _isar.writeTxn(() async => await _isar.syncQueueItems.put(item));
    _logger.debug('enqueue_sync_item',
        data: {'entity': entityType, 'op': op, 'queueId': item.queueId});
    await _progressNotifier?.refresh();
  }

  @override
  void onNetworkChange(bool online) {
    _online = online;
  }

  @override
  Future<void> runOnce() async {
    if (!_online) return;
    final items = await _isar.syncQueueItems
        .filter()
        .statusEqualTo('pending')
        .sortByPriorityDesc()
        .thenByUpdatedAt()
        .limit(_batchSize)
        .findAll();
    if (items.isEmpty) {
      _logger.debug('sync_run_no_pending');
    } else {
      _logger.debug('sync_run_batch', data: {'size': items.length});
    }

    for (final it in items) {
      final handler = _handlers[it.entityType];
      if (handler == null) {
        continue;
      }
      await _isar.writeTxn(() async {
        it.status = 'syncing';
        it.updatedAt = DateTime.now();
        await _isar.syncQueueItems.put(it);
      });

      final job = SyncJob(
        it.entityType,
        it.op,
        it.entityLocalKey,
        remoteId: it.entityNotionPageId,
        payload: jsonDecode(it.payload),
      );

      try {
        final res = await handler.handle(job);
        await _isar.writeTxn(() async {
          if (res.ok) {
            it.status = 'success';
            it.lastErrorCode = null;
            it.lastErrorMessage = null;
          } else {
            final attempt = it.attempt + 1;
            final max = it.maxAttempt <= 0 ? 5 : it.maxAttempt;
            it.attempt = attempt;
            it.status = attempt >= max ? 'failed' : 'pending';
            it.lastErrorCode = res.errorCode;
            it.lastErrorMessage = res.errorMessage;
          }
          it.updatedAt = DateTime.now();
          await _isar.syncQueueItems.put(it);
        });
      } catch (e) {
        _logger.error('sync_handler_exception', error: e);
        await _isar.writeTxn(() async {
          final attempt = it.attempt + 1;
          final max = it.maxAttempt <= 0 ? 5 : it.maxAttempt;
          it.attempt = attempt;
          it.status = attempt >= max ? 'failed' : 'pending';
          it.lastErrorCode = 'RUNTIME';
          it.lastErrorMessage = '$e';
          it.updatedAt = DateTime.now();
          await _isar.syncQueueItems.put(it);
        });
      }
    }
    await _progressNotifier?.refresh();
  }

  @override
  Future<void> runContinuous() async {
    if (_running) {
      _logger.debug('sync_continuous_already_running');
      return;
    }

    _running = true;
    _stopCompleter = Completer<void>();

    try {
      _logger.debug('sync_continuous_started');
      while (_running) {
        await runOnce();
        if (!_running) break;
        
        try {
          await Future.delayed(_pollInterval);
        } catch (e) {
          // 如果在延迟期间被取消，这里可能会抛出异常
          if (!_running) break;
          rethrow;
        }
      }
    } finally {
      _running = false;
      _logger.debug('sync_continuous_stopped');
      if (!_stopCompleter!.isCompleted) {
        _stopCompleter!.complete();
      }
      _stopCompleter = null;
    }
  }

  @override
  Future<void> stop() async {
    if (!_running) {
      _logger.debug('sync_stop_not_running');
      return;
    }

    _logger.debug('sync_stop_requested');
    _running = false;

    // 等待当前的 runContinuous 循环完成
    if (_stopCompleter != null && !_stopCompleter!.isCompleted) {
      try {
        await _stopCompleter!.future.timeout(const Duration(seconds: 5));
      } catch (e) {
        _logger.warn('sync_stop_timeout',
            data: {'error': '等待同步停止超时，可能仍在处理中'});
      }
    }
  }
}
