import 'package:flutter/material.dart';

class SyncQueuePage extends StatelessWidget {
  const SyncQueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('同步队列')),
      body: const Center(
        child: Text('这里显示同步任务（占位）'),
      ),
    );
  }
}

