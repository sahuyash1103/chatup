// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:unreal_whatsapp/login/cubit/firebase_login_state.dart';
import 'package:unreal_whatsapp/login/data/models/app_user.dart';
import 'package:unreal_whatsapp/login/data/repositeries/firebase_login.dart';

class FirebaseLoginCubit extends Cubit<FirebaseAuthState> {
  FirebaseLoginCubit({
    required this.firebaseLoginRepository,
  }) : super(FirebaseAuthInitialState());

  final LoginRepository firebaseLoginRepository;
  late String? _verificationId;

  Future<AppUser?> getCurrentUser() async {
    return firebaseLoginRepository.getCurrentUser();
  }

  Future<void> verifyPhoneNumber(String number) async {
    emit(FirebaseAuthLoadingState());
    try {
      await firebaseLoginRepository.firebaseLoginProvider.firebaseAuth
          .verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: (credential) async {
          await signInWithCredential(credential);
        },
        verificationFailed: (e) {
          emit(FirebaseAuthErrorState(error: e.message.toString()));
        },
        codeSent: (verificationId, resendToken) {
          _verificationId = verificationId;
          emit(FirebaseAuthCodeSentState());
        },
        codeAutoRetrievalTimeout: (verificationId) {
          _verificationId = verificationId;
        },
      );
    } on FirebaseAuthException catch (e) {
      emit(FirebaseAuthErrorState(error: e.message ?? ''));
    }
  }

  Future<void> verifyOTP(String otp) async {
    emit(FirebaseAuthLoadingState());
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otp,
    );
    await signInWithCredential(credential);
  }

  Future<void> signInWithCredential(PhoneAuthCredential credential) async {
    emit(FirebaseAuthLoadingState());
    try {
      final userCredential = await firebaseLoginRepository
          .firebaseLoginProvider.firebaseAuth
          .signInWithCredential(credential);
      if (userCredential.user != null) {
        emit(
          FirebaseAuthLogedInState(
            appUser: AppUser.fromFirebaseUser(userCredential.user!),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      emit(FirebaseAuthErrorState(error: e.message.toString()));
    }
  }

  Future<String?> saveUserDataToFireStore({
    required String name,
    File? profilePic,
  }) async {
    return firebaseLoginRepository.saveUserDataToFireStore(
      name: name,
      profilePic: profilePic,
    );
  }

  void logOut() {
    try {
      firebaseLoginRepository.logOut();
      emit(FirebaseAuthLogedOutState());
    } catch (e) {
      emit(FirebaseAuthErrorState(error: e.toString()));
    }
  }

  void error(String error) {
    emit(FirebaseAuthErrorState(error: error));
  }

  void reset() {
    emit(FirebaseAuthInitialState());
  }
}
