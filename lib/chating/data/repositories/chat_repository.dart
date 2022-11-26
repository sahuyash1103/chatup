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

  Stream<List<Message>> fetchMessages(String contactID) {
    return chatProvider.fetchMessages(contactID);
  }

  Future<void> updateMessageStatus({required Message message}) async {
    return chatProvider.updateMessageStatus(message: message);
  }
}
