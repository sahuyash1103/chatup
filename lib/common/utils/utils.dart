import 'package:chatup/chating/data/enums/message_enums.dart';
import 'package:chatup/common/services/notification_service.dart';
import 'package:chatup/login/views/landing.dart';
import 'package:chatup/var/colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: SizedBox(
        height: 18,
        child: Center(
          child: Text(
            content,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      ),
      backgroundColor: tabColor,
      // behavior: SnackBarBehavior.floating,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(10),
      // ),
      elevation: 5,
      // margin: const EdgeInsets.only(left: 10, right: 10),
      duration: const Duration(seconds: 2),
    ),
  );
}

Future<void> afterLoggedOut(BuildContext context) async {
  await Navigator.pushNamedAndRemoveUntil(
    context,
    LandingView.routeName,
    (route) => false,
  );
}

String formateDate(DateTime dateTime) {
  final now = DateTime.now();

  if (dateTime.day == now.day &&
      dateTime.month == now.month &&
      dateTime.year == now.year) {
    return 'Today';
  } else if (dateTime.day == now.day - 1 &&
      dateTime.month == now.month &&
      dateTime.year == now.year) {
    return 'Yesterday';
  } else {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}

String formateTime(DateTime dateTime) {
  return '${dateTime.hour}:${dateTime.minute}';
}

void showNotification(RemoteMessage message) {
  var body = message.notification!.body ??
      'Notification service is not working properly';
  if (message.data['messageType'] != null) {
    final messageType = message.data['messageType'] as String;
    body = getBody(messageType.toMessageEnum());
  }

  NotificationService().showNotification(
    title: message.notification!.title ?? 'chatup Error:',
    body: body,
    payload: message.data.isNotEmpty ? '${message.data}' : 'server',
  );
}

String getBody(MessageEnum messageType) {
  switch (messageType) {
    case MessageEnum.text:
      return '📝 Text';
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
  }
}
