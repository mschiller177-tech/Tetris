import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final realtimeServiceProvider = Provider<RealtimeService>((ref) {
  return RealtimeService();
});

class RealtimeService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  // ─── Online Presence ───────────────────────────────────────────────────────

  /// Set user online status in Realtime DB, auto-remove on disconnect
  Future<void> setOnline(String uid) async {
    final ref = _db.ref('onlineStatus/$uid');
    await ref.set({
      'online': true,
      'lastSeen': ServerValue.timestamp,
    });
    // Auto-remove on disconnect
    await ref.onDisconnect().update({
      'online': false,
      'lastSeen': ServerValue.timestamp,
    });
  }

  /// Set user offline
  Future<void> setOffline(String uid) async {
    await _db.ref('onlineStatus/$uid').update({
      'online': false,
      'lastSeen': ServerValue.timestamp,
    });
  }

  /// Stream online status of a user
  Stream<bool> onlineStatusStream(String uid) {
    return _db.ref('onlineStatus/$uid/online').onValue.map(
          (event) => event.snapshot.value as bool? ?? false,
        );
  }

  // ─── Match State ──────────────────────────────────────────────────────────

  /// Create a new match in Realtime DB
  Future<void> createMatch(String matchId, Map<String, dynamic> data) async {
    await _db.ref('matches/$matchId').set(data);
  }

  /// Update match state (e.g. board, score)
  Future<void> updateMatch(String matchId, Map<String, dynamic> data) async {
    await _db.ref('matches/$matchId').update(data);
  }

  /// Stream match state for real-time sync
  Stream<Map<String, dynamic>> matchStream(String matchId) {
    return _db.ref('matches/$matchId').onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null) return <String, dynamic>{};
      return Map<String, dynamic>.from(data as Map);
    });
  }

  /// Remove a match after it ends
  Future<void> deleteMatch(String matchId) async {
    await _db.ref('matches/$matchId').remove();
  }

  // ─── Matchmaking Queue ────────────────────────────────────────────────────

  /// Add player to matchmaking queue
  Future<void> joinQueue(String uid, int level) async {
    await _db.ref('matchmaking/$uid').set({
      'uid': uid,
      'level': level,
      'joinedAt': ServerValue.timestamp,
    });
    // Auto-remove from queue on disconnect
    await _db.ref('matchmaking/$uid').onDisconnect().remove();
  }

  /// Remove player from queue
  Future<void> leaveQueue(String uid) async {
    await _db.ref('matchmaking/$uid').remove();
  }

  /// Stream matchmaking queue to find opponents
  Stream<Map<String, dynamic>> queueStream() {
    return _db.ref('matchmaking').onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null) return <String, dynamic>{};
      return Map<String, dynamic>.from(data as Map);
    });
  }

  // ─── Chat ─────────────────────────────────────────────────────────────────

  /// Send a chat message
  Future<void> sendMessage(
    String chatId, {
    required String senderId,
    required String text,
  }) async {
    final ref = _db.ref('chats/$chatId/messages').push();
    await ref.set({
      'senderId': senderId,
      'text': text,
      'timestamp': ServerValue.timestamp,
      'read': false,
    });
  }

  /// Stream messages for a chat
  Stream<List<Map<String, dynamic>>> messagesStream(String chatId) {
    return _db
        .ref('chats/$chatId/messages')
        .orderByChild('timestamp')
        .limitToLast(100)
        .onValue
        .map((event) {
      final data = event.snapshot.value;
      if (data == null) return <Map<String, dynamic>>[];
      final map = Map<String, dynamic>.from(data as Map);
      return map.entries.map((e) {
        final msg = Map<String, dynamic>.from(e.value as Map);
        msg['id'] = e.key;
        return msg;
      }).toList()
        ..sort((a, b) =>
            (a['timestamp'] as int).compareTo(b['timestamp'] as int));
    });
  }

  /// Mark a message as read
  Future<void> markAsRead(String chatId, String messageId) async {
    await _db.ref('chats/$chatId/messages/$messageId/read').set(true);
  }
}
