import 'package:chatup/chating/data/models/message.dart';
import 'package:chatup/chating/views/widgets/display_text_image_gif.dart';
import 'package:chatup/common/utils/utils.dart';
import 'package:chatup/var/colors.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
    super.key,
    required this.message,
    required this.onVisibile,
  });
  final Message message;
  final VoidCallback onVisibile;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
          minWidth: message.timeStamp.toString().length * 4.0,
        ),
        child: VisibilityDetector(
          key: Key(message.messageId),
          onVisibilityChanged: (info) {
            if (!message.isSeen) {
              if (info.visibleFraction >= 0.5) {
                message.isSeen = true;
                onVisibile();
              }
            }
          },
          child: Card(
            elevation: 1,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            color: senderMessageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 5,
                    bottom: 30,
                    left: 8,
                    top: 5,
                  ),
                  child: DisplayTextImageGIF(
                    message: message.text,
                    type: message.messageType,
                  ),
                ),
                // const SizedBox(height: 10),
                Positioned(
                  bottom: 10,
                  right: 10,
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
                      // const SizedBox(width: 5),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
