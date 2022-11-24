import 'dart:developer';

import 'package:chatup/common/utils/utils.dart';
import 'package:chatup/login/cubit/firebase_login_cubit.dart';
import 'package:chatup/login/cubit/firebase_login_state.dart';
import 'package:chatup/login/views/otp.dart';
import 'package:chatup/var/colors.dart';
import 'package:chatup/widgets/themed_button.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  static const routeName = '/Login-view';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final phoneController = TextEditingController();
  final CountryService _countryService = CountryService();
  Country? _country;
  String? phoneNumber;

  @override
  void initState() {
    super.initState();
    _country = _countryService.findByName('India');
  }

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  void pickCountry() {
    showCountryPicker(
      context: context,
      onSelect: (Country country) {
        setState(() {
          _country = country;
        });
      },
    );
  }

  void sendPhoneNumber() {
    final phoneNum = phoneController.text.trim();
    if (_country != null && phoneNum.isNotEmpty) {
      phoneNumber = '+${_country!.phoneCode}$phoneNum';
      if (phoneNumber != null) {
        BlocProvider.of<FirebaseAuthCubit>(context)
            .verifyPhoneNumber(phoneNumber!);
        Navigator.pushNamed(
          context,
          OTPView.routeName,
          arguments: phoneNumber,
        );
      }
    } else {
      showSnackBar(context: context, content: 'Fill all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter your phone number'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                const Text('ChatUP will need to verify your phone number.'),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: pickCountry,
                  child: const Text('Pick Country'),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    if (_country != null)
                      GestureDetector(
                        onTap: pickCountry,
                        child: Row(
                          children: [
                            Text('+${_country!.phoneCode}'),
                            const Icon(Icons.arrow_drop_down)
                          ],
                        ),
                      ),
                    const SizedBox(width: 10),
                    Flexible(
                      flex: 7,
                      child: TextField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                          hintText: 'phone number',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.6),
                BlocConsumer<FirebaseAuthCubit, FirebaseAuthState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is FirebaseAuthLoadingState) {
                      return const CircularProgressIndicator.adaptive();
                    } else if (state is FirebaseAuthErrorState) {
                      log(state.error);
                      BlocProvider.of<FirebaseAuthCubit>(context).reset();
                    }
                    return SizedBox(
                      width: 90,
                      child: ThemedButton(
                        onPressed: sendPhoneNumber,
                        text: 'NEXT',
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
