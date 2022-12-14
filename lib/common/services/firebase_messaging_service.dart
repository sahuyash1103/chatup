import 'package:chatup/chating/views/chating_view.dart';
import 'package:chatup/common/services/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class FirebaseMessagingService {
  factory FirebaseMessagingService() => instance;
  factory FirebaseMessagingService.of(BuildContext context) {
    instance.context = context;
    return instance;
  }
  FirebaseMessagingService._();

  static final FirebaseMessagingService instance = FirebaseMessagingService._();

  final firebaseMessaging = FirebaseMessaging.instance;

  static String? fcmToken;
  BuildContext? context;

  Future<void> init() async {
    await firebaseMessaging.requestPermission();
    await firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    fcmToken = await FirebaseMessaging.instance.getToken();
  }

  Future<void> onTokenRefresh(void Function(String token) refreshToken) async {
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      fcmToken = token;
      refreshToken(token);
    });
  }

  Future<void> getInitialMessage(BuildContext context) async {
    await FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        if (message != null) {
          if (message.data['senderId'] != null) {
            Navigator.pushNamed(
              context,
              ChatingView.routeName,
              arguments: {
                'name': message.data['senderName'] as String,
                'profilePic': message.data['senderProfilePic'] as String,
                'uid': message.data['senderId'] as String,
              },
            );
          }
        }
      },
    );
  }

  Future<void> onMessage() async {
    FirebaseMessaging.onMessage.listen(
      (message) {
        if (message.notification != null) {
          showNotification(message, context: context);
        }
      },
    );
  }

  Future<void> onMessageOpenedApp() async {
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        if (message.notification != null) {
          showNotification(message, context: context);
        }
      },
    );
  }

  Future<void> onBackgroundMessage() async {
    FirebaseMessaging.onBackgroundMessage(
      (message) async {
        if (message.notification != null) {
          showNotification(message, context: context);
        }
      },
    );
  }
}
