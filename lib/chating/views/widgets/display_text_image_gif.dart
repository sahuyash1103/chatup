import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatup/chating/data/enums/message_enums.dart';
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
    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        : type == MessageEnum.image
            ? CachedNetworkImage(
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
              )
            : Text(type.toString());
  }
}
