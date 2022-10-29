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

  Future<Map<String, dynamic>?> selectContact(String phoneNumber) async {
    try {
      final user = usersCollection!.docs.firstWhere(
        (element) => element.data()['phoneNumber'] == phoneNumber,
      );
      return user.data();
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> verify(String phoneNumber) async {
    try {
      final user = usersCollection!.docs.firstWhere(
        (element) => element.data()['phoneNumber'] == phoneNumber,
      );
      return user.data();
    } catch (e) {
      return null;
    }
  }
}
