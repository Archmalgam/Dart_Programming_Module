import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDVzrA7Uv177FVmv_EQv2i6tWiv_JcFOww",
            authDomain: "canvascast-7c86e.firebaseapp.com",
            projectId: "canvascast-7c86e",
            storageBucket: "canvascast-7c86e.firebasestorage.app",
            messagingSenderId: "443690479496",
            appId: "1:443690479496:web:ca3ced82a2a25a9da1d43d",
            measurementId: "G-GCD182R6ES"));
  } else {
    await Firebase.initializeApp();
  }
}
