import 'dart:convert';
import 'package:app/models/user_model.dart';

class NotificationModel {
  String? id;
  String? tweetKey;
  String? updatedAt;
  String? createdAt;
  String? profileId;
  String? userId;
  late String? type;
  Map<String, dynamic>? data;

  NotificationModel({
    this.id,
    this.tweetKey,
    required this.type,
    required this.createdAt,
    this.updatedAt,
    this.profileId,
    required this.userId,
    required this.data,
  });

  NotificationModel.fromJson(String tweetId, Map<dynamic, dynamic> map) {
    id = map["id"] ?? tweetId;
    Map<String, dynamic> data = {};
    if (map.containsKey('data')) {
      data = json.decode(json.encode(map["data"])) as Map<String, dynamic>;
    }

    tweetKey = map["tweetKey"] ?? tweetId;
    profileId = map["profileId"];
    userId = map["userId"];
    updatedAt = map["updatedAt"];
    type = map["type"];
    createdAt = map["created_at"];
    this.data = data;
  }

  factory NotificationModel.fromNewJson(Map<dynamic, dynamic> map) {
    return NotificationModel.fromJson(map['id'] ?? map['tweetKey'], map);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "tweetKey": tweetKey,
        "updatedAt": updatedAt,
        "type": type,
        "created_at": createdAt,
        "userId": userId,
        "profileId": profileId,
        "data": data
      };

  // final DocumentSnapshot
  factory NotificationModel.fromSnapshot(final snapshot) {
    final newNotification = NotificationModel.fromJson(
        snapshot.reference.id, snapshot.data() as Map<dynamic, dynamic>);
    newNotification.id = snapshot.reference.id;
    return newNotification;
  }
}

extension NotificationModelHelper on NotificationModel {
  UserModel get user => UserModel.fromJson(data!);

  DateTime? get timeStamp => updatedAt != null || createdAt != null
      ? DateTime.tryParse(updatedAt ?? createdAt!)
      : null;
}
