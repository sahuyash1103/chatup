import 'package:chatup/chating/views/widgets/bottom_chat_field.dart';
import 'package:chatup/chating/views/widgets/chat_list.dart';
import 'package:chatup/login/cubit/firebase_login_cubit.dart';
import 'package:chatup/login/data/models/app_user.dart';
import 'package:chatup/var/colors.dart';
import 'package:chatup/widgets/custom_circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatingView extends StatefulWidget {
  const ChatingView({
    super.key,
    required this.name,
    required this.profilePic,
    required this.uid,
    this.isGroup = false,
  });
  static const routeName = 'chating-view';
  final String name;
  final String profilePic;
  final String uid;
  final bool isGroup;

  @override
  State<ChatingView> createState() => _ChatingViewState();
}

class _ChatingViewState extends State<ChatingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: appBarColor,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(1, 0, 10, 0),
              child: CustomCircleAvatar(
                profilePicURL: widget.profilePic,
                radius: 20,
              ),
            ),
            if (widget.isGroup)
              Text(widget.name)
            else
              StreamBuilder<AppUser>(
                stream: BlocProvider.of<FirebaseAuthCubit>(context)
                    .getUserByUID(widget.uid),
                builder: (context, snapshot) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(fontSize: 18),
                      ),
                      if (snapshot.data != null)
                        Text(
                          snapshot.data!.isOnline ? 'online' : 'offline',
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                    ],
                  );
                },
              ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      floatingActionButton: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.only(bottom: 40),
        child: FloatingActionButton(
          backgroundColor: messageColor,
          onPressed: () {},
          child: const Icon(
            Icons.keyboard_double_arrow_down,
            color: Colors.white,
            size: 25,
          ),
        ),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/backgroundImage.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ChatList(
                recieverUserId: widget.uid,
                isGroupChat: widget.isGroup,
              ),
            ),
            BottomChatField(
              recieverUserId: widget.uid,
              isGroupChat: widget.isGroup,
            ),
          ],
        ),
      ),
    );
  }
}
