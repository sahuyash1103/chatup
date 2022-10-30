import 'dart:io';
import 'package:chatup/login/data/models/app_user.dart';
import 'package:chatup/login/data/providers/firebase_login.dart';

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

  Future<String?> saveUserDataToFireStore({
    required String name,
    File? profilePic,
    String? previousPic,
  }) async {
    return firebaseLoginProvider.saveUserDataToFireStore(
      name: name,
      profilePic: profilePic,
      previousPic: previousPic,
    );
  }

  Future<AppUser?> getCurrentUser() {
    return firebaseLoginProvider.getCurrentUserData();
  }

  Stream<AppUser> getUserByUID(String uid) {
    return firebaseLoginProvider.userData(uid);
  }
}
