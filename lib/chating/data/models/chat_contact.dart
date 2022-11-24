
class ChatContact {
  ChatContact({
    required this.name,
    required this.profilePic,
    required this.contactId,
    required this.lastMessage,
    // required this.isOnline,
    required this.timeStamp,
  });

  factory ChatContact.fromMap(Map<String, dynamic> map) {
    return ChatContact(
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      contactId: map['contactId'] as String,
      lastMessage: map['lastMessage'] as String,
      // isOnline: map['isOnline'] as bool,
      timeStamp: DateTime.fromMillisecondsSinceEpoch(map['timeStamp'] as int),
    );
  }

  final String name;
  final String profilePic;
  final String contactId;
  final String lastMessage;
  // final bool isOnline;
  final DateTime timeStamp;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilePic': profilePic,
      'contactId': contactId,
      'lastMessage': lastMessage,
      // 'isOnline': isOnline,
      'timeStamp': timeStamp.millisecondsSinceEpoch,
    };
  }
}
