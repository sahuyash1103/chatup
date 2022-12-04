import 'dart:io';

import 'package:bloc/bloc.dart';

import 'package:chatup/chating/cubit/chat_state.dart';
import 'package:chatup/chating/data/enums/message_enums.dart';
import 'package:chatup/chating/data/models/chat_contact.dart';
import 'package:chatup/chating/data/models/message.dart';
import 'package:chatup/chating/data/repositories/chat_repository.dart';
import 'package:chatup/login/data/models/app_user.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({
    required this.chatRepository,
  }) : super(ChatInitial());
  final ChatRepository chatRepository;

  Stream<List<ChatContact>> fetchChatContacts() {
    return chatRepository.fetchChatContacts();
  }

  Stream<List<Message>> fetchMessages({required String contactID}) {
    return chatRepository.fetchMessages(contactID);
  }

  Future<void> sendTextMessage({
    required String text,
    required String recieverID,
    required AppUser sender,
  }) async {
    try {
      emit(ChatSendingState());
      await chatRepository.sendTextMessage(
        text: text,
        recieverID: recieverID,
        sender: sender,
      );
      emit(ChatSentState());
    } catch (e) {
      emit(ChatErrorState(e.toString()));
    }
  }

  Future<void> sendFileMessage({
    required File file,
    required String recieverID,
    required AppUser sender,
    required MessageEnum messageEnum,
  }) async {
    try {
      emit(ChatSendingState());
      await chatRepository.sendFileMessage(
        file: file,
        recieverID: recieverID,
        sender: sender,
        messageEnum: messageEnum,
      );
      emit(ChatSentState());
    } catch (e) {
      emit(ChatErrorState(e.toString()));
    }
  }

  Future<void> updateMessageStatus({required Message message}) async {
    try {
      await chatRepository.updateMessageStatus(message: message);
    } catch (e) {
      emit(ChatErrorState(e.toString()));
    }
  }
}
