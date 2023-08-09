import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:app/helpers/my_pref.dart';
import 'package:app/services/all_provider.dart';

class UserRepository {
  UserRepository();

  // push get http backend
  final AllProvider _provider = AllProvider();
  AllProvider get provider => _provider;
  final MyPref myPref = MyPref.to;

  Future<Response>? getInstall() {
    final dataPush = jsonEncode({
      "id": myPref.pIdInstallDb.val,
      "uuid": myPref.pUuid.val,
      "lat": myPref.pLatitude.val,
      "loc": myPref.pLocation.val,
      "os": GetPlatform.isAndroid ? "Android" : "iOS",
      "tk": (myPref.pFcmToken.val.isEmpty
          ? myPref.pUuid.val
          : myPref.pFcmToken.val),
    });

    debugPrint("getInstall");
    debugPrint(dataPush);

    return provider.pushResponse("install/save_update", dataPush);
  }

  Future<Response?>? signIn3Party(final dynamic dataAccount) {
    return provider.pushResponse(
        "api/register_3party",
        jsonEncode({
          "em": dataAccount['email'].toString(),
          "ps": dataAccount['password'].toString(),
          "fn": dataAccount['fullname'].toString(),
          "pic": dataAccount['image'].toString(),
          "ta": dataAccount['type_account'].toString(),
          "is": myPref.pIdInstallDb.val,
          "ph": "",
          "uf": myPref.pIdUserAuth.val,
          "cc": "ID",
          "lat": myPref.pLatitude.val,
          "loc": myPref.pLocation.val,
          "os": GetPlatform.isAndroid ? "Android" : "iOS",
          "tk": myPref.pFcmToken.val,
        }));
  }

  Future<Response?>? createAccount(final dynamic dataAccount) {
    final dataPush = jsonEncode({
      "em": dataAccount['email'].toString(),
      "ps": dataAccount['password'].toString(),
      "fn": dataAccount['fullname'].toString(),
      "is": myPref.pIdInstallDb.val,
      "ph": "",
      "uf": myPref.pIdUserAuth.val,
      "cc": "ID",
      "lat": myPref.pLatitude.val,
      "loc": myPref.pLocation.val,
      "os": GetPlatform.isAndroid ? "Android" : "iOS",
      "tk": myPref.pFcmToken.val,
    });

    debugPrint("userRepository createAccount");
    debugPrint(dataPush);

    return provider.pushResponse("api/register", dataPush);
  }

  Future<Response?>? signIn(final dynamic dataAccount) {
    return provider.pushResponse(
        "api/login",
        jsonEncode({
          "em": dataAccount['email'].toString(),
          "ps": dataAccount['password'].toString(),
          "is": myPref.pIdInstallDb.val,
          "uf": myPref.pIdUserAuth.val,
          "lat": myPref.pLatitude.val,
          "loc": myPref.pLocation.val,
          "os": GetPlatform.isAndroid ? "Android" : "iOS",
          "tk": myPref.pFcmToken.val,
        }));
  }

  Future<Response?>? paymentPush(final dynamic dataPackage) {
    final String dataPush = jsonEncode({
      "id": myPref.pIdUserDb.val,
      "ipy": dataPackage['id_payment'] ?? '',
      "st": dataPackage['status'] ?? '0',
      "ra": dataPackage['resp_payment'] ?? '',
      "tp": dataPackage['type_package'].toString(),
      "cd": dataPackage['code_method'].toString(),
      "is": myPref.pIdInstallDb.val,
      "uf": myPref.pIdUserAuth.val,
      "lat": myPref.pLatitude.val,
      "loc": myPref.pLocation.val,
      "os": GetPlatform.isAndroid ? "Android" : "iOS",
      "tk": myPref.pFcmToken.val,
      "fl": kDebugMode ? "1" : "2", // flag 1 == sandbox/debug, 2 == live
    });

    debugPrint(dataPush);
    return provider.pushResponse("payment/insert_update", dataPush);
  }

