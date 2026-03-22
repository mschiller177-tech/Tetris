// GENERATED FILE – replace with output from: flutterfire configure
// Run: dart pub global activate flutterfire_cli && flutterfire configure
//
// Until configured, this file contains placeholder values.
// Do NOT commit real API keys to version control.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for this platform.',
        );
    }
  }

  // ── PLACEHOLDER VALUES – replace with flutterfire configure output ─────────
  // These must be replaced before building the app.

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'REPLACE_WITH_YOUR_WEB_API_KEY',
    appId: 'REPLACE_WITH_YOUR_WEB_APP_ID',
    messagingSenderId: 'REPLACE_WITH_YOUR_SENDER_ID',
    projectId: 'REPLACE_WITH_YOUR_PROJECT_ID',
    authDomain: 'REPLACE_WITH_YOUR_PROJECT_ID.firebaseapp.com',
    storageBucket: 'REPLACE_WITH_YOUR_PROJECT_ID.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'REPLACE_WITH_YOUR_ANDROID_API_KEY',
    appId: 'REPLACE_WITH_YOUR_ANDROID_APP_ID',
    messagingSenderId: 'REPLACE_WITH_YOUR_SENDER_ID',
    projectId: 'REPLACE_WITH_YOUR_PROJECT_ID',
    storageBucket: 'REPLACE_WITH_YOUR_PROJECT_ID.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REPLACE_WITH_YOUR_IOS_API_KEY',
    appId: 'REPLACE_WITH_YOUR_IOS_APP_ID',
    messagingSenderId: 'REPLACE_WITH_YOUR_SENDER_ID',
    projectId: 'REPLACE_WITH_YOUR_PROJECT_ID',
    storageBucket: 'REPLACE_WITH_YOUR_PROJECT_ID.appspot.com',
    iosClientId: 'REPLACE_WITH_YOUR_IOS_CLIENT_ID',
    iosBundleId: 'com.yourcompany.tetrisMultiplayer',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'REPLACE_WITH_YOUR_MACOS_API_KEY',
    appId: 'REPLACE_WITH_YOUR_MACOS_APP_ID',
    messagingSenderId: 'REPLACE_WITH_YOUR_SENDER_ID',
    projectId: 'REPLACE_WITH_YOUR_PROJECT_ID',
    storageBucket: 'REPLACE_WITH_YOUR_PROJECT_ID.appspot.com',
    iosClientId: 'REPLACE_WITH_YOUR_MACOS_CLIENT_ID',
    iosBundleId: 'com.yourcompany.tetrisMultiplayer',
  );
}
