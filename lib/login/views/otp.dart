import 'package:chatup/common/utils/utils.dart';
import 'package:chatup/login/cubit/firebase_login_cubit.dart';
import 'package:chatup/login/cubit/firebase_login_state.dart';
import 'package:chatup/login/views/user_information.dart';
import 'package:chatup/var/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OTPView extends StatelessWidget {
  const OTPView({
    super.key,
    required this.phoneNumber,
  });
  static const String routeName = '/OTP-view';
  final String phoneNumber;

  void verifyOTP(BuildContext context, String userOTP) {
    BlocProvider.of<FirebaseLoginCubit>(context).verifyOTP(userOTP);
    // BlocProvider.of<FirebaseLoginCubit>(context).getCurrentUser();
    navigateToUserInfoView(context);
  }

  void navigateToUserInfoView(BuildContext context) {
    BlocProvider.of<FirebaseLoginCubit>(context).getCurrentUser();
    Navigator.pop(context);
    Navigator.pushReplacementNamed(
      context,
      UserInformationView.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifying your number'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'We have sent an SMS with a code on $phoneNumber.',
            ),
            BlocConsumer<FirebaseLoginCubit, FirebaseAuthState>(
              listener: (context, state) {
                if (state is FirebaseAuthCodeSentState) {
                  showSnackBar(context: context, content: 'OTP sent');
                }
              },
              builder: (context, state) {
                return SizedBox(
                  width: size.width * 0.5,
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: '- - - - - -',
                      hintStyle: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (value.length == 6) {
                        verifyOTP(context, value.trim());
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
