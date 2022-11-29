import 'package:cached_network_image/cached_network_image.dart';
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
        ? CachedNetworkImage(
            imageUrl: profilePicURL,
            imageBuilder: (context, imageProvider) {
              return CircleAvatar(
                radius: radius,
                backgroundColor: appBarColor,
                backgroundImage: imageProvider,
              );
            },
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          )
        : CircleAvatar(
            backgroundColor: appBarColor,
            backgroundImage: const AssetImage(defaultProfilePath),
            radius: radius,
          );
  }
}
