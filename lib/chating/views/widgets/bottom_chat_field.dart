import 'dart:async';
import 'dart:developer';
import 'dart:io';

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
import 'package:flutter_sound/flutter_sound.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
  AppUser? sender;
  FlutterSoundRecorder? _soundRecorder;
  bool isRecording = false;
  bool isRecorderInitiated = false;

  bool isTyping = false;
  bool isTypingEmoji = false;
  final focusNode = FocusNode();

  String? path;

  Future<void> startRecordingAudio() async {
    isRecording = true;
    setState(() {});
    await _soundRecorder!.startRecorder(
      toFile: path,
    );
  }

  Future<void> stopRecordingAudio() async {
    isRecording = false;
    setState(() {});
    await _soundRecorder!.stopRecorder();
  }

  Future<void> sendTextAudioMessage() async {
    if (isTyping) {
      final textMessage = _textEditingControllerMessage.text.trim();
      _textEditingControllerMessage.text = '';
      isTyping = false;
      setState(() {});
      if (mounted && sender != null && textMessage.isNotEmpty) {
        await BlocProvider.of<ChatCubit>(context).sendTextMessage(
          text: textMessage,
          recieverID: widget.recieverUserId,
          sender: sender!,
        );
      }
    } else if (_soundRecorder != null && path != null && isRecorderInitiated) {
      if (isRecording) {
        await startRecordingAudio();
        await sendFileMessage(File(path!), MessageEnum.audio);
      } else {
        await stopRecordingAudio();
      }
    }
  }

  Future<void> sendImageMessage() async {
    final img = await pickImage(context, isCroped: false);
    log(img.toString());
    if (img != null && sender != null && mounted) {
      await BlocProvider.of<ChatCubit>(context).sendFileMessage(
        file: img,
        recieverID: widget.recieverUserId,
        sender: sender!,
        messageEnum: MessageEnum.image,
      );
    }
  }

  Future<void> sendVideoMessage() async {
    final video = await pickVideo(context);
    if (video != null && sender != null && mounted) {
      await BlocProvider.of<ChatCubit>(context).sendFileMessage(
        file: video,
        recieverID: widget.recieverUserId,
        sender: sender!,
        messageEnum: MessageEnum.video,
      );
    }
  }

  Future<void> sendGIF() async {
    final gif = await pickGIF(context);
    if (gif != null && gif.url != null && sender != null && mounted) {
      await BlocProvider.of<ChatCubit>(context).sendGIFMessage(
        gifUrl: gif.url!,
        recieverID: widget.recieverUserId,
        sender: sender!,
      );
    }
  }

  Future<void> sendFileMessage(File? file, MessageEnum messageEnum) async {
    if (file != null && sender != null && mounted) {
      await BlocProvider.of<ChatCubit>(context).sendFileMessage(
        file: file,
        recieverID: widget.recieverUserId,
        sender: sender!,
        messageEnum: messageEnum,
      );
    }
  }

  Future<void> ahowAttetchOptions() async {
    await attetchOptions(
      context: context,
      onTapImage: sendImageMessage,
      onTapVideo: sendVideoMessage,
    );
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

  Future<void> openAudio() async {
    final status = await Permission.microphone.request();
    if (_soundRecorder == null) return;
    if (status != PermissionStatus.granted) {
      log('MICROPHONE PERMISSION IS NOT GRANTED');
      return;
    }
    await _soundRecorder!.openRecorder();
    isRecorderInitiated = true;
  }

  Future<void> closeAudio() async {
    if (_soundRecorder == null) return;
    await _soundRecorder!.closeRecorder();
    isRecorderInitiated = false;
  }

  Future<void> _setAudioPath() async {
    final tempDir = await getTemporaryDirectory();
    path = '${tempDir.path}/flutter_sound.aac';
  }

  Future<void> setSender() async {
    sender = await BlocProvider.of<FirebaseAuthCubit>(context).getCurrentUser();
  }

  @override
  void initState() {
    super.initState();
    setSender();
    _soundRecorder = FlutterSoundRecorder(logLevel: Level.nothing);
    _setAudioPath();
    openAudio();
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
    focusNode.dispose();
    closeAudio();
    super.dispose();
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
                  onTap: sendTextAudioMessage,
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
                        : isRecording
                            ? const Icon(
                                Icons.stop,
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
