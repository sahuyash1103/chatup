import 'package:chatup/chating/data/enums/message_enums.dart';
import 'package:chatup/chating/data/models/message.dart';
import 'package:chatup/chating/views/widgets/display_text_image_etc.dart';
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
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: size.width * 0.8,
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
                padding: message.messageType == MessageEnum.text
                    ? const EdgeInsets.fromLTRB(5, 5, 15, 25)
                    : const EdgeInsets.all(3),
                child: DisplayTextImageGIF(
                  message: message.text,
                  type: message.messageType,
                ),
              ),
              Positioned(
                bottom: 5,
                right: 5,
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
                    const SizedBox(width: 10),
                    Icon(
                      message.isSeen ? Icons.done_all : Icons.done,
                      size: 20,
                      color: message.isSeen ? Colors.blue : Colors.white60,
                    ),
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
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
