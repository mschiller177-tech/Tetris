import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Placeholder – full Flame game implementation in Step 4
class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('SOLO GAME')),
      body: const Center(
        child: Text(
          'Game coming in Step 4',
          style: TextStyle(color: AppColors.textSecondary, fontFamily: 'Orbitron'),
        ),
      ),
    );
  }
}
