import 'package:chatup/var/colors.dart';
import 'package:flutter/material.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'Loading...',
            style: TextStyle(
              fontSize: 18,
              color: tabColor,
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: 30),
          CircularProgressIndicator.adaptive(),
        ],
      ),
    );
  }
}
