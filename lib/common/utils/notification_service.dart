import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  factory NotificationService() {
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
    log('$id\n$title\n$body\n$payload');
  }

  void onDidReceiveNotificationResponse(
    NotificationResponse? notificationResponse,
  ) {
    log('${notificationResponse?.actionId}\n${notificationResponse?.payload}\n'
        '${notificationResponse?.input}\n${notificationResponse?.id}');
  }

  static void onDidReceiveBackgroundNotificationResponse(
    NotificationResponse? notificationResponse,
  ) {
    
  }

  void showNotification(String title, String body, String payload) {
    flutterLocalNotificationsPlugin.show(
      notificationId++,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
