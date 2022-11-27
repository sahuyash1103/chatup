import 'package:chatup/login/data/models/app_user.dart';

abstract class FirebaseAuthState {}

class FirebaseAuthInitialState extends FirebaseAuthState {}

class FirebaseAuthCodeSentState extends FirebaseAuthState {}

class FirebaseAuthLoadingState extends FirebaseAuthState {}

class FirebaseAuthCodeVerifiedState extends FirebaseAuthState {}

class FirebaseAuthLogedInState extends FirebaseAuthState {
  FirebaseAuthLogedInState({required this.appUser});
  final AppUser appUser;
}

class FirebaseAuthFetchedUserState extends FirebaseAuthLogedInState {
  FirebaseAuthFetchedUserState({required super.appUser});
}

class FirebaseAuthLogedOutState extends FirebaseAuthState {}

class FirebaseAuthErrorState extends FirebaseAuthState {
  FirebaseAuthErrorState({required this.error});
  final String error;
}
