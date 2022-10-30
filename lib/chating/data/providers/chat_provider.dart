import 'package:chatup/chating/data/enums/message_enums.dart';
import 'package:chatup/chating/data/models/chat_contact.dart';
import 'package:chatup/chating/data/models/message.dart';
import 'package:chatup/login/data/models/app_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class ChatProvider {
  ChatProvider({required this.auth, required this.firestore});

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  Stream<List<ChatContact>> fetchChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      final contacts = <ChatContact>[];
      for (final document in event.docs) {
        final chatContact = ChatContact.fromMap(document.data());
        contacts.add(chatContact);
      }
      return contacts;
    });
  }

  Future<void> sendTextMessage({
    required String text,
    required String recieverID,
    required AppUser sender,
  }) async {
    try {
      final timeStamp = DateTime.now();
      final recieverMap =
          await firestore.collection('users').doc(recieverID).get();

      final messageID = const Uuid().v1();
      if (recieverMap.data() == null) return;
      final reciever = AppUser.fromMap(recieverMap.data()!);

      await _saveDataToContactSubCollection(
        sender: sender,
        reciever: reciever,
        text: text,
        timeStamp: timeStamp,
      );

      await _saveMessageToMessageSubCollection(
        recieverUserId: recieverID,
        recieverUserName: reciever.name,
        senderUserName: sender.name,
        messageID: messageID,
        text: text,
        timeStamp: timeStamp,
        messageType: MessageEnum.text,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _saveDataToContactSubCollection({
    required AppUser sender,
    required AppUser reciever,
    required DateTime timeStamp,
    required String text,
  }) async {
    final recieverChatContact = ChatContact(
      name: sender.name,
      profilePic: sender.profilePic,
      contactId: sender.uid,
      lastMessage: text,
      timeStamp: timeStamp,
    );

//* users -> reciever user id => chats -> current user id -> set data
    await firestore
        .collection('users')
        .doc(reciever.uid)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(recieverChatContact.toMap());

//* users -> current user id  => chats -> reciever user id -> set data
    final senderChatContact = ChatContact(
      name: reciever.name,
      profilePic: reciever.profilePic,
      contactId: reciever.uid,
      lastMessage: text,
      timeStamp: timeStamp,
    );

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(reciever.uid)
        .set(senderChatContact.toMap());
  }

  Future<void> _saveMessageToMessageSubCollection({
    required String recieverUserId,
    required String text,
    required DateTime timeStamp,
    required String messageID,
    required String senderUserName,
    required String recieverUserName,
    required MessageEnum messageType,
  }) async {
    final message = Message(
      senderId: auth.currentUser!.uid,
      recieverid: recieverUserId,
      text: text,
      messageType: messageType,
      timeStamp: timeStamp,
      messageId: messageID,
      isSeen: false,
    );

//* users -> sender id -> reciever id -> messages -> message id -> store message
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .doc(messageID)
        .set(message.toMap());

//* users -> eciever id  -> sender id -> messages -> message id -> store message
    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageID)
        .set(message.toMap());
  }

  Stream<List<Message>> fetchMessages(String contactID) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(contactID)
        .collection('messages')
        .orderBy('timeStamp')
        .snapshots()
        .asyncMap((event) async {
      final messages = <Message>[];
      for (final document in event.docs) {
        final message = Message.fromMap(document.data());
        messages.add(message);
      }
      return messages;
    });
  }
}
