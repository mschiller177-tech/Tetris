import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Placeholder – full implementation in Step 6
class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('FRIENDS')),
      body: const Center(
        child: Text(
          'Friends system coming in Step 6',
          style: TextStyle(color: AppColors.textSecondary, fontFamily: 'Orbitron'),
        ),
      ),
    );
  }
}
