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

   Future<void> setUserOnlineStatus({required bool isOnline}) async {
    return firestoreProvider.setUserOnlineStatus(isOnline: isOnline);
  }

  Future<void> updateFcmToken({required String fcmToken}) async {
    return firestoreProvider.updateFcmToken(fcmToken: fcmToken);
  }
}
