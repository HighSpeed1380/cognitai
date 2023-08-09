// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

ApplePayConfig welcomeFromJson(String str) =>
    ApplePayConfig.fromJson(json.decode(str));

String applePayConfigToJson(ApplePayConfig data) => json.encode(data.toJson());

class ApplePayConfig {
  ApplePayConfig({
    required this.provider,
    required this.data,
  });

  String provider;
  Data data;

  factory ApplePayConfig.fromJson(Map<String, dynamic> json) => ApplePayConfig(
        provider: json["provider"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "provider": provider,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.merchantIdentifier,
    required this.displayName,
    required this.merchantCapabilities,
    required this.supportedNetworks,
    required this.countryCode,
    required this.currencyCode,
    required this.requiredBillingContactFields,
    required this.requiredShippingContactFields,
    required this.shippingMethods,
  });

  String merchantIdentifier;
  String displayName;
  List<String> merchantCapabilities;
  List<String> supportedNetworks;
  String countryCode;
  String currencyCode;
  List<String> requiredBillingContactFields;
  List<dynamic> requiredShippingContactFields;
  List<ShippingMethod> shippingMethods;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        merchantIdentifier: json["merchantIdentifier"],
        displayName: json["displayName"],
        merchantCapabilities:
            List<String>.from(json["merchantCapabilities"].map((x) => x)),
        supportedNetworks:
            List<String>.from(json["supportedNetworks"].map((x) => x)),
        countryCode: json["countryCode"],
        currencyCode: json["currencyCode"],
        requiredBillingContactFields: List<String>.from(
            json["requiredBillingContactFields"].map((x) => x)),
        requiredShippingContactFields: List<dynamic>.from(
            json["requiredShippingContactFields"].map((x) => x)),
        shippingMethods: List<ShippingMethod>.from(
            json["shippingMethods"].map((x) => ShippingMethod.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "merchantIdentifier": merchantIdentifier,
        "displayName": displayName,
        "merchantCapabilities":
            List<dynamic>.from(merchantCapabilities.map((x) => x)),
        "supportedNetworks":
            List<dynamic>.from(supportedNetworks.map((x) => x)),
        "countryCode": countryCode,
        "currencyCode": currencyCode,
        "requiredBillingContactFields":
            List<dynamic>.from(requiredBillingContactFields.map((x) => x)),
        "requiredShippingContactFields":
            List<dynamic>.from(requiredShippingContactFields.map((x) => x)),
        "shippingMethods":
            List<dynamic>.from(shippingMethods.map((x) => x.toJson())),
      };
}

class ShippingMethod {
  ShippingMethod({
    required this.amount,
    required this.detail,
    required this.identifier,
    required this.label,
  });

  String amount;
  String detail;
  String identifier;
  String label;

  factory ShippingMethod.fromJson(Map<String, dynamic> json) => ShippingMethod(
        amount: json["amount"],
        detail: json["detail"],
        identifier: json["identifier"],
        label: json["label"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "detail": detail,
        "identifier": identifier,
        "label": label,
      };
}
