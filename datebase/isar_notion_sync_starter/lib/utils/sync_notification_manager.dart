import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Handles showing or hiding the OS-level notification that mirrors
/// the sync queue progress. Keeping an ongoing notification helps the
/// scheduler stay alive on Android when the app is backgrounded.
class SyncNotificationManager {
  SyncNotificationManager._();

  static final SyncNotificationManager instance = SyncNotificationManager._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const int _notificationId = 32001;
  static const String _channelId = 'sync_queue_progress';
  static const String _channelName = '同步队列进度';
  static const String _channelDescription = '展示同步队列进度，方便管理与保活';

  Future<void> ensureInitialized() async {
    if (_initialized) return;

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwin = DarwinInitializationSettings();
    const settings =
        InitializationSettings(android: android, iOS: darwin, macOS: darwin);
    await _plugin.initialize(settings);

    if (_isAndroid) {
      final androidImpl = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      await androidImpl?.createNotificationChannel(
        const AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: _channelDescription,
          importance: Importance.low,
          playSound: false,
          enableVibration: false,
          showBadge: false,
        ),
      );
      await androidImpl?.requestNotificationsPermission();
    }

    _initialized = true;
  }

  Future<void> showProgress({
    required int total,
    required int remainingActive,
    required int pending,
    required int syncing,
    required int failed,
  }) async {
    await ensureInitialized();
    if (total <= 0 || remainingActive <= 0) {
      await cancel();
      return;
    }

    final completed = (total - remainingActive).clamp(0, total);

    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      onlyAlertOnce: true,
      showProgress: true,
      maxProgress: total,
      progress: completed,
      playSound: false,
      enableVibration: false,
      ticker: '同步队列进度更新',
    );

    final remaining = remainingActive;
    final body = '待处理 $pending · 进行中 $syncing · 失败累计 $failed · 剩余 $remaining';

    await _plugin.show(
      _notificationId,
      '同步队列 $completed/$total',
      body,
      NotificationDetails(android: androidDetails),
    );
  }

  Future<void> cancel() async {
    if (!_initialized) return;
    await _plugin.cancel(_notificationId);
  }
}

bool get _isAndroid =>
    !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
