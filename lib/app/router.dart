import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/splash/splash_screen.dart';
import '../features/auth/auth_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/game/game_screen.dart';
import '../features/multiplayer/multiplayer_screen.dart';
import '../features/friends/friends_screen.dart';
import '../features/chat/chat_screen.dart';
import '../features/clan/clan_screen.dart';
import '../core/services/auth_service.dart';

/// Route paths
class AppRoutes {
  AppRoutes._();
  static const splash = '/';
  static const auth = '/auth';
  static const home = '/home';
  static const profile = '/profile';
  static const game = '/game';
  static const multiplayer = '/multiplayer';
  static const friends = '/friends';
  static const chat = '/chat/:chatId';
  static const clan = '/clan';
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final isSignedIn = ref.watch(isSignedInProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final isSplash = state.matchedLocation == AppRoutes.splash;
      final isAuth = state.matchedLocation == AppRoutes.auth;

      // Stay on splash while auth state is still loading
      if (authState.isLoading) return isSplash ? null : AppRoutes.splash;

      // Redirect based on sign-in state
      if (!isSignedIn && !isAuth && !isSplash) return AppRoutes.auth;
      if (isSignedIn && (isAuth || isSplash)) return AppRoutes.home;

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.auth,
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.game,
        builder: (context, state) => const GameScreen(),
      ),
      GoRoute(
        path: AppRoutes.multiplayer,
        builder: (context, state) => const MultiplayerScreen(),
      ),
      GoRoute(
        path: AppRoutes.friends,
        builder: (context, state) => const FriendsScreen(),
      ),
      GoRoute(
        path: AppRoutes.chat,
        builder: (context, state) {
          final chatId = state.pathParameters['chatId']!;
          return ChatScreen(chatId: chatId);
        },
      ),
      GoRoute(
        path: AppRoutes.clan,
        builder: (context, state) => const ClanScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          'Page not found: ${state.error}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    ),
  );
});
