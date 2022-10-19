import 'package:bloc/bloc.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:unreal_whatsapp/login/data/models/app_user.dart';
import 'package:unreal_whatsapp/select_contact/bloc/select_contact_state.dart';
import 'package:unreal_whatsapp/select_contact/data/repositories/select_contact.dart';

class SelectContactCubit extends Cubit<SelectContactState> {
  SelectContactCubit({required this.selectContactRepository})
      : super(SelectContactInitial());

  final SelectContactRepository selectContactRepository;

  Future<List<Contact>> getContact() async {
    emit(SelectContactLoading());
    final contacts = await selectContactRepository.getContact();
    emit(SelectContactLoaded(contacts: contacts));
    return contacts;
  }

  Future<AppUser?> selectContact({required Contact contact}) async {
    try {
      final user =
          await selectContactRepository.selectContact(contact: contact);
      return user;
    } catch (e) {
      if (e is Exception) {
        return null;
      } else {
        emit(SelectContactError(message: e.toString()));
        return null;
      }
    }
  }
}
