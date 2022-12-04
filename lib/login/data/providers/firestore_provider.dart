import 'dart:io';

import 'package:chatup/common/services/firebase_messaging_service.dart';
import 'package:chatup/login/data/models/app_user.dart';
import 'package:chatup/var/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreProvider {
  FirestoreProvider({
    required this.firebaseAuth,
    required this.firestore,
    required this.firebaseStorage,
  });
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final FirebaseStorage firebaseStorage;

  Future<String> storeFileToFirebase(String path, File file) async {
    final uploadTask = firebaseStorage.ref().child(path).putFile(file);
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

      final fcmToken = FirebaseMessagingService.fcmToken;

      final user = AppUser(
        name: name,
        uid: uid,
        profilePic: photoUrl,
        isOnline: true,
        email: firebaseAuth.currentUser!.email ?? '',
        number: firebaseAuth.currentUser!.phoneNumber!,
        fcmToken: fcmToken ?? '',
        groupId: [],
      );

      await firestore.collection('users').doc(uid).set(user.toMap());
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> setUserOnlineStatus({required bool isOnline}) async {
    final uid = firebaseAuth.currentUser!.uid;
    await firestore.collection('users').doc(uid).update({
      'isOnline': isOnline,
    });
  }

  Future<void> updateFcmToken({required String fcmToken}) async {
    final uid = firebaseAuth.currentUser!.uid;
    await firestore.collection('users').doc(uid).update({
      'fcmToken': fcmToken,
    });
  }
}
