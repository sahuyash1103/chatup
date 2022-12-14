import 'dart:io';

import 'package:chatup/login/cubit/firestore_state.dart';
import 'package:chatup/login/data/repositeries/firestore_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FirestoreCubit extends Cubit<FirestoreState> {
  FirestoreCubit({
    required this.firestoreRepository,
  }) : super(FirestoreInitial());

  final FirestoreRepository firestoreRepository;

  Future<void> saveUserDataToFireStore({
    required String name,
    File? profilePic,
    String? previousPic,
  }) async {
    emit(FirestoreSaveLoadingState());
    final error = await firestoreRepository.saveUserDataToFireStore(
      name: name,
      profilePic: profilePic,
      previousPic: previousPic,
    );

    if (error == null) {
      emit(FirestoreSavedState());
    } else {
      emit(FirestoreSaveErrorState(error: 'user data can not be uploaded'));
    }
  }

  Future<void> updateProfilPic(File profilePic) async {
    await firestoreRepository.updateProfilPic(profilePic);
  }

  Future<void> updateUser(Map<String, dynamic> user) async {
    await firestoreRepository.updateUser(user);
  }
}
