class ChatMessage {
  String? key;
  String senderId;
  String senderName;
  String senderProfilePic;
  bool? senderVerified;

  String? message;
  bool seen;
  String? createdAt;
  String timeStamp;

  String receiverId;
  String? receiverName;
  String? receiverProfilePic;
  bool? receiverVerified;
  String channelName;

  bool isImage;
  bool isEmoji;
  bool isVideo;
  bool isRead;
  bool isEncrypt;
  bool isSelected;
  bool showCheck;

  ChatMessage(
      {this.key,
      required this.senderId,
      required this.senderName,
      required this.senderProfilePic,
      required this.senderVerified,
      this.message,
      required this.seen,
      this.createdAt,
      this.isEmoji = false,
      this.isImage = false,
      this.isVideo = false,
      this.isRead = false,
      this.isEncrypt = false,
      this.isSelected = false,
      this.showCheck = false,
      required this.channelName,
      required this.receiverId,
      required this.receiverName,
      required this.receiverProfilePic,
      required this.receiverVerified,
      required this.timeStamp});

  factory ChatMessage.fromJson(Map<dynamic, dynamic> json) => ChatMessage(
        key: json["key"],
        channelName: json["channel_name"],
        senderId: json["sender_id"],
        senderName: json["sender_name"],
        senderProfilePic: json["sender_profilepic"],
        senderVerified: json["sender_verified"] ?? false,
        message: json["message"],
        seen: json["seen"],
        createdAt: json["created_at"],
        isEmoji: json["is_emoji"] ?? false,
        isImage: json["is_image"] ?? false,
        isVideo: json["is_video"] ?? false,
        isRead: json["is_read"] ?? false,
        isEncrypt: json["is_encrypt"] ?? false,
        timeStamp: json['timestamp'],
        receiverId: json["receiver_id"],
        receiverName: json["receiver_name"],
        receiverProfilePic: json["receiver_profilepic"],
        receiverVerified: json["receiver_verified"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "channel_name": channelName,
        "sender_id": senderId,
        "sender_name": senderName,
        "sender_profilepic": senderProfilePic,
        "sender_verified": senderVerified,
        "message": message,
        "receiver_id": receiverId,
        "receiver_name": receiverName,
        "receiver_profilepic": receiverProfilePic,
        "receiver_verified": receiverVerified,
        "seen": seen,
        "created_at": createdAt,
        "is_emoji": isEmoji,
        "is_image": isImage,
        "is_video": isVideo,
        "is_read": isRead,
        "is_encrypt": isEncrypt,
        "timestamp": timeStamp,
      };

  // new features
  factory ChatMessage.fromSnapshot(final snapshot) {
    final newChatMessage =
        ChatMessage.fromJson(snapshot.data() as Map<String, dynamic>);
    newChatMessage.key = snapshot.reference.id;
    return newChatMessage;
  }
}
