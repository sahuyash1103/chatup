//!Ko7Xc3hfHa95fZzKEHwVNvHctnKfuRKQ

import 'dart:developer';

import 'package:chatup/common/utils/environment_service.dart';
import 'package:chatup/var/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:giphy_get/giphy_get.dart';

Future<GiphyGif?> pickGIF(BuildContext context) async {
  GiphyGif? gif;
  try {
    const apiKey = EnvironmentService.giphyApiKey;
    gif = await GiphyGet.getGif(
      context: context,
      apiKey: apiKey,
      tabColor: backgroundColor,
    );

  } catch (e) {
    log(e.toString());
  }

  return gif;
}
