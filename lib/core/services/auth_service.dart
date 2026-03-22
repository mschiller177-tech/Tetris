import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firestore_service.dart';

/// Provider that exposes the current Firebase auth state as a stream
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

/// Provider for the current user (null if not logged in)
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).valueOrNull;
});

/// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.read(firestoreServiceProvider));
});

class AuthService {
  AuthService(this._firestoreService);

  final FirestoreService _firestoreService;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Sign in with Google and create/update Firestore user document
  Future<User?> signInWithGoogle() async {
    try {
      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User cancelled

      // Obtain auth credentials
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Create or update Firestore document on first login
        final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
        if (isNewUser) {
          await _firestoreService.createUserDocument(user);
        }
      }

      return user;
    } catch (e) {
      throw AuthException('Google Sign-In failed: $e');
    }
  }

  /// Sign out from Firebase and Google
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw AuthException('Sign-out failed: $e');
    }
  }

  /// Get the currently signed-in user
  User? get currentUser => _auth.currentUser;

  /// Check if user is signed in
  bool get isSignedIn => _auth.currentUser != null;
}

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => 'AuthException: $message';
}
