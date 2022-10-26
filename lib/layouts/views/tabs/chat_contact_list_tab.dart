import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:unreal_whatsapp/chating/cubit/chat_cubit.dart';
import 'package:unreal_whatsapp/chating/views/chating_view.dart';
import 'package:unreal_whatsapp/var/colors.dart';

class ChatContactListTab extends StatefulWidget {
  const ChatContactListTab({super.key});

  @override
  State<ChatContactListTab> createState() => _ChatContactListTabState();
}

class _ChatContactListTabState extends State<ChatContactListTab> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: BlocProvider.of<ChatCubit>(context).fetchChatContacts(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final chatContact = snapshot.data![index];
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                      left: 5,
                      right: 5,
                      bottom: 2,
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
                      tileColor: appBarColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
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
                          chatContact.lastMessage,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(chatContact.profilePic),
                        radius: 30,
                      ),
                      trailing: Text(
                        DateFormat.Hm().format(chatContact.timeStamp),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const Divider(color: dividerColor, height: 3),
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
