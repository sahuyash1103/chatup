import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unreal_whatsapp/common/utils/utils.dart';
import 'package:unreal_whatsapp/login/cubit/firebase_login.dart';
import 'package:unreal_whatsapp/login/cubit/firebase_login_state.dart';
import 'package:unreal_whatsapp/login/data/models/app_user.dart';
import 'package:unreal_whatsapp/select_contact/views/select_contact.dart';
import 'package:unreal_whatsapp/var/colors.dart';

class MobileView extends StatefulWidget {
  const MobileView({super.key});
  static const routeName = '~';

  @override
  State<MobileView> createState() => _MobileViewState();
}

class _MobileViewState extends State<MobileView>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController tabBarController;
  @override
  void initState() {
    super.initState();
    tabBarController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void logout() {
    BlocProvider.of<FirebaseLoginCubit>(context).logOut();
    afterLoggedOut(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FirebaseLoginCubit, FirebaseAuthState>(
      listener: (context, state) async {
        if (state is FirebaseAuthLogedOutState) {
          await afterLoggedOut(context);
        }
      },
      builder: (context, state) {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: appBarColor,
              centerTitle: false,
              title: const Text(
                'WhatsApp',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.grey),
                  onPressed: () {},
                ),
                BlocConsumer<FirebaseLoginCubit, FirebaseAuthState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    return PopupMenuButton(
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.grey,
                      ),
                      itemBuilder: (context) => <PopupMenuItem<Text>>[
                        PopupMenuItem(
                          child: const Text(
                            'Create Group',
                          ),
                          onTap: () {},
                        ),
                        PopupMenuItem(
                          onTap: logout,
                          child: const Text(
                            'Log Out',
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
              bottom: TabBar(
                controller: tabBarController,
                indicatorColor: tabColor,
                indicatorWeight: 4,
                labelColor: tabColor,
                unselectedLabelColor: Colors.grey,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                tabs: const [
                  Tab(
                    text: 'CHATS',
                  ),
                  Tab(
                    text: 'STATUS',
                  ),
                  Tab(
                    text: 'CALLS',
                  ),
                ],
              ),
            ),
            body: TabBarView(
              controller: tabBarController,
              children: const [
                Text('Chats'),
                Text('status'),
                Text('Calls'),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final user = await Navigator.pushNamed(
                  context,
                  SelectContactsView.routeName,
                );
                if (user is AppUser) {
                  log(user.number);
                } else {
                  log(user.toString());
                }
              },
              backgroundColor: tabColor,
              child: const Icon(
                Icons.comment,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
