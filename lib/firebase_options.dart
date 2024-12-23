// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD752UE2i6azcPCdLBvnp7Q4F-xpRerC44',
    appId: '1:83999343919:web:b325eb225b47e75d704dda',
    messagingSenderId: '83999343919',
    projectId: 'chat-messenger-ada4a',
    authDomain: 'chat-messenger-ada4a.firebaseapp.com',
    storageBucket: 'chat-messenger-ada4a.firebasestorage.app',
    measurementId: 'G-DLNXVHJF8N',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDcZCp3GhJZeG8JaMOL1r_DfVe82ef1wv8',
    appId: '1:83999343919:android:d2c60f2202d0c551704dda',
    messagingSenderId: '83999343919',
    projectId: 'chat-messenger-ada4a',
    storageBucket: 'chat-messenger-ada4a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCGx7dYt2yzCTPv8Vr1kR3T9nGbMphIH0g',
    appId: '1:83999343919:ios:5f18888917b44da4704dda',
    messagingSenderId: '83999343919',
    projectId: 'chat-messenger-ada4a',
    storageBucket: 'chat-messenger-ada4a.firebasestorage.app',
    iosBundleId: 'com.example.practice3',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCGx7dYt2yzCTPv8Vr1kR3T9nGbMphIH0g',
    appId: '1:83999343919:ios:5f18888917b44da4704dda',
    messagingSenderId: '83999343919',
    projectId: 'chat-messenger-ada4a',
    storageBucket: 'chat-messenger-ada4a.firebasestorage.app',
    iosBundleId: 'com.example.practice3',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD752UE2i6azcPCdLBvnp7Q4F-xpRerC44',
    appId: '1:83999343919:web:b5bddf366cd52ee9704dda',
    messagingSenderId: '83999343919',
    projectId: 'chat-messenger-ada4a',
    authDomain: 'chat-messenger-ada4a.firebaseapp.com',
    storageBucket: 'chat-messenger-ada4a.firebasestorage.app',
    measurementId: 'G-N3VPJ187CC',
  );
}
