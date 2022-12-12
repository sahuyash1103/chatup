import 'package:chatup/settings/views/your_account_view.dart';
import 'package:chatup/var/colors.dart';
import 'package:flutter/material.dart';

class SettinsView extends StatelessWidget {
  const SettinsView({super.key});
  static const routName = '/settings';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: size.height * 0.3,
                child: const Center(
                  child: Text(
                    'Settings',
                    style: TextStyle(fontSize: 24, color: tabColor),
                  ),
                ),
              ),
              ListTile(
                onTap: () =>
                    Navigator.pushNamed(context, YourProfileView.routeName),
                title: const Text(
                  'You Account',
                  style: TextStyle(fontSize: 18),
                ),
                leading: const Icon(
                  Icons.person,
                  size: 20,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
