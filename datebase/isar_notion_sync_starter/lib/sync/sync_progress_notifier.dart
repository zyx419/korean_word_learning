import 'package:isar/isar.dart';

import 'package:isar_notion_sync_starter/data/models/sync_queue_item.dart';
import 'package:isar_notion_sync_starter/utils/sync_notification_manager.dart';

/// Aggregates sync queue stats and pushes them to the notification manager.
class SyncProgressNotifier {
  SyncProgressNotifier(this._isar, this._notificationManager);

  final Isar _isar;
  final SyncNotificationManager _notificationManager;
  int _batchSize = 0;
  bool _refreshing = false;

  Future<void> refresh() async {
    if (_refreshing) return;
    _refreshing = true;
    try {
      final pendingFuture =
          _isar.syncQueueItems.filter().statusEqualTo('pending').count();
      final syncingFuture =
          _isar.syncQueueItems.filter().statusEqualTo('syncing').count();
      final failedFuture =
          _isar.syncQueueItems.filter().statusEqualTo('failed').count();

      final results = await Future.wait<int>([
        pendingFuture,
        syncingFuture,
        failedFuture,
      ]);

      final pending = results[0];
      final syncing = results[1];
      final failed = results[2];
      final active = pending + syncing;

      if (active <= 0) {
        _batchSize = 0;
        await _notificationManager.cancel();
        return;
      }

      if (_batchSize == 0 || active > _batchSize) {
        _batchSize = active;
      }

      await _notificationManager.showProgress(
        total: _batchSize,
        remainingActive: active,
        pending: pending,
        syncing: syncing,
        failed: failed,
      );
    } finally {
      _refreshing = false;
    }
  }
}
