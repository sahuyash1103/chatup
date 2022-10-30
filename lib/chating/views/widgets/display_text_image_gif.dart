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
        : Container();
  }
}
