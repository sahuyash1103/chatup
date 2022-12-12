import 'package:chatup/login/cubit/firebase_login_state.dart';
import 'package:chatup/login/data/models/app_user.dart';
import 'package:chatup/login/data/repositeries/firebase_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FirebaseAuthCubit extends Cubit<FirebaseAuthState> {
  FirebaseAuthCubit({
    required this.firebaseLoginRepository,
  }) : super(FirebaseAuthInitialState());

  final FirebaseAuthRepository firebaseLoginRepository;
  late String? _verificationId;

  Future<AppUser?> refreshUser() async {
    final user = await firebaseLoginRepository.getCurrentUser();
    if (user != null) {
      emit(FirebaseAuthLogedInState(appUser: user));
    }
    return user;
  }

  Future<AppUser?> getCurrentUser() async {
    final user = await firebaseLoginRepository.getCurrentUser();
    return user;
  }

  Stream<AppUser> getUserByUID(String uid) {
    return firebaseLoginRepository.getUserByUID(uid);
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

  Future<bool> verifyOTP(String otp) async {
    emit(FirebaseAuthLoadingState());
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otp,
    );
    return signInWithCredential(credential);
  }

  Future<bool> signInWithCredential(PhoneAuthCredential credential) async {
    emit(FirebaseAuthLoadingState());
    try {
      final userCredential =
          await firebaseLoginRepository.signInWithCredential(credential);
      if (userCredential.user != null) {
        emit(
          FirebaseAuthLogedInState(
            appUser: AppUser.fromFirebaseUser(userCredential.user!),
          ),
        );
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      emit(FirebaseAuthErrorState(error: e.message.toString()));
      return false;
    }
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
    logOut();
    emit(FirebaseAuthInitialState());
  }
}
