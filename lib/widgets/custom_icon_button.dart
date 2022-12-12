import 'package:chatup/var/colors.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.width = 30,
    this.iconSize = 30,
    this.fontSize = 16,
  });
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final double width;
  final double iconSize;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 50,
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: tabColor.withOpacity(0.01),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: iconSize, color: Colors.white),
            const SizedBox(height: 5),
            Text(text, style: TextStyle(fontSize: fontSize)),
          ],
        ),
      ),
    );
  }
}
