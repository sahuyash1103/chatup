import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.number,
    required this.profilePic,
    this.groupId = const [],
    this.isOnline = false,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      name: map['name'] as String,
      uid: map['uid'] as String,
      profilePic: map['profilePic'] as String,
      number: map['phoneNumber'] as String,
      email: map['email'] != null ? map['email'] as String : '',
      groupId: List<String>.from(map['groupId'] as List),
      isOnline: map['isOnline'] as bool,
    );
  }

  factory AppUser.fromFirebaseUser(User user) {
    return AppUser(
      uid: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      profilePic: user.photoURL ?? '',
      number: user.phoneNumber ?? '',
    );
  }
  String uid;
  String name;
  String email;
  String number;
  String profilePic;
  List<dynamic> groupId;
  bool isOnline;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'phoneNumber': number,
      'groupId': groupId,
    };
  }
}
