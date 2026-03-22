import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/auth_service.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _pulseController;
  late Animation<double> _logoFade;
  late Animation<double> _logoScale;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Logo entrance animation
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0, 0.6, curve: Curves.easeOut),
      ),
    );

    _logoScale = Tween<double>(begin: 0.6, end: 1).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0, 0.6, curve: Curves.elasticOut),
      ),
    );

    // Pulsing glow animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _logoController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch auth state – router redirect handles navigation
    ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),

              // ── Logo ──────────────────────────────────────────────
              AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _logoFade.value,
                    child: Transform.scale(
                      scale: _logoScale.value,
                      child: child,
                    ),
                  );
                },
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent
                                .withOpacity(_pulseAnimation.value * 0.5),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: child,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.accent,
                        width: 2,
                      ),
                      gradient: const RadialGradient(
                        colors: [
                          Color(0xFF1A1A2E),
                          Color(0xFF0A0A0F),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(28),
                    child: const _TetrisLogoIcon(),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ── App Name ──────────────────────────────────────────
              AnimatedBuilder(
                animation: _logoFade,
                builder: (context, _) {
                  return Opacity(
                    opacity: _logoFade.value,
                    child: Column(
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) =>
                              AppColors.accentGradient.createShader(bounds),
                          child: const Text(
                            'TETRIS',
                            style: TextStyle(
                              fontFamily: 'Orbitron',
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 8,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'MULTIPLAYER',
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 14,
                            letterSpacing: 6,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const Spacer(flex: 2),

              // ── Loading Indicator ─────────────────────────────────
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, _) {
                  return Opacity(
                    opacity: _pulseAnimation.value,
                    child: Column(
                      children: [
                        const _ShimmerDots(),
                        const SizedBox(height: 12),
                        Text(
                          'LOADING...',
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 10,
                            letterSpacing: 4,
                            color: AppColors.textSecondary
                                .withOpacity(_pulseAnimation.value),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom Tetris logo composed of colored blocks
class _TetrisLogoIcon extends StatelessWidget {
  const _TetrisLogoIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TetrisPainter(),
    );
  }
}

class _TetrisPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const gap = 1.5;
    final cellSize = (size.width - gap * 3) / 4;

    // Draw an L-tetromino shape in the logo
    final positions = [
      [0, 0], [0, 1], [0, 2], [1, 2], // L-shape (rotated)
      [2, 0], [2, 1], [3, 0], [3, 1], // O-shape
      [1, 0], // I connector
    ];

    final colors = [
      AppColors.tetrominoL,
      AppColors.tetrominoL,
      AppColors.tetrominoL,
      AppColors.tetrominoL,
      AppColors.tetrominoO,
      AppColors.tetrominoO,
      AppColors.tetrominoO,
      AppColors.tetrominoO,
      AppColors.tetrominoI,
    ];

    for (var i = 0; i < positions.length; i++) {
      final col = positions[i][0];
      final row = positions[i][1];
      final paint = Paint()..color = colors[i];
      final glowPaint = Paint()
        ..color = colors[i].withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 4);

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          col * (cellSize + gap),
          row * (cellSize + gap),
          cellSize,
          cellSize,
        ),
        const Radius.circular(3),
      );

      canvas.drawRRect(rect, glowPaint);
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Three animated shimmer dots as a loading indicator
class _ShimmerDots extends StatefulWidget {
  const _ShimmerDots();

  @override
  State<_ShimmerDots> createState() => _ShimmerDotsState();
}

class _ShimmerDotsState extends State<_ShimmerDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final progress = (_controller.value - i * 0.2).clamp(0.0, 1.0);
            final opacity = progress < 0.5 ? progress * 2 : 2 - progress * 2;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Opacity(
                opacity: opacity.clamp(0.2, 1.0),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accent,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.6),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
