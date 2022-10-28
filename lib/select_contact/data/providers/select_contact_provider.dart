
import 'package:cloud_firestore/cloud_firestore.dart';

class SelectContactProvider {
  SelectContactProvider({
    required this.firestore,
  }) {
    firestore
        .collection('users')
        .get()
        .then((users) => usersCollection = users);
  }

  final FirebaseFirestore firestore;
  QuerySnapshot<Map<String, dynamic>>? usersCollection;

  Future<Map<String, dynamic>> selectContact(String phoneNumber) async {
    final user = usersCollection!.docs.firstWhere(
      (element) => element.data()['phoneNumber'] == phoneNumber,
      orElse: () => throw Exception('User not found'),
    );
    return user.data();
  }

  Future<bool> verify(String phoneNumber) async {
    try {
      usersCollection!.docs.firstWhere(
        (element) => element.data()['phoneNumber'] == phoneNumber,
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
