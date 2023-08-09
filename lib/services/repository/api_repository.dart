import 'dart:convert';

import 'package:get/get.dart';
import 'package:app/helpers/constants.dart';
import 'package:app/helpers/my_pref.dart';
import 'package:app/services/all_provider.dart';

class ApiRepository {
  ApiRepository();

  // push get http backend
  final AllProvider _provider = AllProvider();
  AllProvider get provider => _provider;
  final MyPref myPref = MyPref.to;
  Future<Response?>? getSettings() {
    return provider.pushResponse(
        "api/get_data?lt=${Constants.pageLimit}",
        jsonEncode({
          "lt": Constants.pageLimit,
          "iu": myPref.pIdUserDb.val,
          "uuid": myPref.pUuid.val,
          "lat": myPref.pLatitude.val,
          "loc": myPref.pLocation.val,
          "os": GetPlatform.isAndroid ? "Android" : "iOS",
          "tk": myPref.pFcmToken.val,
        }));
  }

  Future<Response?>? getHome() {
    return provider.pushResponse(
        "home/get_all?lt=${Constants.pageLimit}",
        jsonEncode({
          "lt": Constants.pageLimit,
          "iu": myPref.pIdUserDb.val,
          "uuid": myPref.pUuid.val,
          "lat": myPref.pLatitude.val,
          "loc": myPref.pLocation.val,
          "os": GetPlatform.isAndroid ? "Android" : "iOS",
          "tk": myPref.pFcmToken.val,
        }));
  }
}
