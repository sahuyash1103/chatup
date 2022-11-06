import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error});
  final String error;
  static const routeName = '/error';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(fontSize: 20, color: Colors.redAccent),
          ),
        ),
      ),
    );
  }
}
