import 'package:ecommerce/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: kIsWeb 
      ? const FirebaseOptions(
          apiKey: "AIzaSyA9ZGdMoyiecGhRcdVQk1VQiu6zR1tWIP4",
          appId: "1:235507033304:web:968b64e663e3150ec023ad",
          messagingSenderId: "235507033304",
          projectId: "kiro-4b860",
          authDomain: "kiro-4b860.firebaseapp.com",
          storageBucket: "kiro-4b860.firebasestorage.app",
          measurementId: "G-S08Z2Q51D1",
        ) 
      : null, 
  );

  runApp(const App());
}