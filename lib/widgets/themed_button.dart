import 'package:flutter/material.dart';
import 'package:unreal_whatsapp/var/colors.dart';

class ThemedButton extends StatelessWidget {
  const ThemedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });
  final String text;
  final VoidCallback onPressed;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return icon == null
        ? ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: tabColor,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: Text(
              text,
              style: const TextStyle(
                color: blackColor,
              ),
            ),
          )
        : ElevatedButton.icon(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: tabColor,
              minimumSize: const Size(double.infinity, 50),
            ),
            icon: icon!,
            label: Text(
              text,
              style: const TextStyle(
                color: blackColor,
              ),
            ),
          );
  }
}
