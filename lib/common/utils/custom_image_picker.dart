import 'dart:io';

import 'package:chatup/common/utils/utils.dart';
import 'package:chatup/var/colors.dart';
import 'package:chatup/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImage(BuildContext context, {bool isCroped = true}) async {
  File? image;

  void selectImage(File? img) => image = img;
  await showModalBottomSheet<void>(
    context: context,
    barrierColor: backgroundColor.withOpacity(0.2),
    backgroundColor: backgroundColor.withOpacity(0.2),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
    ),
    elevation: 10,
    builder: (context) => SelectImageOptionSheet(
      selectImage: selectImage,
      isCroped: isCroped,
    ),
  );

  return image;
}

Future<File?> _pickImage(
  BuildContext context,
  ImageSource source, {
  bool isCroped = true,
}) async {
  String? imagePath;
  try {
    final pickedImage = await ImagePicker().pickImage(source: source);

    if (pickedImage != null && isCroped) {
      imagePath = await _cropImage(imageFile: File(pickedImage.path));
    } else if (pickedImage != null) {
      imagePath = pickedImage.path;
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  if (imagePath == null) return null;
  return File(imagePath);
}

Future<String?> _cropImage({required File imageFile}) async {
  final croppedImage = await ImageCropper().cropImage(
    sourcePath: imageFile.path,
    maxHeight: 512,
    maxWidth: 512,
    compressQuality: 80,
    aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
  );
  if (croppedImage == null) return null;
  return croppedImage.path;
}

class SelectImageOptionSheet extends StatelessWidget {
  const SelectImageOptionSheet({
    super.key,
    required this.selectImage,
    this.isCroped = true,
  });

  final void Function(File? img) selectImage;
  final bool isCroped;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.fromLTRB(5, 5, 5, 60),
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: appBarColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomIconButton(
            onTap: () {
              _pickImage(context, ImageSource.gallery, isCroped: isCroped)
                  .then((img) {
                if (img != null) {
                  selectImage(img);
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
            color: Colors.grey,
            thickness: 0.5,
            indent: 10,
            endIndent: 10,
          ),
          CustomIconButton(
            onTap: () {
              _pickImage(context, ImageSource.camera, isCroped: isCroped)
                  .then((img) {
                if (img != null) {
                  selectImage(img);
                  Navigator.of(context).pop();
                }
              });
            },
            icon: Icons.camera_alt_outlined,
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
