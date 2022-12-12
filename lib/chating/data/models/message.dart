import 'package:chatup/chating/data/enums/message_enums.dart';

class Message {
  Message({
    required this.senderId,
    required this.recieverId,
    required this.text,
    required this.messageType,
    required this.timeStamp,
    required this.messageId,
    required this.isSeen,
    // required this.repliedMessage,
    // required this.repliedTo,
    // required this.repliedMessageType,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] as String,
      recieverId: map['recieverId'] as String,
      text: map['text'] as String,
      messageType: (map['type'] as String).toMessageEnum(),
      timeStamp: DateTime.fromMillisecondsSinceEpoch(map['timeStamp'] as int),
      messageId: map['messageId'] as String,
      isSeen: map['isSeen'] as bool,
      // repliedMessage: map['repliedMessage'] as String,
      // repliedTo: map['repliedTo'] as String,
      // repliedMessageType:
      // (map['repliedMessageType'] as String) as MessageEnum,
    );
  }

  final String senderId;
  final String recieverId;
  final String text;
  final MessageEnum messageType;
  final DateTime timeStamp;
  final String messageId;
  bool isSeen;
  // final String repliedMessage;
  // final String repliedTo;
  // final MessageEnum repliedMessageType;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'recieverId': recieverId,
      'text': text,
      'type': messageType.type,
      'timeStamp': timeStamp.millisecondsSinceEpoch,
      'messageId': messageId,
      'isSeen': isSeen,
      // 'repliedMessage': repliedMessage,
      // 'repliedTo': repliedTo,
      // 'repliedMessageType': repliedMessageType.type,
    };
  }
}
