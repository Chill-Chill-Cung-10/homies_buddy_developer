// File: generated from https://firebase.google.com/docs/flutter/setup?platform=ios
// This file contains the Firebase initialization options for your app.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
  show defaultTargetPlatform, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Run: `flutterfire configure` to auto-generate this file
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDBIEPk8aZUYEqIJaOG6OB8LZSTF_4vypU',
    appId: '1:959927728555:android:201d9b5e24c216aa4b7aee',
    messagingSenderId: '959927728555',
    projectId: 'amicute-43081',
    storageBucket: 'amicute-43081.firebasestorage.app',
  );

}
