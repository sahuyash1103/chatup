import 'package:chatup/app/app.dart';
import 'package:chatup/bootstrap.dart';
import 'package:chatup/common/utils/notification_service.dart';
import 'package:chatup/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService().init();
  
  await bootstrap(() => const App());
}
