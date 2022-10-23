import 'package:flutter/material.dart';
import 'package:unreal_whatsapp/var/colors.dart';

class BottomChatField extends StatefulWidget {
  const BottomChatField({
    super.key,
    required this.recieverUserId,
    this.isGroupChat = false,
  });
  final String recieverUserId;
  final bool isGroupChat;

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  final TextEditingController _textEditingControllerMessage =
      TextEditingController();
  bool isTyping = false;

  @override
  void dispose() {
    _textEditingControllerMessage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _textEditingControllerMessage,
            maxLines: 10,
            minLines: 1,
            onChanged: (value) {
              if (value.isEmpty) {
                isTyping = false;
              } else {
                isTyping = true;
              }
              setState(() {});
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: mobileChatBoxColor,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: SizedBox(
                  width: 50,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.emoji_emotions,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              suffixIcon: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.grey,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.attach_file,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              hintText: 'Type a message!',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(2),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.fromLTRB(1, 0, 5, 0),
            padding: const EdgeInsets.fromLTRB(10, 8, 6, 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFF128C7E),
            ),
            child: isTyping
                ? const Icon(
                    Icons.send_rounded,
                    size: 25,
                  )
                : const Icon(
                    Icons.mic,
                    size: 25,
                  ),
          ),
        )
      ],
    );
  }
}
