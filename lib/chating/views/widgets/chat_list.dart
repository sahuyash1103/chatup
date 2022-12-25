import 'package:chatup/chating/cubit/chat_cubit.dart';
import 'package:chatup/chating/cubit/chat_state.dart';
import 'package:chatup/chating/views/widgets/info_message.dart';
import 'package:chatup/chating/views/widgets/sender_message_card.dart';
import 'package:chatup/chating/views/widgets/user_message_card.dart';
import 'package:chatup/common/utils/utils.dart';
import 'package:chatup/widgets/custom_center_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatList extends StatefulWidget {
  const ChatList({
    super.key,
    required this.recieverUserId,
    this.isGroupChat = false,
  });

  final String recieverUserId;
  final bool isGroupChat;

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final messageScrollController = ScrollController();

  @override
  void dispose() {
    messageScrollController.dispose();
    super.dispose();
  }

  void autoScroll() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 1), jumpDown);
    });
  }

  void jumpDown() {
    messageScrollController
        .jumpTo(messageScrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {},
      builder: (context, state) {
        return StreamBuilder(
          stream: BlocProvider.of<ChatCubit>(context)
              .fetchMessages(contactID: widget.recieverUserId),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const CustomCenteredText(
                text: 'Your chats will show here.',
              );
            }
            autoScroll();
            return ListView.builder(
              controller: messageScrollController,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final message = snapshot.data![index];
                final previousDay = index != 0
                    ? formateDate(snapshot.data![index - 1].timeStamp)
                    : '';
                final newDay = formateDate(message.timeStamp);

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (previousDay != newDay) InfoMessage(infoMessage: newDay),
                    if (message.senderId ==
                        FirebaseAuth.instance.currentUser!.uid)
                      UserMessageCard(
                        message: message,
                      )
                    else
                      SenderMessageCard(
                        message: message,
                        onVisibile: () {
                          BlocProvider.of<ChatCubit>(context)
                              .updateMessageStatus(
                            message: message,
                          );
                        },
                      ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
