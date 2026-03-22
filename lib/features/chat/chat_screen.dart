import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Placeholder – full implementation in Step 7
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.chatId});

  final String chatId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('CHAT')),
      body: Center(
        child: Text(
          'Chat ($chatId) coming in Step 7',
          style: const TextStyle(color: AppColors.textSecondary, fontFamily: 'Orbitron'),
        ),
      ),
    );
  }
}
