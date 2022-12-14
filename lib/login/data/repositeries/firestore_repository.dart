import 'dart:io';

import 'package:chatup/login/data/providers/firestore_provider.dart';

class FirestoreRepository {
  FirestoreRepository({
    required this.firestoreProvider,
  });

  final FirestoreProvider firestoreProvider;

  Future<String?> saveUserDataToFireStore({
    required String name,
    File? profilePic,
    String? previousPic,
  }) async {
    return firestoreProvider.saveUserDataToFireStore(
      name: name,
      profilePic: profilePic,
      previousPic: previousPic,
    );
  }

  Future<void> updateProfilPic(File profilePic) async {
    return firestoreProvider.updateProfilPic(profilePic);
  }

  Future<void> updateUser(Map<String, dynamic> user) async {
    return firestoreProvider.updateUser(user: user);
  }
}
