// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC_0lWkqO-YwMxZIxqw1tapIAOPL_lFO8Q',
    appId: '1:151445648706:android:818ee3b593dc8a8eee04db',
    messagingSenderId: '151445648706',
    projectId: 'safe-city-c98f2',
    storageBucket: 'safe-city-c98f2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAeQ67jbhbh0wtOAA2yycMIarpFWs61bc4',
    appId: '1:151445648706:ios:a5c0d258d0e162e0ee04db',
    messagingSenderId: '151445648706',
    projectId: 'safe-city-c98f2',
    storageBucket: 'safe-city-c98f2.appspot.com',
    androidClientId: '151445648706-d5jatk1cm8jjpg52dc8cc3k6hk3lived.apps.googleusercontent.com',
    iosClientId: '151445648706-d2oepmhb9b7gvr9fil21u3e48fg4kn6k.apps.googleusercontent.com',
    iosBundleId: 'com.ikaro.FixCity',
  );
}