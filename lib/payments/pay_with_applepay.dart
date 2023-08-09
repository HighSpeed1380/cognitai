import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:app/app/home_page.dart';
import 'package:app/helpers/app_controller.dart';
import 'package:app/helpers/utility.dart';
import 'package:app/models/payment_model.dart';
import 'package:app/payments/pay_with_paypal.dart';
import 'package:app/services/repository/user_repository.dart';
import 'package:get/get.dart';

class PayWithApplePay extends StatelessWidget {
  PayWithApplePay({
    super.key,
    required this.itemToPay,
    required this.payPrice,
    required this.method,
  }) {
    Future.microtask(() => initPaymentObject(payPrice));
  }

  final dynamic itemToPay;
  final String method;
  final double payPrice;

  initPaymentObject(final double price) {
    int baseTime = DateTime.now().toUtc().millisecondsSinceEpoch;
    wordingProcess.value =
        'Payment ${itemToPay['code_package'].toString()} Membership Plan';

    final PaymentModel paymentModel = PaymentModel(
      value: price,
      refNo: "#$baseTime",
      currency: "USD",
      method: "ApplePay",
      type: itemToPay['code_package'],
      description: wordingProcess.value,
      createdAt: DateTime.now().toUtc().toString(),
      userId: itemToPay['id_user'].toString(),
      userIdPackage: "0",
      dataUser: itemToPay,
      timestamp: baseTime.toString(),
      response: jsonEncode({
        "error": 99,
        "message": "Processing",
      }),
    );

    itemOrder.update((val) {
      val!.paymentModel = paymentModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    final paymentItems = [
      PaymentItem(
        label: itemToPay['title'].toString(),
        amount: itemToPay['price'].toString(),
        status: PaymentItemStatus.final_price,
      )
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
      child: ApplePayButton(
        paymentConfiguration:
            PaymentConfiguration.fromJsonString(defaultApplePay),
        paymentItems: paymentItems,
        style: ApplePayButtonStyle.black,
        type: ApplePayButtonType.buy,
        margin: const EdgeInsets.only(top: 15.0),
        onPaymentResult: (Map<String, dynamic> paymentResult) {
          debugPrint("$tAG paymentResult ${paymentResult.toString()}");

          final getToken = parsePaymentResult(paymentResult);
          bool isApproved =
              kDebugMode ? true : (getToken != null && getToken != '');
          if (isApproved) {
            // if approved true
            afterPaymentResult(isApproved, paymentResult);
          } else {
            debugPrint("$tAG failed process payment");
            Utility.customSnackBar(
                context, 'Process payment failed! Try again later...!');
          }
        },
        loadingIndicator: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  parsePaymentResult(final Map<String, dynamic> dataResult) {
    debugPrint(
        "$tAG parsePaymentResult parsing result!! ${dataResult.toString()}");

    /*{paymentMethod: {displayName: Simulated Instrument, network: AmEx, type: 0}, token: , transactionIdentifier: Simulated Identifier, billingContact: {postalAddress: {city: New York, street: Town City Suite 110, isoCountryCode: US, country: United States, subLocality: , postalCode: 11220, subAdministrativeArea: , state: New York}, name: {phoneticRepresentation: {familyName: , nickname: null, nameSuffix: null, givenName: , namePrefix: null, phoneticRepresentation: null, middleName: }, nameSuffix: , givenName: Rully, middleName: , familyName: Hasibuan, namePrefix: , nickname: }}}*/
    String token = '';
    String tokenType = '';
    try {
      Map<String, dynamic> resMap = Map<String, dynamic>.from(dataResult);
      Map<String, dynamic> paymentMethod =
          Map<String, dynamic>.from(resMap['paymentMethod']);

      token = resMap['token'].toString();
      tokenType = paymentMethod['type'].toString();

      debugPrint("$tAG token $token tokenType $tokenType");
    } catch (e) {
      debugPrint("$tAG error parsePaymentResult ${e.toString()}");
    }

    return token;
  }

  final wordingProcess = 'Payment Membership Plan'.obs;
  final AppController appController = AppController.to;
  final UserRepository userRepository = UserRepository();

  final String tAG = 'PayWithApplePay';
  final itemOrder = ItemOrderPay().obs;
  final isLoading = false.obs;

  afterPaymentResult(
      final bool isApproved, final Map<String, dynamic> result) async {
    isLoading.value = true;
    appController.showLoadingBottom();

    Future.delayed(const Duration(milliseconds: 1800), () {
      //push server
      userRepository.paymentPush({
        "type_package": itemOrder.value.paymentModel!.type,
        "code_method": itemOrder.value.paymentModel!.method
      })!.then((response) {
        if (response != null && response.statusCode == 200) {
          debugPrint(response.bodyString);
          dynamic dataresult = jsonDecode(response.bodyString!);
          if (dataresult['result'] != null && dataresult['result'].length > 0) {
            dynamic paymentRow = dataresult['result'][0];
            PaymentModel newPayment = PaymentModel.fromJson(paymentRow);
            itemOrder.update((val) {
              val!.paymentModel = newPayment;
            });

            debugPrint(newPayment.toJson().toString());
          }
        }
      });
    });

    Future.delayed(const Duration(milliseconds: 2800), () {
      isLoading.value = false;

      if (isApproved) {
        nextPushProcess(result);
      }
    });
  }

  nextPushProcess(final Map<String, dynamic> data) async {
    var dataResponse = {"error": 0, "message": data};
    itemOrder.update((val) {
      val!.response = dataResponse;
    });

    final PaymentModel? paymentModel = itemOrder.value.paymentModel;
    if (paymentModel != null) {
      paymentModel.response = jsonEncode(dataResponse);
      paymentModel.updatedAt = DateTime.now().toUtc().toString();

      await pushPayment(appController, itemToPay, method,
          status: "1",
          idPayment: paymentModel.key,
          refNoPayment: paymentModel.refNo,
          response: jsonEncode(data));

      Future.delayed(const Duration(milliseconds: 1200), () {
        userRepository.paymentPush({
          "status": "1",
          "id_payment": paymentModel.key,
          "resp_payment": jsonEncode(dataResponse),
          "type_package": itemOrder.value.paymentModel!.type,
          "code_method": itemOrder.value.paymentModel!.method
        });
      });
    }

    // show dialog with success data
    showCupertinoDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Success. Thank you.'),
            content: Column(
              children: [
                Text('Order ID: ${itemOrder.value.paymentModel!.refNo}'),
                Text('Payer ID: $tAG'),
                Text(
                    'Created Date: ${itemOrder.value.paymentModel!.createdAt}'),
                Text(paymentModel!.description),
              ],
            ),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Get.back();
                  Future.microtask(() {
                    Utility.customSnackBar(
                        context, 'Thank you for your payment...');
                    Future.delayed(const Duration(milliseconds: 1200), () {
                      Get.back(result: dataResponse);

                      Future.delayed(const Duration(milliseconds: 1200), () {
                        Get.offAll(HomePage());
                      });
                    });
                  });
                },
              ),
            ],
          );
        });
  }

  pushPayment(
      final AppController appController, final dataPay, final String codeMethod,
      {final String? idPayment,
      final String? refNoPayment,
      final String? response,
      final String? status}) async {
    try {
      final jsonPush = {
        "type_package": dataPay['code_package'],
        "max": dataPay['counter_try'],
        "code_method": codeMethod,
        "id_payment": idPayment ?? '',
        "refno_payment": refNoPayment ?? '',
        "resp_payment": response ?? '',
        "status": status ?? '',
        "url": ApplePay.baseUrl,
      };

      debugPrint('$tAG: payPackage ');
      debugPrint(jsonPush.toString());

      final Response? responsePay = await userRepository.payPackage(jsonPush);
      if (responsePay != null &&
          responsePay.statusCode == 200 &&
          responsePay.bodyString != null) {
        dynamic dataresultPay = jsonDecode(responsePay.bodyString!);
        debugPrint("$tAG: response payPackage");
        debugPrint(dataresultPay.toString());

        if (dataresultPay['result'] != null && dataresultPay['code'] == '200') {
          await Future.delayed(const Duration(milliseconds: 1200));
          debugPrint('$tAG: updatePackage ');
          debugPrint(jsonPush.toString());

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
              appController.getUserAsync();
              appController.showSuccessBottom(callback: () {
                appController.getUserAsync();

                Future.delayed(const Duration(milliseconds: 2200), () {
                  Get.offAll(HomePage());
                });
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
    } catch (e) {
      debugPrint("Pay With ApplePay Error ${e.toString()}");
    }
  }
}

class ApplePay {
  static String baseUrl =
      "https://developer.apple.com/documentation/passkit/apple_pay/";
}

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


/**
 result payment applepay
 paymentResult {paymentMethod: {displayName: Simulated Instrument, network: AmEx, type: 0}, token: , transactionIdentifier: Simulated Identifier, billingContact: {postalAddress: {city: New York, street: Town City
flutter: Suite 110, isoCountryCode: US, country: United States, subLocality: , postalCode: 11220, subAdministrativeArea: , state: New York}, name: {phoneticRepresentation: {familyName: , nickname: null, nameSuffix: null, givenName: , namePrefix: null, phoneticRepresentation: null, middleName: }, nameSuffix: , givenName: Rully, middleName: , familyName: Hasibuan, namePrefix: , nickname: }}}
flutter: Received result!! {paymentMethod: {displayName: Simulated Instrument, network: AmEx, type: 0}, token: , transactionIdentifier: Simulated Identifier, billingContact: {postalAddress: {city: New York, street: Town City
flutter: Suite 110, isoCountryCode: US, country: United States, subLocality: , postalCode: 11220, subAdministrativeArea: , state: New York}, name: {phoneticRepresentation: {familyName: , nickname: null, nameSuffix: null, givenName: , namePrefix: null, phoneticRepresentation: null, middleName: }, nameSuffix: , givenName: Rully, middleName: , familyName: Hasibuan, namePrefix: , nickname: }}}

{paymentMethod: {displayName: Simulated Instrument, network: AmEx, type: 0}, token: , transactionIdentifier: Simulated Identifier, billingContact: {postalAddress: {city: New York, street: Town City Suite 110, isoCountryCode: US, country: United States, subLocality: , postalCode: 11220, subAdministrativeArea: , state: New York}, name: {phoneticRepresentation: {familyName: , nickname: null, nameSuffix: null, givenName: , namePrefix: null, phoneticRepresentation: null, middleName: }, nameSuffix: , givenName: Rully, middleName: , familyName: Hasibuan, namePrefix: , nickname: }}}

 */