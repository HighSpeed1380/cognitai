import 'package:app/models/chat_model.dart';

class ChatUserMessage {
  String? key;
  String senderId;
  String receiverId;
  ChatMessage? message;
  String? channelName;

  ChatUserMessage({
    this.key,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.channelName,
  });

  factory ChatUserMessage.fromJson(Map<dynamic, dynamic> json) =>
      ChatUserMessage(
        key: json["key"],
        channelName: json["channel_name"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        message: json['message'] != null
            ? ChatMessage.fromJson(json['message'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "channel_name": channelName,
        "sender_id": senderId,
        "receiver_id": receiverId,
        "message": message != null ? message!.toJson() : null,
      };

  // new features
  factory ChatUserMessage.fromSnapshot(final snapshot) {
    final newChatUserMessage =
        ChatUserMessage.fromJson(snapshot.data() as Map<String, dynamic>);
    newChatUserMessage.key = snapshot.reference.id;
    return newChatUserMessage;
  }
}
