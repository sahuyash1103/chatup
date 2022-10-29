class AppContact {
  AppContact({
    required this.phoneNumber,
    required this.profilePic,
    required this.name,
  });

  factory AppContact.fromMap(Map<String, dynamic> user) {
    return AppContact(
      name: user['name'] as String,
      phoneNumber: user['phoneNumber'] as String,
      profilePic: user['profilePic'] as String,
    );
  }

  String name;
  String phoneNumber;
  String profilePic;
}
