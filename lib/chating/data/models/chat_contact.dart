
class ChatContact {
  ChatContact({
    required this.name,
    required this.profilePic,
    required this.contactId,
    required this.lastMessage,
    required this.timeStamp,
  });

  factory ChatContact.fromMap(Map<String, dynamic> map) {
    return ChatContact(
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      contactId: map['contactId'] as String,
      lastMessage: map['lastMessage'] as String,
      timeStamp: DateTime.fromMillisecondsSinceEpoch(map['timeStamp'] as int),
    );
  }

  final String name;
  final String profilePic;
  final String contactId;
  final String lastMessage;
  final DateTime timeStamp;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilePic': profilePic,
      'contactId': contactId,
      'lastMessage': lastMessage,
      'timeStamp': timeStamp.millisecondsSinceEpoch,
    };
  }
}
