import 'package:flutter/material.dart';
import 'package:unreal_whatsapp/layouts/views/mobile.dart';
import 'package:unreal_whatsapp/login/views/landing.dart';
import 'package:unreal_whatsapp/login/views/login.dart';
import 'package:unreal_whatsapp/login/views/otp.dart';
import 'package:unreal_whatsapp/login/views/user_information.dart';
import 'package:unreal_whatsapp/select_contact/views/select_contact.dart';

class AppRouter {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LandingView.routeName:
        return MaterialPageRoute(builder: (_) => const LandingView());

      case LoginView.routeName:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case OTPView.routeName:
        final phoneNumber = settings.arguments.toString();
        return MaterialPageRoute(
          builder: (_) => OTPView(
            phoneNumber: phoneNumber,
          ),
        );
      case UserInformationView.routeName:
        return MaterialPageRoute(builder: (_) => const UserInformationView());
      case MobileView.routeName:
        return MaterialPageRoute(builder: (_) => const MobileView());

      case SelectContactsView.routeName:
        return MaterialPageRoute(builder: (_) => const SelectContactsView());
      default:
        final error = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text(
                error != null ? error.toString() : 'Restart the App.',
              ),
            ),
          ),
        );
    }
  }
}
