import 'dart:developer';

import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unreal_whatsapp/login/data/models/app_user.dart';
import 'package:unreal_whatsapp/select_contact/data/models/app_contact.dart';
import 'package:unreal_whatsapp/select_contact/data/providers/select_contact_provider.dart';

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
      log(contacts.length.toString());
    } catch (e) {
      log(contacts.length.toString());

      log('LOG: ${e.toString()}');
    }
    log(contacts.length.toString());
    return contacts;
  }

  Future<AppUser?> selectContact({required AppContact contact}) async {
    final userMap = await selectContactProvider
        .selectContact(contact.phoneNumber.replaceAll(' ', ''));
    return userMap != null ? AppUser.fromMap(userMap) : null;
  }
}
