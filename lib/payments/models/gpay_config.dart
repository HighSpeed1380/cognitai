// To parse this JSON data, do
//  https://app.quicktype.io/
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

GPayConfig welcomeFromJson(String str) => GPayConfig.fromJson(json.decode(str));

String gPayConfigoJson(GPayConfig data) => json.encode(data.toJson());

class GPayConfig {
  GPayConfig({
    required this.provider,
    required this.data,
  });

  String provider;
  Data data;

  factory GPayConfig.fromJson(Map<String, dynamic> json) => GPayConfig(
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
    required this.environment,
    required this.apiVersion,
    required this.apiVersionMinor,
    required this.allowedPaymentMethods,
    required this.merchantInfo,
    required this.transactionInfo,
  });

  String environment;
  int apiVersion;
  int apiVersionMinor;
  List<AllowedPaymentMethod> allowedPaymentMethods;
  MerchantInfo merchantInfo;
  TransactionInfo transactionInfo;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        environment: json["environment"],
        apiVersion: json["apiVersion"],
        apiVersionMinor: json["apiVersionMinor"],
        allowedPaymentMethods: List<AllowedPaymentMethod>.from(
            json["allowedPaymentMethods"]
                .map((x) => AllowedPaymentMethod.fromJson(x))),
        merchantInfo: MerchantInfo.fromJson(json["merchantInfo"]),
        transactionInfo: TransactionInfo.fromJson(json["transactionInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "environment": environment,
        "apiVersion": apiVersion,
        "apiVersionMinor": apiVersionMinor,
        "allowedPaymentMethods":
            List<dynamic>.from(allowedPaymentMethods.map((x) => x.toJson())),
        "merchantInfo": merchantInfo.toJson(),
        "transactionInfo": transactionInfo.toJson(),
      };
}

class AllowedPaymentMethod {
  AllowedPaymentMethod({
    required this.type,
    required this.tokenizationSpecification,
    required this.parameters,
  });

  String type;
  TokenizationSpecification tokenizationSpecification;
  AllowedPaymentMethodParameters parameters;

  factory AllowedPaymentMethod.fromJson(Map<String, dynamic> json) =>
      AllowedPaymentMethod(
        type: json["type"],
        tokenizationSpecification: TokenizationSpecification.fromJson(
            json["tokenizationSpecification"]),
        parameters: AllowedPaymentMethodParameters.fromJson(json["parameters"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "tokenizationSpecification": tokenizationSpecification.toJson(),
        "parameters": parameters.toJson(),
      };
}

class AllowedPaymentMethodParameters {
  AllowedPaymentMethodParameters({
    required this.allowedCardNetworks,
    required this.allowedAuthMethods,
    required this.billingAddressRequired,
    required this.billingAddressParameters,
  });

  List<String> allowedCardNetworks;
  List<String> allowedAuthMethods;
  bool billingAddressRequired;
  BillingAddressParameters billingAddressParameters;

  factory AllowedPaymentMethodParameters.fromJson(Map<String, dynamic> json) =>
      AllowedPaymentMethodParameters(
        allowedCardNetworks:
            List<String>.from(json["allowedCardNetworks"].map((x) => x)),
        allowedAuthMethods:
            List<String>.from(json["allowedAuthMethods"].map((x) => x)),
        billingAddressRequired: json["billingAddressRequired"],
        billingAddressParameters:
            BillingAddressParameters.fromJson(json["billingAddressParameters"]),
      );

  Map<String, dynamic> toJson() => {
        "allowedCardNetworks":
            List<dynamic>.from(allowedCardNetworks.map((x) => x)),
        "allowedAuthMethods":
            List<dynamic>.from(allowedAuthMethods.map((x) => x)),
        "billingAddressRequired": billingAddressRequired,
        "billingAddressParameters": billingAddressParameters.toJson(),
      };
}

class BillingAddressParameters {
  BillingAddressParameters({
    required this.format,
    required this.phoneNumberRequired,
  });

  String format;
  bool phoneNumberRequired;

  factory BillingAddressParameters.fromJson(Map<String, dynamic> json) =>
      BillingAddressParameters(
        format: json["format"],
        phoneNumberRequired: json["phoneNumberRequired"],
      );

  Map<String, dynamic> toJson() => {
        "format": format,
        "phoneNumberRequired": phoneNumberRequired,
      };
}

class TokenizationSpecification {
  TokenizationSpecification({
    required this.type,
    required this.parameters,
  });

  String type;
  TokenizationSpecificationParameters parameters;

  factory TokenizationSpecification.fromJson(Map<String, dynamic> json) =>
      TokenizationSpecification(
        type: json["type"],
        parameters:
            TokenizationSpecificationParameters.fromJson(json["parameters"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "parameters": parameters.toJson(),
      };
}

class TokenizationSpecificationParameters {
  TokenizationSpecificationParameters({
    required this.gateway,
    required this.gatewayMerchantId,
  });

  String gateway;
  String gatewayMerchantId;

  factory TokenizationSpecificationParameters.fromJson(
          Map<String, dynamic> json) =>
      TokenizationSpecificationParameters(
        gateway: json["gateway"],
        gatewayMerchantId: json["gatewayMerchantId"],
      );

  Map<String, dynamic> toJson() => {
        "gateway": gateway,
        "gatewayMerchantId": gatewayMerchantId,
      };
}

class MerchantInfo {
  MerchantInfo({
    required this.merchantId,
    required this.merchantName,
  });

  String merchantId;
  String merchantName;

  factory MerchantInfo.fromJson(Map<String, dynamic> json) => MerchantInfo(
        merchantId: json["merchantId"],
        merchantName: json["merchantName"],
      );

  Map<String, dynamic> toJson() => {
        "merchantId": merchantId,
        "merchantName": merchantName,
      };
}

class TransactionInfo {
  TransactionInfo({
    required this.countryCode,
    required this.currencyCode,
  });

  String countryCode;
  String currencyCode;

  factory TransactionInfo.fromJson(Map<String, dynamic> json) =>
      TransactionInfo(
        countryCode: json["countryCode"],
        currencyCode: json["currencyCode"],
      );

  Map<String, dynamic> toJson() => {
        "countryCode": countryCode,
        "currencyCode": currencyCode,
      };
}
