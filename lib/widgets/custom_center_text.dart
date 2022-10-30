import 'package:flutter/cupertino.dart';

class CustomCenteredText extends StatelessWidget {
  const CustomCenteredText({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 16,
        ),
      ),
    );
  }
}
