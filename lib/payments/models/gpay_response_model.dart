// To parse this JSON data, do
//  https://app.quicktype.io/
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

GPayResponseModel welcomeFromJson(String str) =>
    GPayResponseModel.fromJson(json.decode(str));

String gPayResponseModelToJson(GPayResponseModel data) =>
    json.encode(data.toJson());

class GPayResponseModel {
  GPayResponseModel({
    required this.apiVersion,
    required this.apiVersionMinor,
    required this.paymentMethodData,
  });

  int apiVersion;
  int apiVersionMinor;
  PaymentMethodData paymentMethodData;

  factory GPayResponseModel.fromJson(Map<String, dynamic> json) =>
      GPayResponseModel(
        apiVersion: json["apiVersion"],
        apiVersionMinor: json["apiVersionMinor"],
        paymentMethodData:
            PaymentMethodData.fromJson(json["paymentMethodData"]),
      );

  Map<String, dynamic> toJson() => {
        "apiVersion": apiVersion,
        "apiVersionMinor": apiVersionMinor,
        "paymentMethodData": paymentMethodData.toJson(),
      };
}

class PaymentMethodData {
  PaymentMethodData({
    required this.description,
    required this.info,
    required this.tokenizationData,
    required this.type,
  });

  String description;
  Info info;
  TokenizationData tokenizationData;
  String type;

  factory PaymentMethodData.fromJson(Map<String, dynamic> json) =>
      PaymentMethodData(
        description: json["description"],
        info: Info.fromJson(json["info"]),
        tokenizationData: TokenizationData.fromJson(json["tokenizationData"]),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "info": info.toJson(),
        "tokenizationData": tokenizationData.toJson(),
        "type": type,
      };
}

class Info {
  Info({
    required this.billingAddress,
    required this.cardDetails,
    required this.cardNetwork,
  });

  BillingAddress billingAddress;
  String cardDetails;
  String cardNetwork;

  factory Info.fromJson(Map<String, dynamic> json) => Info(
        billingAddress: BillingAddress.fromJson(json["billingAddress"]),
        cardDetails: json["cardDetails"],
        cardNetwork: json["cardNetwork"],
      );

  Map<String, dynamic> toJson() => {
        "billingAddress": billingAddress.toJson(),
        "cardDetails": cardDetails,
        "cardNetwork": cardNetwork,
      };
}

class BillingAddress {
  BillingAddress({
    required this.address1,
    required this.address2,
    required this.address3,
    required this.administrativeArea,
    required this.countryCode,
    required this.locality,
    required this.name,
    required this.phoneNumber,
    required this.postalCode,
    required this.sortingCode,
  });

  String address1;
  String address2;
  String address3;
  String administrativeArea;
  String countryCode;
  String locality;
  String name;
  String phoneNumber;
  String postalCode;
  String sortingCode;

  factory BillingAddress.fromJson(Map<String, dynamic> json) => BillingAddress(
        address1: json["address1"],
        address2: json["address2"],
        address3: json["address3"],
        administrativeArea: json["administrativeArea"],
        countryCode: json["countryCode"],
        locality: json["locality"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        postalCode: json["postalCode"],
        sortingCode: json["sortingCode"],
      );

  Map<String, dynamic> toJson() => {
        "address1": address1,
        "address2": address2,
        "address3": address3,
        "administrativeArea": administrativeArea,
        "countryCode": countryCode,
        "locality": locality,
        "name": name,
        "phoneNumber": phoneNumber,
        "postalCode": postalCode,
        "sortingCode": sortingCode,
      };
}

class TokenizationData {
  TokenizationData({
    required this.token,
    required this.type,
  });

  String token;
  String type;

  factory TokenizationData.fromJson(Map<String, dynamic> json) =>
      TokenizationData(
        token: json["token"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "type": type,
      };
}
