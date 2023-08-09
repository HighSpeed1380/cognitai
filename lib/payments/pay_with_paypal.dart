import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:easy_paypal/easy_paypal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/app/home_page.dart';
import 'package:app/helpers/app_controller.dart';
import 'package:app/helpers/constants.dart';
import 'package:app/helpers/utility.dart';
import 'package:app/models/payment_model.dart';
import 'package:app/services/repository/user_repository.dart';

class PayWithPaypal extends StatelessWidget {
  final dynamic itemToPay;
  final String method;
  PayWithPaypal(
      {Key? key,
      required this.itemToPay,
      required this.payPrice,
      required this.method})
      : super(key: key) {
    Future.microtask(() async {
      isLoading.value = true;
      Future.delayed(const Duration(milliseconds: 2200), () {
        isLoading.value = false;
      });

      await initPlatformState();
      await initOrderToPay(payPrice);
    });
  }

  final isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    final AppController appController = AppController.to;
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        width: Get.width,
        height: Get.height,
        color: Colors.white,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                topHeader(),
                Obx(
                  () => SizedBox(height: isLoading.value ? 0 : 20),
                ),
                Stack(
                  children: [
                    Obx(() => isLoading.value
                        ? const SizedBox(
                            height: 1,
                            child: LinearProgressIndicator(),
                          )
                        : const SizedBox.shrink()),
                    Container(
                      width: Get.width,
                      height: Get.height / 2,
                      padding: EdgeInsets.zero,
                      child: ListView(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28, vertical: 5),
                            child: Text(wordingProcess.value),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28, vertical: 0),
                            child: Text(
                              "Your payment for ${itemToPay['code_package']} Membership",
                              style: Get.theme.textTheme.headlineSmall,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28, vertical: 5),
                            child: Text(
                                "Price \$$payPrice USD via Paypal Payment",
                                style: Get.theme.textTheme.titleMedium!
                                    .copyWith(fontWeight: FontWeight.w900)),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 28, vertical: 0),
                            child: Text(
                                "Make sure dont close this payment page until process is completed"),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 28, vertical: 5),
                            child: Text(
                                "Once your payment is done, max counter hit to use all services added!"),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28, vertical: 10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Get.theme.primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  )),
                              child: Text("Pay \$$payPrice USD"),
                              onPressed: () {
                                isLoading.value = true;
                                appController.showLoadingBottom();
                                Future.delayed(
                                    const Duration(milliseconds: 1800), () {
                                  //push server
                                  userRepository.paymentPush({
                                    "type_package":
                                        itemOrder.value.paymentModel!.type,
                                    "code_method":
                                        itemOrder.value.paymentModel!.method
                                  })!.then((response) {
                                    if (response != null &&
                                        response.statusCode == 200) {
                                      debugPrint(response.bodyString);
                                      dynamic dataresult =
                                          jsonDecode(response.bodyString!);
                                      if (dataresult['result'] != null &&
                                          dataresult['result'].length > 0) {
                                        dynamic paymentRow =
                                            dataresult['result'][0];
                                        PaymentModel newPayment =
                                            PaymentModel.fromJson(paymentRow);
                                        itemOrder.update((val) {
                                          val!.paymentModel = newPayment;
                                        });

                                        debugPrint(
                                            newPayment.toJson().toString());
                                      }
                                    }
                                  });

                                  _easyPaypalPlugin.checkout(
                                      order: itemOrder.value.ppOrder!);
                                });

                                Future.delayed(
                                    const Duration(milliseconds: 2800), () {
                                  isLoading.value = false;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final wordingProcess = 'Payment Membership Plan'.obs;
  final String tAG = 'PayWithPaypal';

  final itemOrder = ItemOrderPay().obs;
  final _easyPaypalPlugin = EasyPaypal();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final double payPrice;

  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    final AppController appController = AppController.to;

    try {
      _easyPaypalPlugin.initConfig(
        config: PPCheckoutConfig(
            clientId: PaypalEnv.clientID,
            environment: PaypalEnv.pPEnvironment,
            userAction: PPUserAction.payNowAction,
            currencyCode: PPCurrencyCode.usd,
            returnUrl: "${Constants.packageName}://paypalpay"),
      );

      _easyPaypalPlugin.setCallback(
          PPCheckoutCallback(onApprove: (PPApprovalData data) async {
        var dataResponse = {"error": 0, "message": data.toJson()};
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
              response: jsonEncode(data.toJson()));

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
            context: scaffoldKey.currentContext!,
            barrierDismissible: false,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text('Success. Thank you.'),
                content: Column(
                  children: [
                    Text('Order ID: ${data.orderId ?? paymentModel!.refNo}'),
                    Text('Payer ID: ${data.payerId}'),
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

                          Future.delayed(const Duration(milliseconds: 1200),
                              () {
                            Get.offAll(HomePage());
                          });
                        });
                      });
                    },
                  ),
                ],
              );
            });
        debugPrint('onApprove: ${data.toString()}');
      }, onError: (data) {
        /// show snack bar with error message
        /*final snackBar = SnackBar(
          content: Text(data.reason),
          behavior: SnackBarBehavior.floating,
        );*/
        Utility.customSnackBar(
            Get.context!, "Error: \r\n${data.reason.toString()}");
        var dataResponse = {
          "error": 1,
          "message": data.reason.toString(),
        };
        final PaymentModel? paymentModel = itemOrder.value.paymentModel;
        if (paymentModel != null) {
          paymentModel.response = jsonEncode(dataResponse);
          paymentModel.updatedAt = DateTime.now().toUtc().toString();
          /*pushPayment(appController, itemToPay, method,
              status: "0",
              idPayment: paymentModel.key,
              refNoPayment: paymentModel.refNo,
              response: data.reason.toString());*/
        }

        itemOrder.update((val) {
          val!.response = dataResponse;
        });

        Future.microtask(() {
          Utility.customSnackBar(Get.context!, 'Error payment...');
        });

        debugPrint('onError: Payment ${data.toString()}');
      }, onCancel: () {
        debugPrint('onCancel');
        dynamic dataResponse = {
          "error": 1,
          "message": "Cancel by user",
        };
        final PaymentModel? paymentModel = itemOrder.value.paymentModel;
        if (paymentModel != null) {
          paymentModel.response = dataResponse;
          paymentModel.updatedAt = DateTime.now().toUtc().toString();
          /*pushPayment(appController, itemToPay, method,
              status: "0",
              idPayment: paymentModel.key,
              refNoPayment: paymentModel.refNo,
              response: "Cancel by user");*/
        }

        itemOrder.update((val) {
          val!.response = dataResponse;
        });

        Future.microtask(() {
          Utility.customSnackBar(Get.context!, 'Cancel by User...');
        });
      }, onShippingChange: (data) {
        debugPrint('onShippingChange: ${data.toString()}');
      }));
    } catch (e) {
      debugPrint('$tAG:::: ERROR: ${e.toString()}');
    }
  }

  final UserRepository userRepository = UserRepository();

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
        "url": PaypalEnv.baseUrl,
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
      debugPrint("Pay With Paypal Error ${e.toString()}");
    }
  }

  initOrderToPay(final double price) {
    //final MyPref pref = MyPref.to;
    debugPrint('pref verifyPrice ${price.toString()}');

    int baseTime = DateTime.now().toUtc().millisecondsSinceEpoch;
    wordingProcess.value =
        'Payment ${itemToPay['code_package'].toString()} Membership Plan';

    final PaymentModel paymentModel = PaymentModel(
      value: price,
      refNo: "#$baseTime",
      currency: "USD",
      method: "Paypal",
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

    var order = PPOrder(
      intent: PPOrderIntent.capture,
      appContext: PPOrderAppContext(
        brandName: paymentModel.method,
        shippingPreference: PPShippingPreference.noShipping,
        userAction: PPUserAction.payNowAction,
      ),
      purchaseUnitList: [
        PPPurchaseUnit(
          referenceId: paymentModel.refNo,
          invoiceId: "INV$baseTime",
          customId: baseTime.toString(),
          orderAmount: PPOrderAmount(
            currencyCode: PPCurrencyCode.usd,
            value: paymentModel.value.toString(),
          ),
          softDescriptor: wordingProcess.value,
        ),
      ],
    );

    itemOrder.update((val) {
      val!.ppOrder = order;
      val.paymentModel = paymentModel;
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
                    Text("Payment Order Membership",
                        style: Get.theme.textTheme.labelMedium!
                            .copyWith(color: Colors.grey[500])),
                    Text(Constants.labelPayPaypal,
                        style: Get.theme.textTheme.titleLarge),
                    const SizedBox(height: 5),
                  ],
                ),
              ],
            ),
            Icon(BootstrapIcons.info, color: Get.theme.primaryColor, size: 30)
          ],
        ),
      ),
    );
  }
}

