import '../../shared/models/user_model.dart';

/// Static mock data used in demo mode (no Firebase required).
class MockData {
  MockData._();

  static final UserModel currentUser = UserModel(
    uid: 'demo-uid-001',
    displayName: 'DemoPlayer',
    photoURL: null,
    email: 'demo@tetris.app',
    wins: 42,
    losses: 18,
    totalGames: 60,
    level: 7,
    xp: 6850,
    clanId: 'demo-clan',
    friends: ['friend-001', 'friend-002', 'friend-003'],
    createdAt: DateTime(2024, 1, 15),
  );

  static final List<UserModel> friends = [
    UserModel(
      uid: 'friend-001',
      displayName: 'NeonFalcon',
      photoURL: null,
      email: 'neon@tetris.app',
      wins: 88,
      losses: 22,
      totalGames: 110,
      level: 12,
      xp: 11500,
      clanId: 'demo-clan',
      friends: [],
      createdAt: DateTime(2024, 2, 1),
    ),
    UserModel(
      uid: 'friend-002',
      displayName: 'CyberBlock',
      photoURL: null,
      email: 'cyber@tetris.app',
      wins: 31,
      losses: 29,
      totalGames: 60,
      level: 5,
      xp: 4300,
      clanId: null,
      friends: [],
      createdAt: DateTime(2024, 3, 10),
    ),
    UserModel(
      uid: 'friend-003',
      displayName: 'PixelStorm',
      photoURL: null,
      email: 'pixel@tetris.app',
      wins: 65,
      losses: 35,
      totalGames: 100,
      level: 9,
      xp: 8200,
      clanId: 'demo-clan',
      friends: [],
      createdAt: DateTime(2024, 1, 20),
    ),
  ];
}
