import 'package:chatup/var/colors.dart';
import 'package:chatup/var/strings.dart';
import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {
  const CustomCircleAvatar({
    super.key,
    required this.profilePicURL,
    this.radius,
  });
  final String profilePicURL;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return profilePicURL != defaultProfilePath
        ? CircleAvatar(
            backgroundImage: NetworkImage(profilePicURL),
            backgroundColor: appBarColor,
            radius: radius,
          )
        : CircleAvatar(
            backgroundColor: appBarColor,
            backgroundImage: const AssetImage(defaultProfilePath),
            radius: radius,
          );
  }
}
