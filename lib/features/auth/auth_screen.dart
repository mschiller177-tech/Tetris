import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/demo_mode.dart';
import '../../core/services/auth_service.dart';
import '../../shared/widgets/neon_button.dart';

final _isLoadingProvider = StateProvider<bool>((ref) => false);

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(_isLoadingProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration:
            const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // ── Logo ──────────────────────────────────────────────
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.accentGradient.createShader(bounds),
                  child: const Text(
                    'TETRIS',
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'MULTIPLAYER',
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 14,
                    letterSpacing: 6,
                    color: AppColors.textSecondary,
                  ),
                ),

                const Spacer(flex: 2),

                // ── Demo mode badge ────────────────────────────────────
                if (kDemoMode)
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.accentPurple.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: AppColors.accentPurple.withOpacity(0.5)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.science_outlined,
                            color: AppColors.accentPurple, size: 14),
                        SizedBox(width: 8),
                        Text(
                          'DEMO MODE AKTIV',
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 10,
                            color: AppColors.accentPurple,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),

                const Text(
                  'Compete. Dominate. Repeat.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 16,
                    color: AppColors.textSecondary,
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 48),

                // ── Sign-in button (Demo vs. Real) ────────────────────
                if (kDemoMode)
                  NeonButton(
                    label: 'APP TESTEN (DEMO)',
                    isLoading: isLoading,
                    width: double.infinity,
                    color: AppColors.accentPurple,
                    icon: const Icon(Icons.play_arrow,
                        size: 20, color: Colors.white),
                    onPressed: () => _handleSignIn(context, ref),
                  )
                else
                  NeonButton(
                    label: 'SIGN IN WITH GOOGLE',
                    isLoading: isLoading,
                    width: double.infinity,
                    icon: isLoading
                        ? null
                        : Image.asset(
                            'assets/images/google_logo.png',
                            width: 20,
                            height: 20,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.login,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                    onPressed: () => _handleSignIn(context, ref),
                  ),

                const SizedBox(height: 24),

                if (!kDemoMode)
                  const Text(
                    'By signing in you agree to our Terms of Service\nand Privacy Policy.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 10,
                      color: AppColors.textDisabled,
                      height: 1.6,
                    ),
                  ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignIn(BuildContext context, WidgetRef ref) async {
    ref.read(_isLoadingProvider.notifier).state = true;
    try {
      await ref.read(authServiceProvider).signInWithGoogle();
      // GoRouter redirect handles navigation automatically
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler: ${e.toString()}'),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    } finally {
      if (context.mounted) {
        ref.read(_isLoadingProvider.notifier).state = false;
      }
    }
  }
}
