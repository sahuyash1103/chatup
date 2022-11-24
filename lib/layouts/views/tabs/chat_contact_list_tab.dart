import 'package:chatup/chating/cubit/chat_cubit.dart';
import 'package:chatup/chating/views/chating_view.dart';
import 'package:chatup/common/utils/utils.dart';
import 'package:chatup/var/colors.dart';
import 'package:chatup/widgets/custom_center_text.dart';
import 'package:chatup/widgets/custom_circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatContactListTab extends StatefulWidget {
  const ChatContactListTab({super.key});

  @override
  State<ChatContactListTab> createState() => _ChatContactListTabState();
}

class _ChatContactListTabState extends State<ChatContactListTab> {
  String formatLastMessage(String lastMessage) {
    return '${lastMessage.substring(0, 30)}......';
  }

  String formatDateTime(DateTime dateTime) {
    return formateDate(dateTime) == 'Today'
        ? formateTime(dateTime)
        : formateDate(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    const isOnline = true;
    return StreamBuilder(
      stream: BlocProvider.of<ChatCubit>(context).fetchChatContacts(),
      builder: (context, snapshot) {
        if (snapshot.data != null && snapshot.data!.isNotEmpty) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final chatContact = snapshot.data![index];
              return Column(
                children: [
                  const SizedBox(
                    height: 3,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        ChatingView.routeName,
                        arguments: {
                          'name': chatContact.name,
                          'profilePic': chatContact.profilePic,
                          'uid': chatContact.contactId,
                        },
                      );
                    },
                    tileColor: chatBarMessage,
                    title: Text(
                      chatContact.name,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        chatContact.lastMessage.length <= 30
                            ? chatContact.lastMessage
                            : formatLastMessage(chatContact.lastMessage),
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    leading: CustomCircleAvatar(
                      profilePicURL: chatContact.profilePic,
                      radius: 30,
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.circle,
                          size: 15,
                          color: isOnline ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          formatDateTime(chatContact.timeStamp),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          return const CustomCenteredText(
            text: 'Your chat contact Will Show here.',
          );
        }
      },
    );
  }
}
