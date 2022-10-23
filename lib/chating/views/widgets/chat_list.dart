import 'package:flutter/material.dart';

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
    return Container();
  }
}
