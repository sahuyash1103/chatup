import 'package:chatup/chating/data/models/message.dart';
import 'package:chatup/chating/views/widgets/display_text_image_gif.dart';
import 'package:chatup/common/utils/utils.dart';
import 'package:chatup/var/colors.dart';
import 'package:flutter/material.dart';

class UserMessageCard extends StatelessWidget {
  const UserMessageCard({
    super.key,
    required this.message,
  });
  final Message message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
          minWidth: message.timeStamp.toString().length * 5.0,
        ),
        child: Card(
          elevation: 1,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
              topLeft: Radius.circular(10),
            ),
          ),
          color: messageColor,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 8,
                  bottom: 30,
                  left: 5,
                  top: 5,
                ),
                child: DisplayTextImageGIF(
                  message: message.text,
                  type: message.messageType,
                ),
              ),
              // const SizedBox(height: 10),
              Positioned(
                bottom: 5,
                right: 5,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 10),
                    Text(
                      formateTime(message.timeStamp),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white60,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      message.isSeen ? Icons.done_all : Icons.done,
                      size: 20,
                      color: message.isSeen ? Colors.blue : Colors.white60,
                    ),
                    // const SizedBox(width: 5),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
