class FirestoreState {}

class FirestoreInitial extends FirestoreState {}

class FirestoreSaveLoadingState extends FirestoreState {}

class FirestoreSavedState extends FirestoreState {}

class FirestoreSaveErrorState extends FirestoreState {
  FirestoreSaveErrorState({required this.error});
  final String error;
}
