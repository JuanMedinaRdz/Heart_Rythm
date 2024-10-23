import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hearth_rythm/firebase_options.dart';

class FirebaseService {
  static Future<void> initializeFirebase({required FirebaseOptions options}) async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      debugPrint('Firebase inicializado correctamente');
    } catch (e) {
      debugPrint('Error al inicializar Firebase: $e');
    }
  }
}
