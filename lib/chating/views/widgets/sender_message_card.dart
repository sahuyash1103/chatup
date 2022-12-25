import 'package:chatup/chating/data/enums/message_enums.dart';
import 'package:chatup/chating/data/models/message.dart';
import 'package:chatup/chating/views/widgets/display_text_image_etc.dart';
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
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: size.width * 0.8,
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
                  padding: message.messageType == MessageEnum.text
                      ? const EdgeInsets.fromLTRB(5, 5, 15, 25)
                      : const EdgeInsets.all(3),
                  child: DisplayTextImageGIF(
                    message: message.text,
                    type: message.messageType,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 10),
                      Text(
                        formateTime(message.timeStamp),
                        style: TextStyle(
                          fontSize: 13,
                          color: message.messageType == MessageEnum.text
                              ? Colors.white60
                              : Colors.white,
                        ),
                      ),
                      // const SizedBox(width: 5),
                    ],
                  ),
                ),
                if (message.messageType != MessageEnum.text &&
                    message.messageType != MessageEnum.audio)
                  Positioned(
                    bottom: 3,
                    right: 3,
                    child: Container(
                      height: 30,
                      width: size.width * 0.7 + 5,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.5),
                            Colors.black.withOpacity(0.6),
                            Colors.black.withOpacity(0.7),
                            // Colors.red,
                            // Colors.blue,
                          ],
                        ),
                      ),
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
