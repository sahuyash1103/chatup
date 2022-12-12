import 'dart:io';

import 'package:chatup/common/utils/utils.dart';
import 'package:chatup/var/colors.dart';
import 'package:chatup/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickVideo(BuildContext context) async {
  File? video;

  void selectVideo(File? vid) => video = vid;
  await showModalBottomSheet<void>(
    context: context,
    barrierColor: backgroundColor.withOpacity(0.2),
    backgroundColor: backgroundColor.withOpacity(0.2),
    elevation: 10,
    builder: (context) => SelectVideoOptionSheet(
      selectVideo: selectVideo,
    ),
  );

  return video;
}

Future<File?> _pickVideo(
  BuildContext context,
  ImageSource source,
) async {
  String? videoPath;
  try {
    final pickedVideo = await ImagePicker().pickVideo(source: source);

    if (pickedVideo != null) {
      videoPath = pickedVideo.path;
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  if (videoPath == null) return null;
  return File(videoPath);
}

class SelectVideoOptionSheet extends StatelessWidget {
  const SelectVideoOptionSheet({
    super.key,
    required this.selectVideo,
  });

  final void Function(File? vid) selectVideo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.fromLTRB(5, 5, 5, 60),
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: appBarColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomIconButton(
            onTap: () {
              _pickVideo(context, ImageSource.gallery).then((video) {
                if (video != null) {
                  selectVideo(video);
                  Navigator.of(context).pop();
                }
              });
            },
            icon: Icons.image,
            text: 'Browse Gallery',
            width: 150,
            fontSize: 14,
            iconSize: 20,
          ),
          const VerticalDivider(
            color: Color.fromARGB(75, 255, 255, 255),
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          CustomIconButton(
            onTap: () {
              _pickVideo(context, ImageSource.camera).then((video) {
                if (video != null) {
                  selectVideo(video);
                  Navigator.of(context).pop();
                }
              });
            },
            icon: Icons.video_camera_back_outlined,
            text: 'Use Camera',
            width: 150,
            fontSize: 14,
            iconSize: 20,
          ),
        ],
      ),
    );
  }
}
