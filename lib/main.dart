import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:unreal_whatsapp/app/app.dart';
import 'package:unreal_whatsapp/bootstrap.dart';
import 'package:unreal_whatsapp/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await bootstrap(() => const App());
}
