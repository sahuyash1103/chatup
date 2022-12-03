import 'dart:developer';

import 'package:chatup/chating/views/chating_view.dart';
import 'package:chatup/common/services/firebase_messaging_service.dart';
import 'package:chatup/common/utils/utils.dart';
import 'package:chatup/layouts/views/tabs/chat_contact_list_tab.dart';
import 'package:chatup/login/cubit/firebase_login_cubit.dart';
import 'package:chatup/login/cubit/firebase_login_state.dart';
import 'package:chatup/login/cubit/firestore_cubit.dart';
import 'package:chatup/login/cubit/firestore_state.dart';
import 'package:chatup/login/data/models/app_user.dart';
import 'package:chatup/select_contact/views/select_contact.dart';
import 'package:chatup/settings/views/your_account_view.dart';
import 'package:chatup/var/colors.dart';
import 'package:chatup/widgets/custom_center_text.dart';
import 'package:chatup/widgets/custom_circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

    FirebaseMessagingService.instance.onTokenRefresh(updateFcmToken);
    FirebaseMessagingService.instance.getInitialMessage();
    FirebaseMessagingService.instance.onMessage();
    FirebaseMessagingService.instance.onMessageOpenedApp();
  }

  @override
  void dispose() {
    tabBarController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        setOnlineStatus(isOnline: true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        setOnlineStatus(isOnline: false);
        break;
    }
  }

  void setOnlineStatus({required bool isOnline}) {
    BlocProvider.of<FirestoreCubit>(context)
        .setOnlineStatus(isOnline: isOnline);
  }

  void updateFcmToken(String fcmToken) {
    BlocProvider.of<FirestoreCubit>(context).updateFcmToken(fcmToken: fcmToken);
  }

  void logout() {
    BlocProvider.of<FirebaseAuthCubit>(context).logOut();
    afterLoggedOut(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FirestoreCubit, FirestoreState>(
      listener: (context, state) {},
      builder: (context, state) {
        return BlocConsumer<FirebaseAuthCubit, FirebaseAuthState>(
          listener: (context, state) async {
            if (state is FirebaseAuthLogedOutState) {
              await afterLoggedOut(context);
            }
          },
          builder: (context, state) {
            if (state is FirebaseAuthLogedInState) {
              return DefaultTabController(
                length: 3,
                child: Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: appBarColor,
                    centerTitle: false,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ChatUP',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '@${state.appUser.name}',
                          style: const TextStyle(fontSize: 12, color: tabColor),
                        ),
                      ],
                    ),
                    leading: Padding(
                      padding: const EdgeInsets.all(5),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            YourAccountInfo.routeName,
                          );
                        },
                        child: CustomCircleAvatar(
                          profilePicURL: state.appUser.profilePic,
                        ),
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.grey),
                        onPressed: () {},
                      ),
                      PopupMenuButton(
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
                      ChatContactListTab(),
                      CustomCenteredText(text: 'status will show here'),
                      CustomCenteredText(text: 'status will show here'),
                    ],
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () async {
                      final user = await Navigator.pushNamed(
                        context,
                        SelectContactsView.routeName,
                      );
                      if (user is AppUser && mounted) {
                        await Navigator.pushNamed(
                          context,
                          ChatingView.routeName,
                          arguments: {
                            'name': user.name,
                            'profilePic': user.profilePic,
                            'uid': user.uid,
                          },
                        );
                      } else {
                        log(user.toString());
                      }
                    },
                    backgroundColor: buttonColor,
                    child: const Icon(
                      Icons.comment,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );
      },
    );
  }
}
