import 'dart:async';
import 'dart:io';

import 'package:chatup/common/utils/custom_image_picker.dart';
import 'package:chatup/common/utils/utils.dart';
import 'package:chatup/layouts/views/mobile_layout.dart';
import 'package:chatup/login/cubit/firebase_login_cubit.dart';
import 'package:chatup/login/cubit/firebase_login_state.dart';
import 'package:chatup/login/cubit/firestore_cubit.dart';
import 'package:chatup/login/cubit/firestore_state.dart';
import 'package:chatup/var/colors.dart';
import 'package:chatup/var/strings.dart';
import 'package:chatup/widgets/custom_circle_avatar.dart';
import 'package:chatup/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserInformationView extends StatefulWidget {
  const UserInformationView({super.key});
  static const String routeName = '/user-information';

  @override
  State<UserInformationView> createState() => _UserInformationViewState();
}

class _UserInformationViewState extends State<UserInformationView> {
  final nameController = TextEditingController();
  File? image;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  Future<void> storeUserData(String previousPic) async {
    if (nameController.text.trim().length < 4) return;
    await BlocProvider.of<FirestoreCubit>(context).saveUserDataToFireStore(
      name: nameController.text.trim().replaceAll(' ', '-'),
      profilePic: image,
      previousPic: previousPic.isNotEmpty ? previousPic : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocConsumer<FirebaseAuthCubit, FirebaseAuthState>(
        listener: (context, state) async {
          if (state is FirebaseAuthLogedInState) {
            nameController.text = state.appUser.name;
          }

          if (state is FirebaseAuthLogedOutState && mounted) {
            await afterLoggedOut(context);
          }
        },
        builder: (context1, authState) {
          return BlocConsumer<FirestoreCubit, FirestoreState>(
            listener: (context, state) {
              if (state is FirestoreSavedState) {
                BlocProvider.of<FirebaseAuthCubit>(context1).refreshUser();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  MobileView.routeName,
                  (route) => false,
                );
              }
              if (state is FirestoreSaveErrorState) {
                navigateToErrorView(context, error: state.error);
              }
            },
            builder: (context2, state) {
              if (state is FirestoreSaveLoadingState) {
                return const CustomLoadingIndicator();
              }

              if (authState is FirebaseAuthLogedInState) {
                return SafeArea(
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
                        Row(
                          children: [
                            Container(
                              width: size.width * 0.85,
                              padding: const EdgeInsets.all(20),
                              child: TextField(
                                controller: nameController,
                                decoration: const InputDecoration(
                                  hintText: 'Enter your name',
                                  hintStyle: TextStyle(color: buttonColor),
                                  focusColor: buttonColor,
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: buttonColor),
                                  ),
                                ),
                              ),
                            ),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: buttonColor,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: IconButton(
                                onPressed: () =>
                                    storeUserData(authState.appUser.profilePic),
                                icon: const Icon(
                                  Icons.done,
                                  color: Colors.white,
                                ),
                                color: buttonColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const CustomLoadingIndicator();
            },
          );
        },
      ),
    );
  }
}
