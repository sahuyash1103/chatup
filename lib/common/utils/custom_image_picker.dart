import 'dart:io';

import 'package:chatup/common/utils/utils.dart';
import 'package:chatup/var/colors.dart';
import 'package:chatup/widgets/themed_button.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImage(BuildContext context) async {
  File? image;

  void selectImage(File? img) => image = img;
  // ignore: inference_failure_on_function_invocation
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    // enableDrag: true,
    barrierColor: backgroundColor.withOpacity(0.2),
    backgroundColor: appBarColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
    ),
    elevation: 10,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.3,
      maxChildSize: 0.4,
      minChildSize: 0.2,
      expand: false,
      snap: true,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          child: SelectImageOptionSheet(selectImage: selectImage),
        );
      },
    ),
  );
  return image;
}

Future<File?> _pickImage(
  BuildContext context,
  ImageSource source,
) async {
  File? image;
  try {
    final pickedImage = await ImagePicker().pickImage(source: source);

    if (pickedImage != null) {
      image = await _cropImage(imageFile: File(pickedImage.path));
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  return image;
}

Future<File?> _cropImage({required File imageFile}) async {
  final croppedImage = await ImageCropper().cropImage(
    sourcePath: imageFile.path,
    maxHeight: 512,
    maxWidth: 512,
    compressQuality: 80,
    aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
  );
  if (croppedImage == null) return null;
  return File(croppedImage.path);
}

class SelectImageOptionSheet extends StatelessWidget {
  const SelectImageOptionSheet({super.key, required this.selectImage});

  final void Function(File? img) selectImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: appBarColor,
      padding: const EdgeInsets.all(20),
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -35,
            child: Container(
              width: 50,
              height: 6,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.5),
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              ThemedButton(
                onPressed: () {
                  _pickImage(context, ImageSource.gallery).then((img) {
                    if (img != null) {
                      selectImage(img);
                      Navigator.of(context).pop();
                    }
                  });
                },
                icon: const Icon(Icons.image),
                text: 'Browse Gallery',
              ),
              const SizedBox(
                height: 10,
              ),
              const Center(
                child: Text(
                  'OR',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ThemedButton(
                onPressed: () {
                  _pickImage(context, ImageSource.camera).then((img) {
                    if (img != null) {
                      selectImage(img);
                      Navigator.of(context).pop();
                    }
                  });
                },
                icon: const Icon(Icons.camera_alt_outlined),
                text: 'Use a Camera',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
