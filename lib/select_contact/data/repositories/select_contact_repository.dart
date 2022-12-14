import 'dart:developer';

import 'package:chatup/login/data/models/app_user.dart';
import 'package:chatup/select_contact/data/models/app_contact.dart';
import 'package:chatup/select_contact/data/providers/select_contact_provider.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

class SelectContactRepository {
  SelectContactRepository({required this.selectContactProvider});

  final SelectContactProvider selectContactProvider;

  Future<List<AppContact>> getContact() async {
    final contacts = <AppContact>[];
    try {
      if (await Permission.contacts.request().isGranted ||
          await FlutterContacts.requestPermission()) {
        final allContacts =
            await FlutterContacts.getContacts(withProperties: true);

        for (final contact in allContacts) {
          if (contact.phones.isEmpty ||
              contact.phones.first.number.replaceAll(' ', '').isEmpty) {
            continue;
          }

          final verifiedUser = await selectContactProvider
              .verify(contact.phones.first.number.replaceAll(' ', ''));

          if (verifiedUser != null) {
            contacts.add(AppContact.fromMap(verifiedUser));
          }
        }
      } else {
        log('Permission not granted');
      }
    } catch (e) {
      log('LOG: ${e.toString()}');
    }
    return contacts;
  }

  Future<AppUser?> selectContact({required AppContact contact}) async {
    final userMap = await selectContactProvider
        .selectContact(contact.phoneNumber.replaceAll(' ', ''));
    return userMap != null ? AppUser.fromMap(userMap) : null;
  }
}
