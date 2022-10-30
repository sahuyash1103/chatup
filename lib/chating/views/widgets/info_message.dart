import 'package:chatup/var/colors.dart';
import 'package:flutter/material.dart';

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
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(infoMessage),
          ),
        ),
      ),
    );
  }
}
