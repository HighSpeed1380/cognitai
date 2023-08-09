import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:app/models/chat_model.dart';

class PushNotificationModel {
  PushNotificationModel({
    required this.id,
    required this.type,
    required this.receiverId,
    required this.senderId,
    required this.title,
    required this.body,
    required this.tweetId,
    this.model,
  });

  final String? id;
  final String? type;
  final String receiverId;
  final String senderId;
  final String title;
  final String body;
  final String? tweetId;

  final ChatMessage? model;

  factory PushNotificationModel.fromRawJson(String str) =>
      PushNotificationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PushNotificationModel.fromJson(Map<dynamic, dynamic> json) {
    //debugPrint(json['json']);

    ChatMessage? dataMessage;
    if (json['json'] != null) {
      dataMessage = ChatMessage.fromJson(jsonDecode(json['json']));
      debugPrint(dataMessage.toJson().toString());
    }

    return PushNotificationModel(
      id: json["id"] ?? "1",
      type: json["type"],
      receiverId: json["receiverId"],
      senderId: json["senderId"],
      title: json["title"],
      body: json["body"],
      tweetId: json["tweetId"] ?? dataMessage!.key,
      model: dataMessage,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "receiverId": receiverId,
        "senderId": senderId,
        "title": title,
        "body": body,
        "tweetId": tweetId,
        "json": model != null ? model!.toJson() : null,
      };
}

class Notification {
  Notification({
    required this.body,
    required this.title,
  });

  final String body;
  final String title;

  factory Notification.fromRawJson(String str) =>
      Notification.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Notification.fromJson(Map<dynamic, dynamic> json) => Notification(
        body: json["body"],
        title: json["title"],
      );

  Map<dynamic, dynamic> toJson() => {
        "body": body,
        "title": title,
      };
}


/*
example message from fcm 
{image: , senderId: ZqfXH1MiWjXDLw7PxHZ5slgkxki1, receiverId: aa0CMiQwrMfIoceJPStCixFslMg1, json: {"channel_name":"ZqfXH-aa0CM","sender_verified":true,"receiver_id":"aa0CMiQwrMfIoceJPStCixFslMg1","receiver_profilepic":"https:\/\/firebasestorage.googleapis.com\/v0\/b\/ftwitter-71b6a.appspot.com\/o\/user%2Fprofile%2F%40Masteraa0c%2Fimage_picker2047749173424503730.jpg?alt=media&token=8cc4908a-8b98-45c9-8027-09ad99454545","created_at":"2023-01-20 08:03:42.131080Z","sender_name":"Ghazali Musk","message":"Here we go again","sender_id":"ZqfXH1MiWjXDLw7PxHZ5slgkxki1","seen":false,"is_read":false,"is_encrypt":false,"is_video":false,"sender_profilepic":"https:\/\/firebasestorage.googleapis.com\/v0\/b\/ftwitter-71b6a.appspot.com\/o\/user%2Fprofile%2F@Ghazalizqfx%2Fimage_picker_64B6B5B9-619D-417F-9D42-60A0D8B419AC-46182-00000C814D3EBADA.jpg?alt=media&token=52ce713f-3f27-4399-b9cb-c6dcc6eaf1aa","is_emoji":false,"receiver_verified":false,"receiver_name":"Master Ad


I/flutter (24814): PushNotificationService myBackgroundMessageHandler onBackGround false onLaunch false onMessage true
I/flutter (24814): PushNotificationService myBackgroundMessageHandler message {image: , senderId: ZqfXH1MiWjXDLw7PxHZ5slgkxki1, receiverId: aa0CMiQwrMfIoceJPStCixFslMg1, json: {"channel_name":"ZqfXH-aa0CM","sender_verified":true,"receiver_id":"aa0CMiQwrMfIoceJPStCixFslMg1","receiver_profilepic":"https:\/\/firebasestorage.googleapis.com\/v0\/b\/ftwitter-71b6a.appspot.com\/o\/user%2Fprofile%2F%40Masteraa0c%2Fimage_picker2047749173424503730.jpg?alt=media&token=8cc4908a-8b98-45c9-8027-09ad99454545","created_at":"2023-01-20 08:16:19.601007Z","sender_name":"Ghazali Musk","message":"Hello again #1","sender_id":"ZqfXH1MiWjXDLw7PxHZ5slgkxki1","seen":false,"is_read":false,"is_encrypt":false,"is_video":false,"sender_profilepic":"https:\/\/firebasestorage.googleapis.com\/v0\/b\/ftwitter-71b6a.appspot.com\/o\/user%2Fprofile%2F@Ghazalizqfx%2Fimage_picker_64B6B5B9-619D-417F-9D42-60A0D8B419AC-46182-00000C814D3EBADA.jpg?alt=media&token=52ce713f-3f27-4399-b9cb-c6dcc6eaf1aa","is_emoji":false,"receiver_verified":false,"receiver_name":"Master Admi
I/flutter (24814): message title Message from Ghazali Musk body Hello again #1 type NotificationType.Message

 */