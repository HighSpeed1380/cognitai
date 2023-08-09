import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/app/home_page.dart';
import 'package:app/helpers/app_controller.dart';
import 'package:app/helpers/constants.dart';
import 'package:app/helpers/utility.dart';
import 'package:app/pages/packages/widgets/card_package_item.dart';
import 'package:pay/pay.dart';
import 'package:app/payments/pay_with_applepay.dart';
import 'package:app/payments/pay_with_googlepay.dart';
import 'package:app/payments/pay_with_paypal.dart';
import 'package:app/services/repository/user_repository.dart';

class PackageOrder extends StatelessWidget {
  final dynamic item;
  final dynamic method;
  final int index;

  PackageOrder(
      {super.key,
      required this.item,
      required this.method,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      color: Colors.white,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              topHeader(),
              const SizedBox(height: 5),
              Container(
                height: Get.height / 2,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: CardPackageItem(
                    package: item, color: Constants.colors[index]),
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  Center(
                    child: buttonPay(method['title'],
                        isFree: item['price'].toString() == '0'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonPay(final String methodPay, {bool isFree = false}) {
    //debugPrint("${item['price'].toString()}");

    if (isFree) {
      // this button free
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Get.theme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                )),
            child: const Text("Confirm & Submit"),
            onPressed: () {
              successProcess(item, method['title'], isFree: true);
            },
          ));
    }

    final paymentItems = [
      PaymentItem(
        label: item['title'].toString(),
        amount: item['price'].toString(),
        status: PaymentItemStatus.final_price,
      )
    ];

    if (methodPay == 'GooglePay') {
      debugPrint(paymentItems[0].amount.toString());

      return PayWithGooglePay(
        itemToPay: item,
        method: methodPay,
        payPrice: double.parse(item['price'].toString()),
      );
    }

    if (methodPay == 'ApplePay') {
      return PayWithApplePay(
        itemToPay: item,
        method: methodPay,
        payPrice: double.parse(item['price'].toString()),
      );
    }

    // this button paypal
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Get.theme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              )),
          child: Image.asset(
            "assets/paypal_001.png",
            width: 80,
          ),
          onPressed: () {
            Get.to(PayWithPaypal(
              itemToPay: item,
              method: methodPay,
              payPrice: double.parse(item['price'].toString()),
            ));
          },
        ));
  }

  final UserRepository userRepository = UserRepository();
  final AppController appController = AppController.to;

  successProcess(final dynamic method, final String codeMethod,
      {bool isFree = false}) async {
    debugPrint("package order successProcess is running");
    appController.showLoadingBottom(height: Get.height / 3.5);

    await Future.delayed(const Duration(milliseconds: 1200), () async {
      debugPrint("package order goto home page");

      appController.box.pCodePackage.val = method['code_package'].toString();

      final jsonPush = {
        "type_package": method['code_package'].toString(),
        "max": method['counter_try'].toString(),
        "code_method": codeMethod,
      };

      debugPrint(jsonPush.toString());

      final Response? responsePay = await userRepository.payPackage(jsonPush);
      if (responsePay != null &&
          responsePay.statusCode == 200 &&
          responsePay.bodyString != null) {
        dynamic dataresultPay = jsonDecode(responsePay.bodyString!);
        debugPrint(dataresultPay.toString());

        if (dataresultPay['result'] != null && dataresultPay['code'] == '200') {
          await Future.delayed(const Duration(milliseconds: 1200));
          final Response? response =
              await userRepository.updatePackage(jsonPush);

          if (response != null &&
              response.statusCode == 200 &&
              response.bodyString != null) {
            dynamic dataresult = jsonDecode(response.bodyString!);
            debugPrint(dataresult.toString());

            if (dataresult['result'] != null && dataresult['code'] == '200') {
              List<dynamic> jsonResp = dataresult['result'];
              dynamic rowUser = jsonResp[0];
              appController.box.pCodePackage.val =
                  rowUser['type_package'].toString();
              appController.box.pUserData.val = jsonEncode(rowUser);

              await Future.delayed(const Duration(milliseconds: 1800));
              appController.showSuccessBottom(callback: () {
                Get.offAll(HomePage());
              });
            } else {
              Utility.customSnackBar(Get.context!,
                  'Error order package, ${dataresult['message']}');
            }
          } else {
            Utility.customSnackBar(
                Get.context!, 'No Response, Try again later...!');
          }
        }
      }
    });
  }

  failedProcess() {
    Future.delayed(const Duration(milliseconds: 1800), () {
      Utility.customSnackBar(
          Get.context!, 'Your payment is failed, try again later');
    });
  }

  Widget topHeader() {
    return Container(
      width: Get.width,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        BootstrapIcons.chevron_left,
                        color: Get.theme.primaryColor,
                      )),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text("Order Package Information",
                        style: Get.theme.textTheme.labelMedium!
                            .copyWith(color: Colors.grey[500])),
                    Text(Constants.labelPlaceOrder,
                        style: Get.theme.textTheme.titleLarge),
                    const SizedBox(height: 5),
                  ],
                ),
              ],
            ),
            Icon(BootstrapIcons.currency_dollar,
                color: Get.theme.primaryColor, size: 30)
          ],
        ),
      ),
    );
  }
}

