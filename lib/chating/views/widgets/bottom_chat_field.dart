import 'package:chatup/chating/cubit/chat_cubit.dart';
import 'package:chatup/chating/cubit/chat_state.dart';
import 'package:chatup/common/utils/utils.dart';
import 'package:chatup/login/cubit/firebase_login_cubit.dart';
import 'package:chatup/var/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              setState(() {
                isTyping = false;
                if (_textEditingControllerMessage.text.isNotEmpty) {
                  isTyping = true;
                }
              });
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
        BlocConsumer<ChatCubit, ChatState>(
          listener: (context, state) {
            if (state is ChatErrorState) {
              showSnackBar(context: context, content: state.error);
            }
          },
          builder: (context, state) {
            return GestureDetector(
              onTap: isTyping ? sendTextMessage : recordAudio,
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(1, 0, 5, 0),
                padding: const EdgeInsets.fromLTRB(10, 8, 6, 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: tabColor,
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
            );
          },
        )
      ],
    );
  }

  Future<void> recordAudio() async {}

  Future<void> sendTextMessage() async {
    final sender =
        await BlocProvider.of<FirebaseLoginCubit>(context).getCurrentUser();
    final textMessage = _textEditingControllerMessage.text.trim();
    _textEditingControllerMessage.text = '';
    isTyping = false;
    setState(() {});
    if (mounted && sender != null && textMessage.isNotEmpty) {
      await BlocProvider.of<ChatCubit>(context).sendTextMessage(
        text: textMessage,
        recieverID: widget.recieverUserId,
        sender: sender,
      );
      showSnackBar(context: context, content: 'Message sent');
    } else {
      showSnackBar(context: context, content: 'Unable to send message');
    }
  }
}
