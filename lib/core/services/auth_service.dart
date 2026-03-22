import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/demo_mode.dart';
import 'firestore_service.dart';

// ── Demo mode: fake auth stream ──────────────────────────────────────────────

/// A simple notifier that simulates a signed-in state without Firebase.
final _demoSignedInProvider = StateProvider<bool>((ref) => false);

/// Unified auth-state stream:
///   - Demo mode → emits a non-null sentinel string when "logged in"
///   - Production → Firebase User stream
final authStateProvider = StreamProvider<Object?>((ref) {
  if (kDemoMode) {
    final signedIn = ref.watch(_demoSignedInProvider);
    // Emit a non-null object when signed in (the router just checks != null)
    return Stream.value(signedIn ? const _DemoUser() : null);
  }
  return FirebaseAuth.instance.authStateChanges();
});

/// Provider for the current Firebase user (null in demo mode)
final currentUserProvider = Provider<User?>((ref) {
  if (kDemoMode) return null;
  return ref.watch(authStateProvider).valueOrNull as User?;
});

/// Provider exposing whether someone is "signed in" (works in both modes)
final isSignedInProvider = Provider<bool>((ref) {
  if (kDemoMode) return ref.watch(_demoSignedInProvider);
  return ref.watch(authStateProvider).valueOrNull != null;
});

/// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref);
});

class AuthService {
  AuthService(this._ref);

  final Ref _ref;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Sign in – demo mode sets a flag, production uses Google/Firebase.
  Future<void> signInWithGoogle() async {
    if (kDemoMode) {
      // Simulate a short loading delay so the splash animation is visible
      await Future.delayed(const Duration(milliseconds: 600));
      _ref.read(_demoSignedInProvider.notifier).state = true;
      return;
    }

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential result =
          await _auth.signInWithCredential(credential);
      final user = result.user;

      if (user != null && (result.additionalUserInfo?.isNewUser ?? false)) {
        await _ref.read(firestoreServiceProvider).createUserDocument(user);
      }
    } catch (e) {
      throw AuthException('Google Sign-In failed: $e');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    if (kDemoMode) {
      _ref.read(_demoSignedInProvider.notifier).state = false;
      return;
    }
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }
}

/// Sentinel object used in demo mode to represent a signed-in user.
class _DemoUser {
  const _DemoUser();
}

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => 'AuthException: $message';
}
