import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:isar_notion_sync_starter/data/local/isar_service.dart';
import 'package:isar_notion_sync_starter/ui/pages/welcome_page.dart';
import 'package:isar_notion_sync_starter/ui/pages/learning_page.dart';
import 'package:isar_notion_sync_starter/ui/pages/settings_page.dart';
import 'package:isar_notion_sync_starter/ui/pages/sync_queue_page.dart';

final isarService = IsarService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  // Initialize Isar in background to avoid blocking the first frame.
  Future.microtask(() async {
    try {
      await isarService.init();
      if (kDebugMode) debugPrint('Isar initialized');
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
