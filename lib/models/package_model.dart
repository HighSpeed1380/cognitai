// To parse this JSON data, do
//
//     final package = packageModelFromJson(jsonString);

import 'dart:convert';

PackageModel packageModelFromJson(String str) =>
    PackageModel.fromJson(json.decode(str));

String packageModelToJson(PackageModel data) => json.encode(data.toJson());

class PackageModel {
  PackageModel({
    required this.idPackage,
    required this.codePackage,
    required this.title,
    required this.description,
    this.image,
    required this.price,
    required this.currency,
    required this.excUsd,
    required this.duration,
    required this.counterTry,
    required this.flag,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.details,
  });

  String idPackage;
  String codePackage;
  String title;
  String description;
  dynamic image;
  String price;
  String currency;
  String excUsd;
  String duration;
  String counterTry;
  String flag;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  List<Detail> details;

  factory PackageModel.fromJson(Map<String, dynamic> json) => PackageModel(
        idPackage: json["id_package"],
        codePackage: json["code_package"],
        title: json["title"],
        description: json["description"],
        image: json["image"],
        price: json["price"],
        currency: json["currency"],
        excUsd: json["exc_usd"],
        duration: json["duration"],
        counterTry: json["counter_try"],
        flag: json["flag"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        details:
            List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id_package": idPackage,
        "code_package": codePackage,
        "title": title,
        "description": description,
        "image": image,
        "price": price,
        "currency": currency,
        "exc_usd": excUsd,
        "duration": duration,
        "counter_try": counterTry,
        "flag": flag,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
      };
}

class Detail {
  Detail({
    required this.idPackageDetail,
    required this.idPackage,
    required this.title,
    required this.description,
    this.image,
    required this.flag,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  String idPackageDetail;
  String idPackage;
  String title;
  String description;
  dynamic image;
  String flag;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        idPackageDetail: json["id_package_detail"],
        idPackage: json["id_package"],
        title: json["title"],
        description: json["description"],
        image: json["image"],
        flag: json["flag"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id_package_detail": idPackageDetail,
        "id_package": idPackage,
        "title": title,
        "description": description,
        "image": image,
        "flag": flag,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
