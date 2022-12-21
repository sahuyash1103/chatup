import 'dart:developer';

import 'package:chatup/chating/cubit/chat_cubit.dart';
import 'package:chatup/chating/cubit/chat_state.dart';
import 'package:chatup/chating/data/enums/message_enums.dart';
import 'package:chatup/chating/views/widgets/custom_attetch_options.dart';
import 'package:chatup/common/utils/custom_image_picker.dart';
import 'package:chatup/common/utils/custom_video_picker.dart';
import 'package:chatup/common/utils/gif_picker.dart';
import 'package:chatup/common/utils/utils.dart';
import 'package:chatup/login/cubit/firebase_login_cubit.dart';
import 'package:chatup/login/data/models/app_user.dart';
import 'package:chatup/var/colors.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
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
  final _textEditingControllerMessage = TextEditingController();

  bool isTyping = false;
  bool isTypingEmoji = false;
  final focusNode = FocusNode();

  Future<void> recordAudio() async {}

  Future<void> sendTextMessage() async {
    final sender =
        await BlocProvider.of<FirebaseAuthCubit>(context).getCurrentUser();
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
      // showSnackBar(context: context, content: 'Message sent');
    } else {
      showSnackBar(context: context, content: 'Unable to send message');
    }
  }

  Future<void> ahowAttetchOptions() async {
    await attetchOptions(
      context: context,
      onTapImage: sendImageMessage,
      onTapVideo: sendVideoMessage,
    );
  }

  Future<void> sendImageMessage() async {
    final img = await pickImage(context, isCroped: false);
    log(img.toString());
    AppUser? sender;
    if (mounted) {
      sender =
          await BlocProvider.of<FirebaseAuthCubit>(context).getCurrentUser();
    }
    if (img != null && sender != null && mounted) {
      await BlocProvider.of<ChatCubit>(context).sendFileMessage(
        file: img,
        recieverID: widget.recieverUserId,
        sender: sender,
        messageEnum: MessageEnum.image,
      );
    }
  }

  Future<void> sendVideoMessage() async {
    final video = await pickVideo(context);
    AppUser? sender;
    if (mounted) {
      sender =
          await BlocProvider.of<FirebaseAuthCubit>(context).getCurrentUser();
    }
    if (video != null && sender != null && mounted) {
      await BlocProvider.of<ChatCubit>(context).sendFileMessage(
        file: video,
        recieverID: widget.recieverUserId,
        sender: sender,
        messageEnum: MessageEnum.video,
      );
    }
  }

  Future<void> sendGIF() async {
    final gif = await pickGIF(context);
    AppUser? sender;
    if (mounted) {
      sender =
          await BlocProvider.of<FirebaseAuthCubit>(context).getCurrentUser();
    }
    if (gif != null && gif.url != null && sender != null && mounted) {
      await BlocProvider.of<ChatCubit>(context).sendGIFMessage(
        gifUrl: gif.url!,
        recieverID: widget.recieverUserId,
        sender: sender,
      );
    }
  }

  void showEmojiKeyboard() {
    setState(() {
      isTypingEmoji = true;
    });
  }

  void hideEmojiKeyboard() {
    setState(() {
      isTypingEmoji = false;
    });
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboard() {
    isTypingEmoji = !isTypingEmoji;
    if (isTypingEmoji) {
      showEmojiKeyboard();
      hideKeyboard();
    } else {
      showKeyboard();
      hideEmojiKeyboard();
    }
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        hideEmojiKeyboard();
      }
    });
    //..removeListener(() {});
  }

  @override
  void dispose() {
    _textEditingControllerMessage.dispose();
    super.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _textEditingControllerMessage,
                focusNode: focusNode,
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
                  hintText: 'Type a message!',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(2),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: SizedBox(
                      width: 50,
                      child: IconButton(
                        onPressed: toggleEmojiKeyboard,
                        icon: Icon(
                          isTypingEmoji ? Icons.keyboard : Icons.emoji_emotions,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  suffixIcon: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!isTyping)
                        TextButton(
                          onPressed: sendGIF,
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all(Colors.grey),
                            maximumSize: MaterialStateProperty.all(
                              const Size(65, 40),
                            ),
                          ),
                          child: const Text(
                            'GIF',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      IconButton(
                        style: ButtonStyle(
                          maximumSize: MaterialStateProperty.all(
                            const Size(25, 40),
                          ),
                        ),
                        onPressed: sendImageMessage,
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                      IconButton(
                        style: ButtonStyle(
                          maximumSize: MaterialStateProperty.all(
                            const Size(25, 40),
                          ),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.all(2),
                          ),
                        ),
                        onPressed: ahowAttetchOptions,
                        icon: const Icon(
                          Icons.attach_file,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
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
        ),
        if (isTypingEmoji)
          SizedBox(
            height: 310,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                setState(() {
                  _textEditingControllerMessage.text += emoji.emoji;
                });

                if (_textEditingControllerMessage.text.isNotEmpty) {
                  setState(() {
                    isTyping = true;
                  });
                } else {
                  setState(() {
                    isTyping = false;
                  });
                }
              },
            ),
          ),
      ],
    );
  }
}
