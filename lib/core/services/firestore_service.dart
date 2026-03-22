import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/user_model.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection('users');

  CollectionReference<Map<String, dynamic>> get _clans =>
      _db.collection('clans');

  // ─── User ─────────────────────────────────────────────────────────────────

  /// Create a new user document in Firestore (called on first Google login)
  Future<void> createUserDocument(User firebaseUser) async {
    final doc = _users.doc(firebaseUser.uid);
    final snapshot = await doc.get();

    // Don't overwrite an existing document
    if (snapshot.exists) return;

    final userModel = UserModel(
      uid: firebaseUser.uid,
      displayName: firebaseUser.displayName ?? 'Player',
      photoURL: firebaseUser.photoURL,
      email: firebaseUser.email ?? '',
      wins: 0,
      losses: 0,
      totalGames: 0,
      level: 1,
      xp: 0,
      clanId: null,
      friends: [],
      createdAt: DateTime.now(),
    );

    await doc.set(userModel.toMap());
  }

  /// Fetch a user document by UID
  Future<UserModel?> getUser(String uid) async {
    final snapshot = await _users.doc(uid).get();
    if (!snapshot.exists) return null;
    return UserModel.fromMap(snapshot.data()!);
  }

  /// Stream a user document for real-time updates
  Stream<UserModel?> userStream(String uid) {
    return _users.doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      return UserModel.fromMap(snapshot.data()!);
    });
  }

  /// Update specific user fields
  Future<void> updateUser(String uid, Map<String, dynamic> fields) async {
    await _users.doc(uid).update(fields);
  }

  /// Increment win/loss counters and award XP after a match
  Future<void> recordMatchResult({
    required String uid,
    required bool won,
    required int xpEarned,
  }) async {
    await _users.doc(uid).update({
      if (won) 'wins': FieldValue.increment(1),
      if (!won) 'losses': FieldValue.increment(1),
      'totalGames': FieldValue.increment(1),
      'xp': FieldValue.increment(xpEarned),
    });

    // Recalculate level based on XP
    await _recalculateLevel(uid);
  }

  Future<void> _recalculateLevel(String uid) async {
    final snapshot = await _users.doc(uid).get();
    if (!snapshot.exists) return;

    final data = snapshot.data()!;
    final xp = (data['xp'] as int? ?? 0);
    final newLevel = (xp ~/ 1000) + 1; // 1000 XP per level

    await _users.doc(uid).update({'level': newLevel});
  }

  // ─── Friends ──────────────────────────────────────────────────────────────

  /// Send a friend request
  Future<void> sendFriendRequest(String fromUid, String toUid) async {
    await _users
        .doc(toUid)
        .collection('friendRequests')
        .doc(fromUid)
        .set({'status': 'pending', 'sentAt': FieldValue.serverTimestamp()});
  }

  /// Accept a friend request – adds both users to each other's friends list
  Future<void> acceptFriendRequest(String currentUid, String fromUid) async {
    final batch = _db.batch();
    final now = FieldValue.serverTimestamp();

    // Add to current user's friends
    batch.set(
      _users.doc(currentUid).collection('friends').doc(fromUid),
      {'since': now},
    );

    // Add to requester's friends
    batch.set(
      _users.doc(fromUid).collection('friends').doc(currentUid),
      {'since': now},
    );

    // Remove the request
    batch.delete(
      _users.doc(currentUid).collection('friendRequests').doc(fromUid),
    );

    await batch.commit();
  }

  /// Decline a friend request
  Future<void> declineFriendRequest(String currentUid, String fromUid) async {
    await _users
        .doc(currentUid)
        .collection('friendRequests')
        .doc(fromUid)
        .delete();
  }

  /// Stream of friends for a user
  Stream<List<String>> friendsStream(String uid) {
    return _users.doc(uid).collection('friends').snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => doc.id).toList(),
        );
  }

  // ─── Clan ─────────────────────────────────────────────────────────────────

  /// Search for a user by display name (case-insensitive prefix)
  Future<List<UserModel>> searchUsers(String query) async {
    final snapshot = await _users
        .where('displayNameLower',
            isGreaterThanOrEqualTo: query.toLowerCase())
        .where('displayNameLower',
            isLessThanOrEqualTo: '${query.toLowerCase()}\uf8ff')
        .limit(20)
        .get();

    return snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
  }
}
