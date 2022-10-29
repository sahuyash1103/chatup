import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:unreal_whatsapp/login/data/models/app_user.dart';
import 'package:unreal_whatsapp/var/strings.dart';

class LoginProvider {
  LoginProvider({
    required this.firebaseAuth,
    required this.firestore,
    required this.firebaseStorage,
  });
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final FirebaseStorage firebaseStorage;

  Stream<User?> getLoggedInUserStates() {
    return firebaseAuth.authStateChanges();
  }

  Future<void> logOut() async {
    await firebaseAuth.signOut();
  }

  Future<String> storeFileToFirebase(String ref, File file) async {
    final uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    final snap = await uploadTask;
    return snap.ref.getDownloadURL();
  }

  Future<String?> saveUserDataToFireStore({
    required String name,
    File? profilePic,
    String? previousPic,
  }) async {
    try {
      final uid = firebaseAuth.currentUser!.uid;
      var photoUrl = previousPic ?? defaultProfilePath;

      if (profilePic != null) {
        photoUrl = await storeFileToFirebase(
          'profilePic/$uid',
          profilePic,
        );
      }

      final user = AppUser(
        name: name,
        uid: uid,
        profilePic: photoUrl,
        isOnline: true,
        email: firebaseAuth.currentUser!.email ?? '',
        number: firebaseAuth.currentUser!.phoneNumber!,
        groupId: [],
      );

      await firestore.collection('users').doc(uid).set(user.toMap());
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<AppUser?> getCurrentUserData() async {
    final userData = await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser?.uid)
        .get();

    AppUser? user;
    if (userData.data() != null) {
      user = AppUser.fromMap(userData.data()!);
    }
    return user;
  }

  Stream<AppUser> userData(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map(
          (event) => AppUser.fromMap(
            event.data()!,
          ),
        );
  }

  Future<void> setUserState({required bool isOnline}) async {
    await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .update({
      'isOnline': isOnline,
    });
  }
}
