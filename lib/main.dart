import 'package:chatup/app/app.dart';
import 'package:chatup/bootstrap.dart';
import 'package:chatup/common/services/firebase_messaging_service.dart';
import 'package:chatup/common/services/notification_service.dart';
import 'package:chatup/firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate();
  await NotificationService().init();

  showNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    // androidProvider: AndroidProvider.debug,
  );

  await NotificationService().init();
  await FirebaseMessagingService.instance.init();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await bootstrap(() => const App());
}
