import 'package:flutter/material.dart';

/// App color palette – dark mode with neon cyan accents
class AppColors {
  AppColors._();

  // Backgrounds
  static const Color background = Color(0xFF0A0A0F);
  static const Color surface = Color(0xFF12121A);
  static const Color surfaceVariant = Color(0xFF1A1A26);
  static const Color card = Color(0xFF1E1E2E);

  // Neon accents
  static const Color accent = Color(0xFF00F5FF);       // Neon cyan
  static const Color accentPurple = Color(0xFFBF00FF); // Neon purple
  static const Color accentGreen = Color(0xFF00FF7F);  // Neon green
  static const Color accentRed = Color(0xFFFF0040);    // Neon red

  // Text
  static const Color textPrimary = Color(0xFFE8E8F0);
  static const Color textSecondary = Color(0xFF8888AA);
  static const Color textDisabled = Color(0xFF44445A);

  // Borders
  static const Color border = Color(0xFF2A2A3E);
  static const Color borderAccent = Color(0xFF00F5FF40);

  // Tetromino colors (guideline)
  static const Color tetrominoI = Color(0xFF00F5FF); // Cyan
  static const Color tetrominoO = Color(0xFFFFD700); // Yellow
  static const Color tetrominoT = Color(0xFFBF00FF); // Purple
  static const Color tetrominoS = Color(0xFF00FF7F); // Green
  static const Color tetrominoZ = Color(0xFFFF0040); // Red
  static const Color tetrominoJ = Color(0xFF0040FF); // Blue
  static const Color tetrominoL = Color(0xFFFF8C00); // Orange
  static const Color ghost = Color(0x3300F5FF);       // Ghost piece overlay

  // Status colors
  static const Color online = Color(0xFF00FF7F);
  static const Color offline = Color(0xFF44445A);
  static const Color inGame = Color(0xFFFFD700);

  // Gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0A0A0F), Color(0xFF0D0D18)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF00F5FF), Color(0xFFBF00FF)],
  );
}
