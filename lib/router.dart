import 'package:chatup/chating/views/chating_view.dart';
import 'package:chatup/common/views/error_view.dart';
import 'package:chatup/layouts/views/mobile_layout.dart';
import 'package:chatup/login/views/landing.dart';
import 'package:chatup/login/views/login.dart';
import 'package:chatup/login/views/otp.dart';
import 'package:chatup/login/views/user_information.dart';
import 'package:chatup/select_contact/views/select_contact.dart';
import 'package:chatup/settings/views/setting_view.dart';
import 'package:chatup/settings/views/your_account_view.dart';
import 'package:flutter/material.dart';

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

      case ChatingView.routeName:
        final args = settings.arguments! as Map<String, String>;
        return MaterialPageRoute(
          builder: (_) => ChatingView(
            name: args['name']!,
            profilePic: args['profilePic']!,
            uid: args['uid']!,
          ),
        );

      case SelectContactsView.routeName:
        return MaterialPageRoute(builder: (_) => const SelectContactsView());

      case SettinsView.routName:
        return MaterialPageRoute(builder: (_) => const SettinsView());

      case YourProfileView.routeName:
        return MaterialPageRoute(builder: (_) => const YourProfileView());

      case ErrorView.routeName:
        final error = settings.arguments.toString();
        return MaterialPageRoute(builder: (_) => ErrorView(error: error));

      default:
        final error = settings.arguments.toString();
        return MaterialPageRoute(builder: (_) => ErrorView(error: error));
    }
  }
}
