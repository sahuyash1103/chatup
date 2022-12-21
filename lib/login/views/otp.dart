
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
  bool isVerifyClicked = false;

  Future<void> verifyOTP(BuildContext context, String userOTP) async {
    final isLoggedIn =
        await BlocProvider.of<FirebaseAuthCubit>(context).verifyOTP(userOTP);
    if (isLoggedIn && mounted) navigateToUserInfoView(context);
  }

  void navigateToUserInfoView(BuildContext context) {
    BlocProvider.of<FirebaseAuthCubit>(context).refreshUser();

    Navigator.pop(context);
    Navigator.pushNamedAndRemoveUntil(
      context,
      UserInformationView.routeName,
      (route) => false,
    );
  }

  void resendOTP() {
    BlocProvider.of<FirebaseAuthCubit>(context)
        .verifyPhoneNumber(widget.phoneNumber);
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
              const SizedBox(height: 10),
              BlocConsumer<FirebaseAuthCubit, FirebaseAuthState>(
                listener: (context, state) {
                  if (state is FirebaseAuthCodeSentState) {
                    showSnackBar(context: context, content: 'OTP sent');
                  }
                  if (state is FirebaseAuthLogedInState && !isVerifyClicked) {
                    navigateToUserInfoView(context);
                  }
                  if (state is FirebaseAuthErrorState) {
                    isVerifyClicked = false;
                    setState(() {});
                    navigateToErrorView(context, error: state.error);
                  }
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        // alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: resendOTP,
                          child: const Text(
                            'Resend OTP',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.6),
                      if (state is FirebaseAuthLoadingState || isVerifyClicked)
                        const CircularProgressIndicator(),
                      if (state is FirebaseAuthCodeSentState &&
                          !isVerifyClicked)
                        SizedBox(
                          width: size.width * 0.3,
                          child: ThemedButton(
                            text: 'Verify',
                            onPressed: () {
                              if (_otpController.text.length == 6) {
                                isVerifyClicked = true;
                                setState(() {});
                                verifyOTP(context, _otpController.text);
                              } else {
                                showSnackBar(
                                  context: context,
                                  content: 'Enter a valid OTP',
                                );
                              }
                            },
                          ),
                        ),
                    ],
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
