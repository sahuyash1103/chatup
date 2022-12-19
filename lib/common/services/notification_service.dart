import 'dart:convert';
import 'dart:developer';

import 'package:chatup/chating/data/enums/message_enums.dart';
import 'package:chatup/chating/views/chating_view.dart';
import 'package:chatup/common/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void showNotification(RemoteMessage message, {BuildContext? context}) {
  var body = message.notification!.body ??
      'Notification service is not working properly';
  if (message.data['messageType'] != null) {
    final messageType = message.data['messageType'] as String;
    body = getBody(messageType.toMessageEnum());
  }

  NotificationService.of(context).showNotification(
    title: message.notification!.title ?? 'chatup Error:',
    body: body,
    payload: message.data.isNotEmpty ? jsonEncode(message.data) : 'server',
  );
}

class NotificationService {
  factory NotificationService() {
    return _notificationService;
  }

  factory NotificationService.of(BuildContext? context) {
    _notificationService.context = context;
    return _notificationService;
  }

  NotificationService._instance();

  static final _notificationService = NotificationService._instance();

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final androidNotificationDetails = const AndroidNotificationDetails(
    '#chats',
    'Chats',
    channelDescription: 'new messages',
    importance: Importance.max,
    priority: Priority.max,
  );

  final iosNotificationDetails = const DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  NotificationDetails? notificationDetails;

  static int notificationId = 0;
  BuildContext? context;

  Future<void> init() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final initializationSettingsIOS = DarwinInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );

    notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
  }

  void onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) {
    log('onDidReceiveLocalNotification: $id, $title, $body, $payload');
  }

  void onDidReceiveNotificationResponse(
    NotificationResponse? notificationResponse,
  ) {
    try {
      log('onDidReceiveNotificationResponse');
      if (notificationResponse != null &&
          notificationResponse.payload != null &&
          context != null) {
        final payload = jsonDecode(notificationResponse.payload!);
        if (payload is Map) {
          Navigator.pushNamed(
            context!,
            ChatingView.routeName,
            arguments: {
              'name': payload['senderName'] as String,
              'profilePic': payload['senderProfilePic'] as String,
              'uid': payload['senderId'] as String,
            },
          );
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static void onDidReceiveBackgroundNotificationResponse(
    NotificationResponse? notificationResponse,
  ) {
    try {
      log('onDidReceiveBackgroundNotificationResponse');
      if (notificationResponse != null &&
          notificationResponse.payload != null &&
          _notificationService.context != null) {
        final payload = jsonDecode(notificationResponse.payload!);
        if (payload is Map) {
          log(payload['senderName'].toString());
          Navigator.pushNamed(
            _notificationService.context!,
            ChatingView.routeName,
            arguments: {
              'name': payload['senderName'] as String,
              'profilePic': payload['senderProfilePic'] as String,
              'uid': payload['senderId'] as String,
            },
          );
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void showNotification({
    required String title,
    required String body,
    required String payload,
  }) {
    flutterLocalNotificationsPlugin.show(
      notificationId++,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
