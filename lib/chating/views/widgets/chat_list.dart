import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:unreal_whatsapp/chating/cubit/chat_cubit.dart';
import 'package:unreal_whatsapp/chating/cubit/chat_state.dart';
import 'package:unreal_whatsapp/chating/views/widgets/sender_message_card.dart';
import 'package:unreal_whatsapp/chating/views/widgets/user_message_card.dart';

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
              return const Center(child: Text('Your chats will show here.'));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final message = snapshot.data![index];
                final timeStamp = DateFormat.Hm().format(message.timeStamp);

                if (message.senderId ==
                    FirebaseAuth.instance.currentUser!.uid) {
                  return UserMessageCard(
                    message: message.text,
                    date: timeStamp,
                    type: message.messageType,
                    isSeen: message.isSeen,
                  );
                }
                return SenderMessageCard(
                  message: message.text,
                  date: timeStamp,
                  type: message.messageType,
                );
              },
            );
          },
        );
      },
    );
  }
}