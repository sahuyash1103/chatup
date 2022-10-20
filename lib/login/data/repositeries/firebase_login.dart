import 'dart:io';
import 'package:unreal_whatsapp/login/data/models/app_user.dart';
import 'package:unreal_whatsapp/login/data/providers/firebase_login.dart';

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
  }) async {
    return firebaseLoginProvider.saveUserDataToFireStore(
      name: name,
      profilePic: profilePic,
    );
  }

  Future<AppUser?> getCurrentUser() {
    return firebaseLoginProvider.getCurrentUserData();
  }

  Stream<AppUser> getUserByUID(String uid) {
    return firebaseLoginProvider.userData(uid);
  }
}
