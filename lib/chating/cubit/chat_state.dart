abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatSendingState extends ChatState {}

class ChatSentState extends ChatState {}

class ChatErrorState extends ChatState {
  ChatErrorState(this.error);

  final String error;
}
