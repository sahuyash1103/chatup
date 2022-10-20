import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unreal_whatsapp/login/cubit/firebase_login_cubit.dart';
import 'package:unreal_whatsapp/login/data/models/app_user.dart';
import 'package:unreal_whatsapp/var/colors.dart';

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
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(1, 0, 10, 0),
              child: CircleAvatar(
                backgroundColor: appBarColor,
                backgroundImage: NetworkImage(widget.profilePic),
                radius: 20,
              ),
            ),
            if (widget.isGroup)
              Text(widget.name)
            else
              StreamBuilder<AppUser>(
                stream: BlocProvider.of<FirebaseLoginCubit>(context)
                    .getUserByUID(widget.uid),
                builder: (context, snapshot) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(fontSize: 18),
                      ),
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
        titleSpacing: 0,
        backgroundColor: appBarColor,
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
    );
  }
}
