import 'package:chatup/chating/data/enums/message_enums.dart';
import 'package:chatup/chating/views/widgets/display_text_image_gif.dart';
import 'package:chatup/var/colors.dart';
import 'package:flutter/material.dart';

class UserMessageCard extends StatelessWidget {
  const UserMessageCard({
    super.key,
    required this.message,
    required this.date,
    required this.type,
    required this.isSeen,
  });
  final String message;
  final String date;
  final MessageEnum type;
  final bool isSeen;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Card(
          elevation: 1,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
              topLeft: Radius.circular(8),
            ),
          ),
          color: messageColor,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 5,
              top: 10,
              right: 15,
              bottom: 5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DisplayTextImageGIF(
                  message: message,
                  type: type,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white60,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Icon(
                      isSeen ? Icons.done_all : Icons.done,
                      size: 20,
                      color: isSeen ? Colors.blue : Colors.white60,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
