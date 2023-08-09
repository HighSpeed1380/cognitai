// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

SettingModel settingModelFromJson(String str) =>
    SettingModel.fromJson(json.decode(str));

String settingModelToJson(SettingModel data) => json.encode(data.toJson());

class SettingModel {
  SettingModel({
    required this.idSetting,
    required this.title,
    required this.description,
    required this.valSetting,
    required this.flag,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  String idSetting;
  String title;
  String description;
  String valSetting;
  String flag;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  factory SettingModel.fromJson(Map<String, dynamic> json) => SettingModel(
        idSetting: json["id_setting"],
        title: json["title"],
        description: json["description"],
        valSetting: json["val_setting"],
        flag: json["flag"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id_setting": idSetting,
        "title": title,
        "description": description,
        "val_setting": valSetting,
        "flag": flag,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };

  bool get isEnabledAds => title == 'ENABLED_ADMOB' && valSetting == '1';
}