enum MethodPay { googlepay, applepay, paypal }

const String defaultGooglePayConfigString = '''{
  "provider": "google_pay",
  "data": {
    "environment": "TEST",
    "apiVersion": 2,
    "apiVersionMinor": 0,
    "allowedPaymentMethods": [
      {
        "type": "CARD",
        "tokenizationSpecification": {
          "type": "PAYMENT_GATEWAY",
          "parameters": {
            "gateway": "example",
            "gatewayMerchantId": "gatewayMerchantId"
          }
        },
        "parameters": {
          "allowedCardNetworks": ["VISA", "MASTERCARD"],
          "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
          "billingAddressRequired": true,
          "billingAddressParameters": {
            "format": "FULL",
            "phoneNumberRequired": true
          }
        }
      }
    ],
    "merchantInfo": {
      "merchantId": "BCR2DN4TXL7MNML3",
      "merchantName": "Erhacorpdotcom Merchant"
    },
    "transactionInfo": {
      "countryCode": "US",
      "currencyCode": "USD"
    }
  }
}''';

const String defaultApplePay = '''{
  "provider": "apple_pay",
  "data": {
    "merchantIdentifier": "merchant.com.cognitaigpt.app",
    "displayName": "Erhacorp Dotcom",
    "merchantCapabilities": ["3DS", "debit", "credit"],
    "supportedNetworks": ["amex", "visa", "discover", "masterCard"],
    "countryCode": "US",
    "currencyCode": "USD",
    "requiredBillingContactFields": ["emailAddress", "name", "phoneNumber", "postalAddress"],
    "requiredShippingContactFields": []
  }
}''';

/*
"shippingMethods": [
      {
        "amount": "0.00",
        "detail": "Available within an hour",
        "identifier": "in_store_pickup",
        "label": "In-Store Pickup"
      },
      {
        "amount": "4.99",
        "detail": "5-8 Business Days",
        "identifier": "flat_rate_shipping_id_2",
        "label": "UPS Ground"
      },
      {
        "amount": "29.99",
        "detail": "1-3 Business Days",
        "identifier": "flat_rate_shipping_id_1",
        "label": "FedEx Priority Mail"
      }
    ]
 */


/*
ApplePay payment result
paymentResult {token: , paymentMethod: {type: 0, displayName: Simulated Instrument, network: AmEx}, billingContact: {postalAddress: {street: Town City
flutter: Suite 110, state: New York, city: New York, subAdministrativeArea: , country: United States, subLocality: , postalCode: 11220, isoCountryCode: US}, name: {namePrefix: , familyName: Hasibuan, phoneticRepresentation: {phoneticRepresentation: null, nameSuffix: null, nickname: null, namePrefix: null, givenName: , middleName: , familyName: }, nickname: , givenName: Rully, nameSuffix: , middleName: }}, transactionIdentifier: Simulated Identifier}

 */