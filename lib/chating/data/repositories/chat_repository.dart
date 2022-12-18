import 'dart:io';

import 'package:chatup/chating/data/enums/message_enums.dart';
import 'package:chatup/chating/data/models/chat_contact.dart';
import 'package:chatup/chating/data/models/message.dart';
import 'package:chatup/chating/data/providers/chat_provider.dart';
import 'package:chatup/login/data/models/app_user.dart';

class ChatRepository {
  ChatRepository({required this.chatProvider});
  final ChatProvider chatProvider;

  Stream<List<ChatContact>> fetchChatContacts() {
    return chatProvider.fetchChatContacts();
  }

  Future<void> sendTextMessage({
    required String text,
    required String recieverID,
    required AppUser sender,
  }) async {
    await chatProvider.sendTextMessage(
      text: text,
      recieverID: recieverID,
      sender: sender,
    );
  }

  Future<void> sendFileMessage({
    required File file,
    required String recieverID,
    required AppUser sender,
    required MessageEnum messageEnum,
  }) async {
    await chatProvider.sendFileMessage(
      file: file,
      recieverID: recieverID,
      sender: sender,
      messageEnum: messageEnum,
    );
  }

  Stream<List<Message>> fetchMessages(String contactID) {
    return chatProvider.fetchMessages(contactID);
  }

  Future<void> updateMessageStatus({required Message message}) async {
    return chatProvider.updateMessageStatus(message: message);
  }

  Future<void> sendGIFMessage({
    required String gifUrl,
    required String recieverID,
    required AppUser sender,
  }) async {
    final gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
    final gifUrlPart = gifUrl.substring(gifUrlPartIndex);
    final newGifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';
    await chatProvider.sendGIFMessage(
      gifUrl: newGifUrl,
      recieverID: recieverID,
      sender: sender,
    );
  }
}
