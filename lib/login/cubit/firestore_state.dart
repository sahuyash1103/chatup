class FirestoreState {}

class FirestoreInitial extends FirestoreState {}

class FirestoreSaveLoadingState extends FirestoreState {}

class FirestoreSavedState extends FirestoreState {}

class FirestoreSaveErrorState extends FirestoreState {
  FirestoreSaveErrorState({required this.error});
  final String error;
}

class FirestoreUpdatePicState extends FirestoreState {}

class FirestoreUpdatePicErrorState extends FirestoreState {
  FirestoreUpdatePicErrorState({required this.error});
  final String error;
}
