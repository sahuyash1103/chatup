import 'package:chatup/login/data/models/app_user.dart';
import 'package:chatup/login/data/providers/firebase_login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginRepository {
  LoginRepository({
    required this.firebaseLoginProvider,
  });

  final LoginProvider firebaseLoginProvider;

  Stream<bool> isLoggedIn() {
    return firebaseLoginProvider
        .getLoggedInUserStates()
        .map((user) => user != null);
  }

  Stream<AppUser?> getLoggedInUserState() {
    return firebaseLoginProvider.getLoggedInUserStates().map((firebaseUser) {
      return firebaseUser == null
          ? null
          : AppUser.fromFirebaseUser(firebaseUser);
    });
  }

  Future<void> logOut() async {
    await firebaseLoginProvider.logOut();
  }

  Future<AppUser?> getCurrentUser() {
    return firebaseLoginProvider.getCurrentUserData();
  }

  Stream<AppUser> getUserByUID(String uid) {
    return firebaseLoginProvider.userData(uid);
  }

  Future<UserCredential> signInWithCredential(PhoneAuthCredential credential) {
    return firebaseLoginProvider.signInWithCredential(credential);
  }
}
