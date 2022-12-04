import 'package:chatup/var/colors.dart';
import 'package:chatup/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';

Future<void> attetchOptions({
  required BuildContext context,
  required VoidCallback onTapImage,
}) async {
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
    builder: (context) => AttecthOptionsCard(
      onTapImage: onTapImage,
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
        borderRadius: BorderRadius.circular(25),
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
              if (onTapImage != null) {
                onTapImage!.call();
              }
              Navigator.pop(context);
            },
          ),
          CustomIconButton(
            icon: Icons.video_call,
            text: 'Video',
            onTap: onTapVideo ?? () {},
          ),
          CustomIconButton(
            icon: Icons.location_on,
            text: 'Location',
            onTap: onTapLocation ?? () {},
          ),
          CustomIconButton(
            icon: Icons.person,
            text: 'Contact',
            onTap: onTapContact ?? () {},
          ),
          CustomIconButton(
            icon: Icons.file_copy,
            text: 'Document',
            onTap: onTapDocument ?? () {},
          ),
          CustomIconButton(
            icon: Icons.mic,
            text: 'Audio',
            onTap: onTapAudio ?? () {},
          ),
        ],
      ),
    );
  }
}
