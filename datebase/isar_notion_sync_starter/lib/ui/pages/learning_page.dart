import 'package:flutter/material.dart';

class LearningPage extends StatelessWidget {
  const LearningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('单词学习')),
      body: const Center(
        child: Text('这里是单词学习页（占位）'),
      ),
    );
  }
}

