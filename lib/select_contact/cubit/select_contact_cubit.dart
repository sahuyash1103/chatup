
import 'package:bloc/bloc.dart';
import 'package:chatup/login/data/models/app_user.dart';
import 'package:chatup/select_contact/cubit/select_contact_state.dart';
import 'package:chatup/select_contact/data/models/app_contact.dart';
import 'package:chatup/select_contact/data/repositories/select_contact_repository.dart';

class SelectContactCubit extends Cubit<SelectContactState> {
  SelectContactCubit({required this.selectContactRepository})
      : super(SelectContactInitial());

  final SelectContactRepository selectContactRepository;

  Future<List<AppContact>> getContact() async {
    emit(SelectContactLoading());
    final contacts = await selectContactRepository.getContact();
    emit(SelectContactLoaded(contacts: contacts));
    return contacts;
  }

  Future<AppUser?> selectContact({required AppContact contact}) async {
    final user = await selectContactRepository.selectContact(contact: contact);
    return user;
  }

  void reset() {
    emit(SelectContactInitial());
  }
}
