import 'package:chatup/var/colors.dart';
import 'package:chatup/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';

Future<void> attetchOptions({
  required BuildContext context,
  required VoidCallback onTapImage,
  required VoidCallback onTapVideo,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    barrierColor: backgroundColor.withOpacity(0.2),
    backgroundColor: backgroundColor.withOpacity(0.2),
    elevation: 5,
    builder: (context) => AttecthOptionsCard(
      onTapImage: onTapImage,
      onTapVideo: onTapVideo,
    ),
  );
}

class AttecthOptionsCard extends StatelessWidget {
  const AttecthOptionsCard({
    super.key,
    this.onTapImage,
    this.onTapVideo,
    this.onTapLocation,
    this.onTapContact,
    this.onTapDocument,
    this.onTapAudio,
  });
  final void Function()? onTapImage;
  final void Function()? onTapVideo;
  final void Function()? onTapLocation;
  final void Function()? onTapContact;
  final void Function()? onTapDocument;
  final void Function()? onTapAudio;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: appBarColor,
      ),
      margin: const EdgeInsets.fromLTRB(5, 5, 5, 60),
      padding: const EdgeInsets.all(10),
      height: 200,
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.5,
        shrinkWrap: true,
        clipBehavior: Clip.none,
        children: [
          CustomIconButton(
            icon: Icons.image,
            text: 'Image',
            onTap: () {
              Navigator.pop(context);
              onTapImage?.call();
            },
          ),
          CustomIconButton(
            icon: Icons.video_call,
            text: 'Video',
            onTap: () {
              Navigator.pop(context);
              onTapVideo?.call();
            },
          ),
          CustomIconButton(
            icon: Icons.mic,
            text: 'Audio',
            onTap: () {
              Navigator.pop(context);
              onTapAudio?.call();
            },
          ),
          CustomIconButton(
            icon: Icons.location_on,
            text: 'Location',
            onTap: () {
              Navigator.pop(context);
              onTapLocation?.call();
            },
          ),
          CustomIconButton(
            icon: Icons.person,
            text: 'Contact',
            onTap: () {
              Navigator.pop(context);
              onTapContact?.call();
            },
          ),
          CustomIconButton(
            icon: Icons.file_copy,
            text: 'Document',
            onTap: () {
              Navigator.pop(context);
              onTapDocument?.call();
            },
          ),
        ],
      ),
    );
  }
}
