import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:isar_notion_sync_starter/data/local/isar_service.dart';
import 'package:isar_notion_sync_starter/sync/notion_pull_service.dart';
import 'package:isar_notion_sync_starter/sync/notion_retry_sync_handler.dart';
import 'package:isar_notion_sync_starter/sync/sync_progress_notifier.dart';
import 'package:isar_notion_sync_starter/sync/sync_scheduler_impl.dart';
import 'package:isar_notion_sync_starter/ui/pages/learning_page.dart';
import 'package:isar_notion_sync_starter/ui/pages/settings_page.dart';
import 'package:isar_notion_sync_starter/ui/pages/sync_queue_page.dart';
import 'package:isar_notion_sync_starter/ui/pages/welcome_page.dart';
import 'package:isar_notion_sync_starter/utils/sync_notification_manager.dart';

/// App-wide singleton-like service for accessing the Isar database.
final isarService = IsarService();
SyncSchedulerImpl? globalSyncScheduler;
final syncNotificationManager = SyncNotificationManager.instance;

/// App entry point.
///
/// We bootstrap Flutter bindings, render the UI immediately, and then
/// initialize the database on a microtask to avoid blocking the first frame.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await syncNotificationManager.ensureInitialized();
  runApp(const MyApp());
  // Initialize Isar in background to avoid blocking the first frame.
  Future.microtask(() async {
    try {
      await isarService.init();
      await ensureGlobalSchedulerStarted();
      if (kDebugMode) debugPrint('Isar initialized');
      await NotionPullService(isarService.isar).pullAll();
    } catch (e, st) {
      debugPrint('Isar init error: $e');
      debugPrint('$st');
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Korean Word Learning',
      debugShowCheckedModeBanner: false,
      // Simple route table for demo pages.
      routes: {
        '/': (context) => const WelcomePage(),
        '/learn': (context) => const LearningPage(),
        '/settings': (context) => const SettingsPage(),
        '/sync': (context) => const SyncQueuePage(),
      },
      initialRoute: '/',
    );
  }
}

Future<void> ensureGlobalSchedulerStarted() async {
  if (globalSyncScheduler != null) return;
  await syncNotificationManager.ensureInitialized();
  final notifier =
      SyncProgressNotifier(isarService.isar, syncNotificationManager);
  final scheduler =
      SyncSchedulerImpl(isarService.isar, progressNotifier: notifier);
  final retryHandler = NotionRetrySyncHandler(isarService.isar);
  scheduler
    ..registerHandler('highlight', retryHandler)
    ..registerHandler('sentence', retryHandler);
  scheduler.runContinuous();
  globalSyncScheduler = scheduler;
}
