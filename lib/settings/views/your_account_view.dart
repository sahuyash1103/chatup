import 'dart:developer';
import 'dart:io';

import 'package:chatup/common/utils/custom_image_picker.dart';
import 'package:chatup/login/cubit/firebase_login_cubit.dart';
import 'package:chatup/login/cubit/firebase_login_state.dart';
import 'package:chatup/login/cubit/firestore_cubit.dart';
import 'package:chatup/var/colors.dart';
import 'package:chatup/var/strings.dart';
import 'package:chatup/widgets/custom_circle_avatar.dart';
import 'package:chatup/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class YourProfileView extends StatefulWidget {
  const YourProfileView({super.key});
  static const routeName = 'setting/your_account_info';

  @override
  State<YourProfileView> createState() => _YourProfileViewState();
}

class _YourProfileViewState extends State<YourProfileView> {
  File? image;

  Future<void> selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  Future<void> updteProfilePic() async {
    if (image != null) {
      log('image is not null');
      await BlocProvider.of<FirestoreCubit>(context).updateProfilPic(image!);
      image = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
        actions: [
          if (image != null)
            TextButton(
              onPressed: updteProfilePic,
              child: const Text('Save'),
            ),
        ],
      ),
      body: BlocConsumer<FirebaseAuthCubit, FirebaseAuthState>(
        listener: (context, authState) {},
        builder: (context, authState) {
          if (authState is FirebaseAuthLogedInState) {
            return SingleChildScrollView(
              child: SafeArea(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(0, 50, 0, 10),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          if (image != null)
                            CircleAvatar(
                              backgroundImage: FileImage(image!),
                              radius: 64,
                            )
                          else if (authState.appUser.profilePic.isNotEmpty)
                            CustomCircleAvatar(
                              profilePicURL: authState.appUser.profilePic,
                              radius: 70,
                            )
                          else
                            const CircleAvatar(
                              backgroundImage: AssetImage(defaultProfilePath),
                              radius: 64,
                            ),
                          Positioned(
                            bottom: 0,
                            right: 10,
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                color: buttonColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: IconButton(
                                onPressed: selectImage,
                                icon: const Icon(
                                  Icons.add_a_photo,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      const Divider(height: 3),
                      ListTile(
                        tileColor: appBarColor,
                        title: const Text('Name'),
                        subtitle: Text(authState.appUser.name),
                        trailing: const Icon(Icons.edit),
                      ),
                      const Divider(height: 3),
                      ListTile(
                        title: const Text('Email'),
                        tileColor: appBarColor,
                        subtitle: Text(
                          authState.appUser.email.isNotEmpty
                              ? authState.appUser.email
                              : 'No Email Provided.',
                        ),
                        trailing: const Icon(Icons.edit),
                      ),
                      const Divider(height: 3),
                      ListTile(
                        title: const Text('Phone'),
                        tileColor: appBarColor,
                        subtitle: Text(authState.appUser.number),
                        trailing: const Icon(Icons.edit),
                      ),
                      SizedBox(height: size.height * 0.3),
                      const Text('Copyright (c) 2021, All rights reserved'),
                      const SizedBox(height: 5),
                      const Text('agreed To all Terms and Conditions'),
                    ],
                  ),
                ),
              ),
            );
          }
          return const CustomLoadingIndicator();
        },
      ),
    );
  }
}
