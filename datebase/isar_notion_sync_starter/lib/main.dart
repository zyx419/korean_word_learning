import 'package:flutter/material.dart';
import 'data/local/isar_service.dart';

final isarService = IsarService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await isarService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(child: Text('Isar + Notion Sync Starter')),
      ),
    );
  }
}