  Future<Response?>? payPackage(final dynamic dataPackage) {
    final String dataPush = jsonEncode({
      "id": myPref.pIdUserDb.val,
      "ipy": dataPackage['id_payment'] ?? '',
      "tp": dataPackage['type_package'].toString(),
      "cd": dataPackage['code_method'].toString(),
      "is": myPref.pIdInstallDb.val,
      "uf": myPref.pIdUserAuth.val,
      "lat": myPref.pLatitude.val,
      "loc": myPref.pLocation.val,
      "os": GetPlatform.isAndroid ? "Android" : "iOS",
      "tk": myPref.pFcmToken.val,
      "resp": dataPackage['resp_payment'] ?? '',
      "ua": dataPackage['url'] ?? '',
      "fl": kDebugMode ? "1" : "2", // flag 1 == sandbox/debug, 2 == live
    });

    debugPrint(dataPush);
    return provider.pushResponse("api/pay_package", dataPush);
  }

  Future<Response?>? updatePackage(final dynamic dataPackage) {
    final String dataPush = jsonEncode({
      "id": myPref.pIdUserDb.val,
      "ipy": dataPackage['id_payment'] ?? '',
      "tp": dataPackage['type_package'].toString(),
      "cd": dataPackage['code_method'].toString(),
      "cm": dataPackage['max'].toString(),
      "is": myPref.pIdInstallDb.val,
      "uf": myPref.pIdUserAuth.val,
      "lat": myPref.pLatitude.val,
      "loc": myPref.pLocation.val,
      "os": GetPlatform.isAndroid ? "Android" : "iOS",
      "tk": myPref.pFcmToken.val,
      "resp": dataPackage['resp_payment'] ?? '',
      "ua": dataPackage['url'] ?? '',
      "fl": kDebugMode ? "1" : "2", // flag 1 == sandbox/debug, 2 == live
    });

    debugPrint(dataPush);
    return provider.pushResponse("api/update_package", dataPush);
  }

  Future<Response?>? updateCounter(final dynamic dataCounter) {
    final String dataPush = jsonEncode({
      "id": myPref.pIdUserDb.val,
      "cm": dataCounter['max'].toString(),
      "is": myPref.pIdInstallDb.val,
      "uf": myPref.pIdUserAuth.val,
      "lat": myPref.pLatitude.val,
      "loc": myPref.pLocation.val,
      "os": GetPlatform.isAndroid ? "Android" : "iOS",
      "tk": myPref.pFcmToken.val,
    });
    return provider.pushResponse("api/update_counter", dataPush);
  }

  Future<Response?>? getUser() {
    return provider.pushResponse(
        "api/get_user",
        jsonEncode({
          "iu": myPref.pIdUserDb.val,
          "is": myPref.pIdInstallDb.val,
          "uf": myPref.pIdUserAuth.val,
          "lat": myPref.pLatitude.val,
          "loc": myPref.pLocation.val,
          "os": GetPlatform.isAndroid ? "Android" : "iOS",
          "tk": myPref.pFcmToken.val,
        }));
  }

  Future<Response?>? updateUser(final dynamic params) {
    return provider.pushResponse(
        "api/update_user",
        jsonEncode({
          "iu": myPref.pIdUserDb.val,
          "is": myPref.pIdInstallDb.val,
          "act": params['action'],
          "fn": params['fullname'],
          "img": params['image'],
        }));
  }

  Future<Response?>? checkEmail(final String email) {
    return provider.pushResponse(
        "api/check_email_phone",
        jsonEncode({
          "em": email.trim().toLowerCase(),
          "lat": myPref.pLatitude.val,
          "loc": myPref.pLocation.val,
          "os": GetPlatform.isAndroid ? "Android" : "iOS",
          "tk": myPref.pFcmToken.val,
        }));
  }

  Future<Response?>? sendOTP(final String email) {
    final dataJson = jsonEncode({
      "em": email.trim().toLowerCase(),
      "lat": myPref.pLatitude.val,
      "loc": myPref.pLocation.val,
      "is": myPref.pIdInstallDb.val,
      "os": GetPlatform.isAndroid ? "Android" : "iOS",
      "tk": myPref.pFcmToken.val,
    });

    debugPrint(dataJson.toString());

    debugPrint("AllProvider.urlBase ${AllProvider.urlBase}");

    return provider.pushResponse("sendMail/send_otp_code", dataJson);
  }
}
