import 'dart:async';

import 'package:chatup/login/data/models/app_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseAuthProvider {
  FirebaseAuthProvider({
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

  Future<AppUser?> getCurrentUserData() async {
    if (firebaseAuth.currentUser == null) return null;
    final userData = await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
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

  Future<UserCredential> signInWithCredential(PhoneAuthCredential credential) {
    return firebaseAuth.signInWithCredential(credential);
  }

  Future<void> setUserOnlineStatus({required bool isOnline}) async {
    await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .update({
      'isOnline': isOnline,
    });
  }
}
