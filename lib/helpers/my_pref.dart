import 'dart:convert';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:app/helpers/constants.dart';

class MyPref {
  static MyPref get to => Get.find<MyPref>();
  static String tAG = "MyPref";

  MyPref._() {
    _boxStorage();
  }

  static final MyPref _instance = MyPref._();
  static MyPref get instance => _instance;

  static GetStorage _boxStorage() {
    return GetStorage(Constants.appStorage);
  }

  final GetStorage boxStorage = _boxStorage();

  static String keyFirst = 'p_first';
  static String keyModelChat = 'p_modelchat';
  static String keyMaxToken = 'p_maxtoken';

  static String keyLogin = 'p_isloggedin';
  static String keyFcmToken = 'p_fcm_token';

  static String keyUuid = 'p_uuid';
  static String keyIdUserAuth = 'p_iduser_auth';
  static String keyIdUserDb = 'p_iduser_db';
  static String keyInstall = 'p_install_db';

  static String keyIdInstallDb = 'p_idinstall_db';
  static String keyCodePackage = 'p_cd_package';

  static String keyUserData = 'p_user_data';
  static String keyPasswd = 'p_passwd';

  static String keyLatitude = 'p_latitude';
  static String keyLocation = 'p_location';
  static String keyInPackagePage = 'p_insidepackage';

  static String keyTranslator = 'p_translator';
  static String keyEnabledAds = 'p_enabledAds';

  static String keyGoogleSignIn = 'p_googlesign';
  static String keyAppleSignIn = 'p_applesign';

  //image options
  static String keyNumberImage = 'p_numberimg';
  static String keySizeImage = 'p_sizeimg'; //256x256, 512x512, or 1024x1024.

  //first time install
  final pFirst = ReadWriteValue(keyFirst, true, _boxStorage);

  //loggedIn
  final pLogin = ReadWriteValue(keyLogin, false, _boxStorage);
  final pGoogleSignIn = ReadWriteValue(keyGoogleSignIn, false, _boxStorage);
  final pAppleSignIn = ReadWriteValue(keyAppleSignIn, false, _boxStorage);

  final pFcmToken = ReadWriteValue(keyFcmToken, '', _boxStorage);
  final pUuid = ReadWriteValue(keyUuid, '', _boxStorage);
  final pIdUserDb = ReadWriteValue(keyIdUserDb, '', _boxStorage);
  final pIdUserAuth = ReadWriteValue(keyIdUserAuth, '', _boxStorage);

  final pPasswd = ReadWriteValue(keyPasswd, '', _boxStorage);
  final pUserData = ReadWriteValue(keyUserData, '', _boxStorage);
  final pCodePackage = ReadWriteValue(keyCodePackage, '', _boxStorage);

  final pInstallDb = ReadWriteValue(keyInstall, '', _boxStorage);
  final pIdInstallDb = ReadWriteValue(keyIdInstallDb, '', _boxStorage);

  final pLatitude = ReadWriteValue(keyLatitude, '', _boxStorage);
  final pLocation = ReadWriteValue(keyLocation, '', _boxStorage);
  final pInPackagePage = ReadWriteValue(keyInPackagePage, false, _boxStorage);

  //model, token
 // final pModelChat = ReadWriteValue(keyModelChat, kChatGpt4, _boxStorage);
  //final pModelChat =ReadWriteValue(keyModelChat, kChatGptTurboModel, _boxStorage);
  final pModelChat =ReadWriteValue(keyModelChat, kChatGptTurboModel, _boxStorage);
  final pMaxToken = ReadWriteValue(keyMaxToken, 800, _boxStorage);
  // change 1000 for max best performance


  final pNumberImage = ReadWriteValue(keyNumberImage, 1, _boxStorage);
  final pSizeImage = ReadWriteValue(keySizeImage, '256', _boxStorage);

  final pTranslator = ReadWriteValue(keyTranslator, 'Default', _boxStorage);
  final pEnabledAds = ReadWriteValue(keyEnabledAds, true, _boxStorage);

  getUser() {
    if (pUserData.val != '') {
      return jsonDecode(pUserData.val);
    }
    return null;
  }
}
