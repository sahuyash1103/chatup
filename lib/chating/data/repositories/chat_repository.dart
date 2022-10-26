import 'package:unreal_whatsapp/chating/data/models/chat_contact.dart';
import 'package:unreal_whatsapp/chating/data/providers/chat_provider.dart';
import 'package:unreal_whatsapp/login/data/models/app_user.dart';

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
}
