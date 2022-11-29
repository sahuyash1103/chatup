import 'package:chatup/login/data/models/app_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SettingsProvider {
  SettingsProvider({
    required this.firebaseAuth,
    required this.firebaseStorage,
    required this.firestore,
  });

  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final FirebaseStorage firebaseStorage;

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

  Future<void> updateUser({required Map<String, dynamic> user}) async {
    await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .update(user);
  }
}
