
import 'package:chatup/chating/data/enums/message_enums.dart';
import 'package:chatup/chating/views/chating_view.dart';
import 'package:chatup/common/services/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class FirebaseMessagingService {
  factory FirebaseMessagingService() => instance;
  FirebaseMessagingService._();

  static final FirebaseMessagingService instance = FirebaseMessagingService._();

  final firebaseMessaging = FirebaseMessaging.instance;

  static String? fcmToken;

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
          if (message.data['sender'] != null) {
            Navigator.of(context).pushNamed(
              ChatingView.routeName,
              arguments: {
                'name': message.data['name'],
                'profilePic': message.data['senderProfilePic'],
                'uid': message.data['senderId'],
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
          showNotification(message);
        }
      },
    );
  }

  Future<void> onMessageOpenedApp() async {
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        if (message.notification != null) {
          showNotification(message);
        }
      },
    );
  }

  Future<void> onBackgroundMessage() async {
    FirebaseMessaging.onBackgroundMessage(
      (message) async {
        if (message.notification != null) {
          showNotification(message);
        }
      },
    );
  }
}

void showNotification(RemoteMessage message) {
  var body = message.notification!.body ??
      'Notification service is not working properly';
  if (message.data['messageType'] != null) {
    body = getBody(message.data['messageType'] as MessageEnum) ?? body;
  }

  NotificationService().showNotification(
    title: message.notification!.title ?? 'chatup Error:',
    body: body,
    payload: message.data['sender'] != null
        ? message.data['sender'] as String
        : 'server',
  );
}

String? getBody(MessageEnum messageType) {
  switch (messageType) {
    case MessageEnum.image:
      return '📷 Photo';
    case MessageEnum.video:
      return '📸 Video';
    case MessageEnum.audio:
      return '🎵 Audio';
    case MessageEnum.gif:
      return 'GIF';
    case MessageEnum.file:
      return '📁 File';
    case MessageEnum.sticker:
      return '🎁 Sticker';
    case MessageEnum.location:
      return '📍 Location';
    case MessageEnum.contact:
      return '📞 Contact';
    case MessageEnum.text:
      return null;
  }
}
