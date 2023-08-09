import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class MessageStream {
  MessageStream(this.id, this.message, this.createdAt, this.isMine);
  String? id;
  String? message;
  String? createdAt;
  bool? isMine = false;
}

class ChatGPTObject {
  List<MessageStream>? messages;
  OpenAI? mainChatGPT;
  dynamic thisUser;
}
