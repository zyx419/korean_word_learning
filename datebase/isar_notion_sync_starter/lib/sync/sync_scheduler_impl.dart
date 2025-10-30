import 'dart:convert';
import 'dart:async';
import '../data/models/sync_queue_item.dart';
import '../data/local/isar_schemas.dart';
import '../data/local/isar_service.dart';
import 'sync_scheduler.dart';
import 'package:isar/isar.dart';

class SyncSchedulerImpl implements SyncScheduler {
  SyncSchedulerImpl(this._isar);
  final Isar _isar;
  final _handlers = <String, SyncHandler>{};
  bool _online = true;
  bool _running = false;

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
  }) async {
    final item = SyncQueueItem()
      ..queueId = 'sq_${DateTime.now().microsecondsSinceEpoch}'
      ..entityType = entityType
      ..op = op
      ..entityLocalKey = entityLocalKey
      ..entityNotionPageId = remoteId
      ..payload = jsonEncode(payload ?? {})
      ..status = 'pending'
      ..priority = priority
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();

    await _isar.writeTxn(() async => await _isar.syncQueueItems.put(item));
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
        .limit(10)
        .findAll();

    for (final it in items) {
      final handler = _handlers[it.entityType];
      if (handler == null) continue;
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
          } else {
            it.status = 'failed';
            it.lastErrorCode = res.errorCode;
            it.lastErrorMessage = res.errorMessage;
            it.attempt += 1;
          }
          it.updatedAt = DateTime.now();
          await _isar.syncQueueItems.put(it);
        });
      } catch (e) {
        await _isar.writeTxn(() async {
          it.status = 'failed';
          it.lastErrorCode = 'RUNTIME';
          it.lastErrorMessage = '$e';
          it.attempt += 1;
          it.updatedAt = DateTime.now();
          await _isar.syncQueueItems.put(it);
        });
      }
    }
  }

  @override
  Future<void> runContinuous() async {
    if (_running) return;
    _running = true;
    while (_running) {
      await runOnce();
      await Future.delayed(const Duration(seconds: 3));
    }
  }
}
