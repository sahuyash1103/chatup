import 'dart:io';

import 'package:chatup/common/utils/custom_image_picker.dart';
import 'package:chatup/var/colors.dart';
import 'package:chatup/var/strings.dart';
import 'package:flutter/material.dart';

class YourAccountInfo extends StatefulWidget {
  const YourAccountInfo({super.key});
  static const routeName = 'setting/your_account_info';

  @override
  State<YourAccountInfo> createState() => _YourAccountInfoState();
}

class _YourAccountInfoState extends State<YourAccountInfo> {
  File? image;

  Future<void> selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Account'),
      ),
      body: SingleChildScrollView(
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
                    // else if (auhtState.appUser.profilePic.isNotEmpty)
                    //   CustomCircleAvatar(
                    //     profilePicURL: auhtState.appUser.profilePic,
                    //     radius: 70,
                    //   )
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
                const ListTile(
                  tileColor: appBarColor,
                  title: Text('Name'),
                  subtitle: Text('Your name'),
                  trailing: Icon(Icons.edit),
                ),
                const Divider(height: 3),
                const ListTile(
                  title: Text('Email'),
                  tileColor: appBarColor,
                  subtitle: Text('Your email'),
                  trailing: Icon(Icons.edit),
                ),
                const Divider(height: 3),
                const ListTile(
                  title: Text('Phone'),
                  tileColor: appBarColor,
                  subtitle: Text('Your phone'),
                  trailing: Icon(Icons.edit),
                ),
                SizedBox(height: size.height * 0.3),
                const Text('Copyright (c) 2021, All rights reserved'),
                const SizedBox(height: 5),
                const Text('agreed To all Terms and Conditions'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
