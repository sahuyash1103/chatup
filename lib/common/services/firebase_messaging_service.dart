import 'dart:developer';

import 'package:chatup/common/services/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  factory FirebaseMessagingService() => instance;
  FirebaseMessagingService._();

  static final FirebaseMessagingService instance = FirebaseMessagingService._();

  final firebaseMessaging = FirebaseMessaging.instance;

  static String? fcmToken;

  Future<void> init() async {
    log('FirebaseMessagingService init');
    await firebaseMessaging.requestPermission();
    await firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    fcmToken = await FirebaseMessaging.instance.getToken();
    log('FirebaseMessagingService fcmToken: $fcmToken');
  }

  Future<void> onTokenRefresh(void Function(String token) refreshToken) async {
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      log('onTokenRefresh: $token');
      fcmToken = token;
      refreshToken(token);
    });
  }

  Future<void> getInitialMessage() async {
    await FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        if (message != null) {
          if (message.data['_id'] != null) {
            log('getInitialMessage New Notification: ${message.data}');
          }
        }
      },
    );
  }

  Future<void> onMessage() async {
    FirebaseMessaging.onMessage.listen(
      (message) {
        if (message.notification != null) {
          NotificationService().showNotification(
            title: message.notification!.title ?? 'chatup Error:',
            body: message.notification!.body ??
                'Notification service is not working properly',
            payload: message.data['sender'] != null
                ? message.data['sender'] as String
                : 'server',
          );
        }
      },
    );
  }

  Future<void> onMessageOpenedApp() async {
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        if (message.notification != null) {
          log('onMessageOpenedApp ${message.notification!.title}');
          log('onMessageOpenedApp ${message.notification!.body}');
          log('onMessageOpenedApp message.data22 ${message.data}');
          NotificationService().showNotification(
            title: message.notification!.title ?? 'chatup Error:',
            body: message.notification!.body ??
                'Notification service is not working properly',
            payload: message.data['sender'] != null
                ? message.data['sender'] as String
                : 'server',
          );
        }
      },
    );
  }

  Future<void> onBackgroundMessage() async {
    FirebaseMessaging.onBackgroundMessage(
      (message) async {
        if (message.notification != null) {
          log('onBackgroundMessage ${message.notification!.title}');
          log('onBackgroundMessage ${message.notification!.body}');
          log('onBackgroundMessage message.data33 ${message.data}');
          NotificationService().showNotification(
            title: message.notification!.title ?? 'chatup Error:',
            body: message.notification!.body ??
                'Notification service is not working properly',
            payload: message.data['sender'] != null
                ? message.data['sender'] as String
                : 'server',
          );
        }
      },
    );
  }
}
