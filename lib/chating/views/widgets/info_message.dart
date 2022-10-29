import 'package:flutter/material.dart';
import 'package:unreal_whatsapp/var/colors.dart';

class InfoMessage extends StatelessWidget {
  const InfoMessage({super.key, required this.infoMessage});

  final String infoMessage;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.5,
        ),
        child: Card(
          color: infomessageColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Text(infoMessage),
        ),
      ),
    );
  }
}
