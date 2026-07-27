// File generated (and re-generated) by the FlutterFire CLI.
// -----------------------------------------------------------------------
// DO NOT hand-edit the values below except as a temporary placeholder.
// Run the following once you have the Firebase CLI + FlutterFire CLI
// installed, from the project root:
//
//   dart pub global activate flutterfire_cli
//   flutterfire configure --project=sanctuary-e2f50
//
// That command talks to the SAME Firebase project you already created
// (sanctuary-e2f50, the one your ESP32 uploads to) and overwrites this
// file with the real apiKey / appId / messagingSenderId for each
// platform you select (Android / iOS / Web). Until you do that, the
// app will fail to initialize Firebase.
// -----------------------------------------------------------------------

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for this platform. '
          'Run `flutterfire configure` to generate them.',
        );
    }
  }

  // TODO: replace every value below by running `flutterfire configure`.
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'REPLACE_ME',
    appId: 'REPLACE_ME',
    messagingSenderId: 'REPLACE_ME',
    projectId: 'sanctuary-e2f50',
    databaseURL: 'https://sanctuary-e2f50-default-rtdb.firebaseio.com',
    storageBucket: 'sanctuary-e2f50.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'REPLACE_ME',
    appId: 'REPLACE_ME',
    messagingSenderId: 'REPLACE_ME',
    projectId: 'sanctuary-e2f50',
    databaseURL: 'https://sanctuary-e2f50-default-rtdb.firebaseio.com',
    storageBucket: 'sanctuary-e2f50.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REPLACE_ME',
    appId: 'REPLACE_ME',
    messagingSenderId: 'REPLACE_ME',
    projectId: 'sanctuary-e2f50',
    databaseURL: 'https://sanctuary-e2f50-default-rtdb.firebaseio.com',
    storageBucket: 'sanctuary-e2f50.appspot.com',
    iosBundleId: 'com.sanctuary.app',
  );
}
