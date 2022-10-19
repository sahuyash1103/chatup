import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unreal_whatsapp/login/data/models/app_user.dart';

class SelectContactRepository {
  SelectContactRepository({required this.firebaseStorage});
  final FirebaseStorage firebaseStorage;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Contact>> getContact() async {
    var contacts = <Contact>[];
    try {
      if (await Permission.contacts.request().isGranted ||
          await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      } else {
        log('Permission not granted');
      }
    } catch (e) {
      log('LOG: ${e.toString()}');
    }
    return contacts;
  }

  Future<AppUser> selectContact({required Contact contact}) async {
    final userCollection = await firestore.collection('users').get();
    final user = userCollection.docs.firstWhere(
      (element) =>
          element.data()['phoneNumber'] ==
          contact.phones.first.number.replaceAll(' ', ''),
      orElse: () => throw Exception('User not found'),
    );
    return AppUser.fromMap(user.data());
  }
}
