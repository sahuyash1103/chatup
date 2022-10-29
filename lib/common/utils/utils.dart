import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unreal_whatsapp/login/views/landing.dart';
import 'package:unreal_whatsapp/var/colors.dart';

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        content,
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      margin: const EdgeInsets.all(50),
      duration: const Duration(seconds: 1),
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

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  return image;
}

String formateDate(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inHours < 24) {
    return 'Today';
  } else if (difference.inDays == 1) {
    return 'Yesterday';
  } else {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}

String formateTime(DateTime dateTime) {
  return '${dateTime.hour}:${dateTime.minute}';
}
