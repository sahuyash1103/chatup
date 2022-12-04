import 'package:chatup/common/utils/utils.dart';
import 'package:chatup/login/cubit/firebase_login_cubit.dart';
import 'package:chatup/login/cubit/firebase_login_state.dart';
import 'package:chatup/login/views/user_information.dart';
import 'package:chatup/var/colors.dart';
import 'package:chatup/widgets/themed_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OTPView extends StatefulWidget {
  const OTPView({
    super.key,
    required this.phoneNumber,
  });
  static const String routeName = '/OTP-view';
  final String phoneNumber;

  @override
  State<OTPView> createState() => _OTPViewState();
}

class _OTPViewState extends State<OTPView> {
  final _otpController = TextEditingController();

  Future<void> verifyOTP(BuildContext context, String userOTP) async {
    final isLoggedIn =
        await BlocProvider.of<FirebaseAuthCubit>(context).verifyOTP(userOTP);
    if (isLoggedIn && mounted) navigateToUserInfoView(context);
  }

  void navigateToUserInfoView(BuildContext context) {
    BlocProvider.of<FirebaseAuthCubit>(context).refreshUser();

    Navigator.pop(context);
    Navigator.pushReplacementNamed(
      context,
      UserInformationView.routeName,
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                'We have sent an SMS with a code on ${widget.phoneNumber}.',
              ),
              SizedBox(
                width: size.width * 0.5,
                child: TextField(
                  controller: _otpController,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: '- - - - - -',
                    hintStyle: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: size.height * 0.65),
              BlocConsumer<FirebaseAuthCubit, FirebaseAuthState>(
                listener: (context, state) {
                  if (state is FirebaseAuthCodeSentState) {
                    showSnackBar(context: context, content: 'OTP sent');
                  }
                },
                builder: (context, state) {
                  return SizedBox(
                    width: size.width * 0.3,
                    child: ThemedButton(
                      text: 'Verify',
                      onPressed: () => _otpController.text.length == 6
                          ? verifyOTP(context, _otpController.text)
                          : null,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
