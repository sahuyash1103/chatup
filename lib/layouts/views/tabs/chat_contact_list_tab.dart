import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unreal_whatsapp/chating/cubit/chat_cubit.dart';
import 'package:unreal_whatsapp/chating/views/chating_view.dart';
import 'package:unreal_whatsapp/common/utils/utils.dart';
import 'package:unreal_whatsapp/var/colors.dart';
import 'package:unreal_whatsapp/widgets/custom_circle_avatar.dart';

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
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 1,
                      right: 1,
                    ),
                    child: ListTile(
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
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
                      trailing: Text(
                        formatDateTime(chatContact.timeStamp),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          return const Center(
            child: Text('Your Chats Will Show here.'),
          );
        }
      },
    );
  }
}
