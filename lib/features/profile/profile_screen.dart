import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/firestore_service.dart';
import '../../shared/models/user_model.dart';

/// Stream provider for the current user's Firestore document
final currentUserDocProvider = StreamProvider<UserModel?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(null);
  return ref.read(firestoreServiceProvider).userStream(user.uid);
});

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserDocProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('PROFILE'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.textSecondary),
            onPressed: () => _signOut(context, ref),
          ),
        ],
      ),
      body: userAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
        error: (e, _) => Center(
          child: Text('Error: $e',
              style: const TextStyle(color: AppColors.accentRed)),
        ),
        data: (user) {
          if (user == null) return const SizedBox.shrink();
          return _ProfileContent(user: user);
        },
      ),
      // Bottom navigation
      bottomNavigationBar: _BottomNav(currentIndex: 0),
    );
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    await ref.read(authServiceProvider).signOut();
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // ── Avatar ───────────────────────────────────────────────
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.accent, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipOval(
              child: user.photoURL != null
                  ? Image.network(
                      user.photoURL!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const _DefaultAvatar(),
                    )
                  : const _DefaultAvatar(),
            ),
          ),

          const SizedBox(height: 16),

          // ── Display name ──────────────────────────────────────────
          Text(
            user.displayName,
            style: const TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: 1.5,
            ),
          ),

          const SizedBox(height: 4),

          // ── Level badge ───────────────────────────────────────────
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.accent),
              color: AppColors.accent.withOpacity(0.1),
            ),
            child: Text(
              'LVL ${user.level}',
              style: const TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 12,
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ── XP bar ───────────────────────────────────────────────
          _XpBar(xp: user.xpInCurrentLevel),

          const SizedBox(height: 32),

          // ── Stats cards ───────────────────────────────────────────
          _StatsRow(user: user),

          const SizedBox(height: 24),

          // ── Quick actions ─────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _ActionCard(
                  icon: Icons.games,
                  label: 'SOLO',
                  subtitle: 'Practice',
                  color: AppColors.accent,
                  onTap: () => context.push(AppRoutes.game),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionCard(
                  icon: Icons.people,
                  label: 'VS',
                  subtitle: 'Multiplayer',
                  color: AppColors.accentPurple,
                  onTap: () => context.push(AppRoutes.multiplayer),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _ActionCard(
                  icon: Icons.group,
                  label: 'FRIENDS',
                  subtitle: 'Social',
                  color: AppColors.accentGreen,
                  onTap: () => context.push(AppRoutes.friends),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionCard(
                  icon: Icons.shield,
                  label: 'CLAN',
                  subtitle: user.clanId != null ? 'My Clan' : 'Join / Create',
                  color: AppColors.tetrominoO,
                  onTap: () => context.push(AppRoutes.clan),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DefaultAvatar extends StatelessWidget {
  const _DefaultAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceVariant,
      child: const Icon(Icons.person, size: 48, color: AppColors.textSecondary),
    );
  }
}

class _XpBar extends StatelessWidget {
  const _XpBar({required this.xp});

  final int xp;

  @override
  Widget build(BuildContext context) {
    final progress = xp / 1000.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'XP',
              style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 11,
                color: AppColors.textSecondary,
                letterSpacing: 2,
              ),
            ),
            Text(
              '$xp / 1000',
              style: const TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 11,
                color: AppColors.accent,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: AppColors.border,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.accent),
          ),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            value: user.wins.toString(),
            label: 'WINS',
            color: AppColors.accentGreen,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            value: user.losses.toString(),
            label: 'LOSSES',
            color: AppColors.accentRed,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            value: '${user.winRate.toStringAsFixed(0)}%',
            label: 'WIN RATE',
            color: AppColors.accent,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 9,
              color: AppColors.textSecondary,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
        color: AppColors.surface,
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textDisabled,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Orbitron',
          fontSize: 9,
          letterSpacing: 1.5,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Orbitron',
          fontSize: 9,
          letterSpacing: 1.5,
        ),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(AppRoutes.home);
              break;
            case 1:
              context.go(AppRoutes.multiplayer);
              break;
            case 2:
              context.go(AppRoutes.friends);
              break;
            case 3:
              context.go(AppRoutes.clan);
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'PROFILE'),
          BottomNavigationBarItem(
              icon: Icon(Icons.sports_esports), label: 'PLAY'),
          BottomNavigationBarItem(
              icon: Icon(Icons.group), label: 'FRIENDS'),
          BottomNavigationBarItem(icon: Icon(Icons.shield), label: 'CLAN'),
        ],
      ),
    );
  }
}
