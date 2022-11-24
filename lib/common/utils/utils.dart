import 'dart:io';

import 'package:chatup/login/views/landing.dart';
import 'package:chatup/var/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
