import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unreal_whatsapp/common/utils/utils.dart';
import 'package:unreal_whatsapp/layouts/views/mobile_layout.dart';
import 'package:unreal_whatsapp/login/cubit/firebase_login_cubit.dart';
import 'package:unreal_whatsapp/var/colors.dart';

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
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  Future<void> selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  Future<void> storeUserData() async {
    final result = await BlocProvider.of<FirebaseLoginCubit>(context)
        .saveUserDataToFireStore(
      name: nameController.text.trim(),
      profilePic: image,
    );

    if (result != null || !mounted) return;
    await Navigator.of(context).pushNamedAndRemoveUntil(
      MobileView.routeName,
      (route) => false,
    );

    if (mounted) {
      await BlocProvider.of<FirebaseLoginCubit>(context).getCurrentUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 10),
          child: Column(
            children: [
              Stack(
                children: [
                  if (image == null)
                    const CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
                      ),
                      radius: 64,
                    )
                  else
                    CircleAvatar(
                      backgroundImage: FileImage(
                        image!,
                      ),
                      radius: 64,
                    ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(
                        Icons.add_a_photo,
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
                        hintStyle: TextStyle(
                          color: tabColor,
                        ),
                        focusColor: tabColor,
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: tabColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: storeUserData,
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
}
