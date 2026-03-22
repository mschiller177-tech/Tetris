import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Placeholder – full implementation in Step 8
class ClanScreen extends StatelessWidget {
  const ClanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('CLAN')),
      body: const Center(
        child: Text(
          'Clan system coming in Step 8',
          style: TextStyle(color: AppColors.textSecondary, fontFamily: 'Orbitron'),
        ),
      ),
    );
  }
}
