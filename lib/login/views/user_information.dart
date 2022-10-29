import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unreal_whatsapp/common/utils/utils.dart';
import 'package:unreal_whatsapp/layouts/views/mobile_layout.dart';
import 'package:unreal_whatsapp/login/cubit/firebase_login_cubit.dart';
import 'package:unreal_whatsapp/login/cubit/firebase_login_state.dart';
import 'package:unreal_whatsapp/var/colors.dart';
import 'package:unreal_whatsapp/var/strings.dart';
import 'package:unreal_whatsapp/widgets/custom_circle_avatar.dart';

class UserInformationView extends StatefulWidget {
  const UserInformationView({super.key});
  static const String routeName = '/user-information';

  @override
  State<UserInformationView> createState() => _UserInformationViewState();
}

class _UserInformationViewState extends State<UserInformationView> {
  final TextEditingController nameController = TextEditingController();
  File? image;

  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  Future<void> selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  Future<void> storeUserData(String previousPic) async {
    final result = await BlocProvider.of<FirebaseLoginCubit>(context)
        .saveUserDataToFireStore(
      name: nameController.text.trim(),
      profilePic: image,
      previousPic: previousPic.isNotEmpty ? previousPic : null,
    );

    if (result != null || !mounted) return;
    await BlocProvider.of<FirebaseLoginCubit>(context).getCurrentUser();

    if (mounted) {
      await Navigator.of(context).pushNamedAndRemoveUntil(
        MobileView.routeName,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocConsumer<FirebaseLoginCubit, FirebaseAuthState>(
      listener: (context, state) {
        if (state is FirebaseAuthLogedInState) {
          nameController.text = state.appUser.name;
        }
      },
      builder: (context, state) {
        if (state is FirebaseAuthLogedInState) {
          return Scaffold(
            body: SafeArea(
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
                        else if (state.appUser.profilePic.isNotEmpty)
                          CustomCircleAvatar(
                            profilePicURL: state.appUser.profilePic,
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
                              color: tabColor,
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
                              hintStyle: TextStyle(color: tabColor),
                              focusColor: tabColor,
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: tabColor),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              storeUserData(state.appUser.profilePic),
                          icon: const Icon(
                            Icons.done,
                            color: tabColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const CircularProgressIndicator.adaptive();
      },
    );
  }
}
