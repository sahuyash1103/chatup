import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static final _notificationService = NotificationService._internal();

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

  static int notificationId = 0;

  NotificationDetails? notificationDetails;

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

    notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );
  }

  void onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) {}

  void onDidReceiveNotificationResponse(
    NotificationResponse? notificationResponse,
  ) {}

  void onDidReceiveBackgroundNotificationResponse(
    NotificationResponse? notificationResponse,
  ) {}

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
