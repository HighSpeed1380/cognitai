// To parse this JSON data, do
//
//     final user = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.idUser,
    required this.idInstall,
    required this.email,
    required this.phone,
    required this.userIdAuth,
    required this.displayName,
    required this.userName,
    required this.password,
    required this.website,
    required this.profilePic,
    required this.bannerImage,
    required this.bio,
    required this.location,
    required this.country,
    required this.latitude,
    required this.dob,
    required this.timestamp,
    required this.createdAt,
    required this.updatedAt,
    required this.expiredAt,
    required this.typePackage,
    required this.flag,
    required this.status,
    required this.typeAccount,
    required this.isVerified,
    required this.counterMax,
    required this.fcmToken,
    required this.followers,
    required this.following,
    required this.followersList,
    required this.followingList,
  });

  String idUser;
  String idInstall;
  String email;
  String phone;
  String userIdAuth;
  String displayName;
  String userName;
  String password;
  String website;
  String profilePic;
  String bannerImage;
  String bio;
  String location;
  String country;
  String latitude;
  String dob;
  DateTime timestamp;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime expiredAt;
  String typePackage;
  String flag;
  String status;
  String typeAccount;
  String isVerified;
  String counterMax;
  String fcmToken;
  String followers;
  String following;
  String followersList;
  String followingList;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        idUser: json["id_user"],
        idInstall: json["id_install"],
        email: json["email"],
        phone: json["phone"],
        userIdAuth: json["user_id_auth"],
        displayName: json["display_name"],
        userName: json["user_name"],
        password: json["password"],
        website: json["website"],
        profilePic: json["profile_pic"],
        bannerImage: json["banner_image"],
        bio: json["bio"],
        location: json["location"],
        country: json["country"],
        latitude: json["latitude"],
        dob: json["dob"],
        timestamp: DateTime.parse(json["timestamp"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        expiredAt: DateTime.parse(json["expired_at"]),
        typePackage: json["type_package"],
        flag: json["flag"],
        status: json["status"],
        typeAccount: json["type_account"],
        isVerified: json["is_verified"],
        counterMax: json["counter_max"],
        fcmToken: json["fcm_token"],
        followers: json["followers"],
        following: json["following"],
        followersList: json["followers_list"],
        followingList: json["following_list"],
      );

  Map<String, dynamic> toJson() => {
        "id_user": idUser,
        "id_install": idInstall,
        "email": email,
        "phone": phone,
        "user_id_auth": userIdAuth,
        "display_name": displayName,
        "user_name": userName,
        "password": password,
        "website": website,
        "profile_pic": profilePic,
        "banner_image": bannerImage,
        "bio": bio,
        "location": location,
        "country": country,
        "latitude": latitude,
        "dob": dob,
        "timestamp": timestamp.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "expired_at": expiredAt.toIso8601String(),
        "type_package": typePackage,
        "flag": flag,
        "status": status,
        "type_account": typeAccount,
        "is_verified": isVerified,
        "counter_max": counterMax,
        "fcm_token": fcmToken,
        "followers": followers,
        "following": following,
        "followers_list": followersList,
        "following_list": followingList,
      };
}
