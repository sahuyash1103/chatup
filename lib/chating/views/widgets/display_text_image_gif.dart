import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatup/chating/data/enums/message_enums.dart';
import 'package:chatup/chating/views/widgets/custom_video_player.dart';
import 'package:flutter/material.dart';

class DisplayTextImageGIF extends StatelessWidget {
  const DisplayTextImageGIF({
    super.key,
    required this.message,
    required this.type,
  });
  final String message;
  final MessageEnum type;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case MessageEnum.text:
        return Padding(
          padding: const EdgeInsets.only(left: 5, top: 2),
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        );
      case MessageEnum.image:
        return CachedNetworkImage(
          imageUrl: message,
          imageBuilder: (context, imageProvider) {
            return Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      case MessageEnum.video:
        return CustomVideoPlayer(
          videoUrl: message,
        );
      case MessageEnum.gif:
        return CachedNetworkImage(
          imageUrl: message,
          imageBuilder: (context, imageProvider) {
            return Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      case MessageEnum.audio:
        break;
      case MessageEnum.file:
        break;
      case MessageEnum.location:
        break;
      case MessageEnum.contact:
        break;
      case MessageEnum.sticker:
        break;
    }
    return Text(type.toString());
  }
}
