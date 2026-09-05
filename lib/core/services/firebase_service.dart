import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../firebase_options.dart';

class FirebaseService {
  static bool isInitialized = false;

  static bool get isReady =>
      isInitialized && Firebase.apps.isNotEmpty;

  static Future<void> initialize() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      if (!kIsWeb && DefaultFirebaseOptions.googleWebClientId.isNotEmpty) {
        await GoogleSignIn.instance.initialize(
          serverClientId: DefaultFirebaseOptions.googleWebClientId,
        );
      } else if (!kIsWeb) {
        await GoogleSignIn.instance.initialize();
      }
      isInitialized = true;
    } catch (e, st) {
      debugPrint('Firebase initialization failed: $e\n$st');
      isInitialized = false;
    }
  }
}
