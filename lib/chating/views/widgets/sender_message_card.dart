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
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            color: senderMessageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 15,
                top: 10,
                right: 5,
                bottom: 5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DisplayTextImageGIF(
                    message: message.text,
                    type: message.messageType,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        formateTime(message.timeStamp),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
