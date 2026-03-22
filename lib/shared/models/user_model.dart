import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  const UserModel({
    required this.uid,
    required this.displayName,
    this.photoURL,
    required this.email,
    required this.wins,
    required this.losses,
    required this.totalGames,
    required this.level,
    required this.xp,
    this.clanId,
    required this.friends,
    required this.createdAt,
  });

  final String uid;
  final String displayName;
  final String? photoURL;
  final String email;
  final int wins;
  final int losses;
  final int totalGames;
  final int level;
  final int xp;
  final String? clanId;
  final List<String> friends;
  final DateTime createdAt;

  /// XP progress within the current level (0–1000)
  int get xpInCurrentLevel => xp % 1000;

  /// Win rate as a percentage (0–100)
  double get winRate => totalGames == 0 ? 0 : (wins / totalGames) * 100;

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String? ?? '',
      displayName: map['displayName'] as String? ?? 'Player',
      photoURL: map['photoURL'] as String?,
      email: map['email'] as String? ?? '',
      wins: map['wins'] as int? ?? 0,
      losses: map['losses'] as int? ?? 0,
      totalGames: map['totalGames'] as int? ?? 0,
      level: map['level'] as int? ?? 1,
      xp: map['xp'] as int? ?? 0,
      clanId: map['clanId'] as String?,
      friends: List<String>.from(map['friends'] as List? ?? []),
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(map['createdAt'] as String? ?? '') ??
              DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'displayNameLower': displayName.toLowerCase(), // For search queries
      'photoURL': photoURL,
      'email': email,
      'wins': wins,
      'losses': losses,
      'totalGames': totalGames,
      'level': level,
      'xp': xp,
      'clanId': clanId,
      'friends': friends,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  UserModel copyWith({
    String? uid,
    String? displayName,
    String? photoURL,
    String? email,
    int? wins,
    int? losses,
    int? totalGames,
    int? level,
    int? xp,
    String? clanId,
    List<String>? friends,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      email: email ?? this.email,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      totalGames: totalGames ?? this.totalGames,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      clanId: clanId ?? this.clanId,
      friends: friends ?? this.friends,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