class ItemOrderPay {
  PPOrder? ppOrder;
  Map<String, dynamic>? response;
  PaymentModel? paymentModel;
}

//paypal environtment
class PaypalEnv {
  static String baseUrl = "https://developer.paypal.com/dashboard";
  static bool isDebug = kDebugMode;

  static PPEnvironment pPEnvironment =
      isDebug ? PPEnvironment.sandbox : PPEnvironment.live;

  static String account = isDebug
      ? "sb-xtqb4324991245@business.example.com" //Sandbox
      : "ê"; // LIVE

  // my developer paypal MyApp_Kofi. CognitAI App
  static String clientID = isDebug
      ? "AaG63LZrQDHCEPq-6rOOpCNq_MTX3bQrAyDapinjU-XaQogLFBR7BZthTy4gLyU9VaMwaXOVK4gh4Maw" //Sandbox
      : "AbpETbhhXzj-10Lm_SMk2cs7C1Hy8PyxsEdao7YFNTS4yAMBJiA-53BFKlEu8VIBRG8dAEvcoqxSjcuk"; // LIVE

  static String keySecret = isDebug
      ? "EIQIq2qVgmTx_n03sBAgZbbCZMJ6j80PCLHbvW-NIQw0n_RiIqhbBqaCroLWEaWwe4Xzaym1y0KGdq9B" //Sandbox
      : "not used"; // LIVE
}

//json
/*

onApprove: PPApprovalData(payerId: TKCLNJWHNZNLN, orderId: null, paymentId: null, payer: null, cart: PPCart(cartId: 79591652J6848373H, intent: SALE, billingType: null, paymentId: null, billingToken: null, items: [], amounts: null, description: null, cancelUrl: null, returnUrl: null, total: PPAmount(currencyFormat: null, currencyFormatSymbolISOCurrency: null, currencyCode: USD, currencySymbol: USD, currencyValue: 1.00), shippingMethods: null, shippingAddress: PPCartAddress(firstName: null, lastName: null, line1: null, line2: null, city: null, state: null, postalCode: null, country: null, isFullAddress: null, isStoreAddress: null), billingAddress: PPCartAddress(firstName: null, lastName: null, line1: null, line2: null, city: null, state: null, postalCode: null, country: null, isFullAddress: null, isStoreAddress: null), totalAllowedOverCaptureAmount: PPAmount(currencyFormat: null, currencyFormatSymbolISOCurrency: null, currencyCode: null, currencySymbol: null, currencyValue: null))
 */