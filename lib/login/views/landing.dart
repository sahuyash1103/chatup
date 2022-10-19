import 'package:flutter/material.dart';
import 'package:unreal_whatsapp/login/views/login.dart';
import 'package:unreal_whatsapp/var/colors.dart';
import 'package:unreal_whatsapp/widgets/themed_button.dart';

class LandingView extends StatelessWidget {
  const LandingView({super.key});
  static const routeName = '/landing-view';

  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, LoginView.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Text(
              'Welcome to WhatsApp',
              style: TextStyle(
                fontSize: 33,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: size.height / 9),
            Image.asset(
              'assets/bg.png',
              height: 340,
              width: 340,
              color: tabColor,
            ),
            SizedBox(height: size.height / 9),
            const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                '''
                Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Service.
                ''',
                style: TextStyle(color: greyColor),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: size.width * 0.75,
              child: ThemedButton(
                text: 'AGREE AND CONTINUE',
                onPressed: () => navigateToLoginScreen(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
