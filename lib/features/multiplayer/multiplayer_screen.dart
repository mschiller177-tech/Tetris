import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Placeholder – full implementation in Step 5
class MultiplayerScreen extends StatelessWidget {
  const MultiplayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('MULTIPLAYER')),
      body: const Center(
        child: Text(
          'Multiplayer coming in Step 5',
          style: TextStyle(color: AppColors.textSecondary, fontFamily: 'Orbitron'),
        ),
      ),
    );
  }
}
