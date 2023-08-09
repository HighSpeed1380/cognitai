import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:uuid/uuid.dart';
import 'package:app/app/home_page.dart';
import 'package:app/auths/auth_screen.dart';
import 'package:app/helpers/ads_helper.dart';
import 'package:app/helpers/app_color.dart';
import 'package:app/helpers/constants.dart';
import 'package:app/helpers/my_pref.dart';
import 'package:app/helpers/utility.dart';
import 'package:app/models/setting_model.dart';
import 'package:app/pages/packages/package_page.dart';
import 'package:app/services/all_provider.dart';
import 'package:app/services/api_object.dart';
import 'package:app/services/repository/api_repository.dart';
import 'package:app/services/repository/user_repository.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:app/widgets/typewriter/type_text.dart';

class AppController extends GetxController {
  static AppController get to => Get.find<AppController>();
  static String tAG = "AppController";

  // push get http backend
  final AllProvider _provider = AllProvider();
  AllProvider get provider => _provider;

  // instance AdsHelper
  final AdsHelper adsHelper = AdsHelper.instance;

  final MyPref _box = MyPref.to;
  MyPref get box => _box;

  @override
  void onInit() {
    super.onInit();

    String getUuid = box.pUuid.val;
    if (getUuid.isEmpty) {
      getUuid = const Uuid().v1();
      box.pUuid.val = getUuid;
    }

    Future.microtask(() => getSettings());
    Future.microtask(() => saveUpdateInstall());
  }

  // tab controller bottom navigation
  final selectedPos = 0.obs;
  setPosition(int pos) {
    selectedPos.value = pos;
  }

  GoogleSignIn? _googleSignIn;
  GoogleSignIn? get googleSignIn => _googleSignIn;

  // modules google sign-in
  initGoogleSignIn() {
    _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/userinfo.profile',
      ],
    );
  }

  Future<GoogleSignInAccount?> handleGoogleSignIn() async {
    try {
      if (_googleSignIn != null) {
        return await _googleSignIn!.signIn();
      }
    } catch (error) {
      debugPrint("$tAG handleSignIn error ${error.toString()}");
    }

    return null;
  }
  // modules google sign-in

  // module apple sign-in
  Future<GoogleSignInAccount?> handleAppleSignIn() async {
    try {
      if (_googleSignIn != null) {
        return await _googleSignIn!.signIn();
      }
    } catch (error) {
      debugPrint("$tAG handleSignIn error ${error.toString()}");
    }

    return null;
  }

  final UserRepository userRepository = UserRepository();
  final isProcessInstall = false.obs;
  final idInstallDb = ''.obs;

  saveUpdateInstall() async {
    debugPrint("$tAG saveUpdateInstall is running ${isProcessInstall.value}");
    if (isProcessInstall.value) return;

    isProcessInstall.value = true;
    Future.delayed(Duration(seconds: box.pInstallDb.val == '' ? 5 : 12), () {
      isProcessInstall.value = false;
    });

    final Response? response = await userRepository.getInstall();
    //debugPrint("$tAG saveUpdateInstall response ${response!.statusCode}");

    if (response != null && response.statusCode == 200) {
      debugPrint(response.bodyString);
      dynamic dataresult = jsonDecode(response.bodyString!);
      if (dataresult['result'] != null && dataresult['result'].length > 0) {
        dynamic installRow = dataresult['result'][0];
        //box.pInstallDb.val = jsonEncode(installRow);
        idInstallDb.value = installRow['id_install'];
        box.pIdInstallDb.val = installRow['id_install'];
      }

      debugPrint("box.pIdInstallDb.val ${box.pIdInstallDb.val}");
      debugPrint(dataresult.toString());
    }
  }

  final ApiRepository apiRepository = ApiRepository();
  final aPIObject = APIObject().obs;
  getSettings() async {
    debugPrint("$tAG getSettings ");

    try {
      apiRepository.getSettings()!.then((response) {
        if (response != null && response.statusCode == 200) {
          //debugPrint(response.bodyString);
          dynamic dataresult = jsonDecode(response.bodyString!);
          if (dataresult['result'] != null && dataresult['result'].length > 0) {
            dynamic result = dataresult['result'];
            //debugPrint("result packages ${result['packages'].toString()}");

            List<dynamic> packages = result['packages'];
            List<dynamic> settings = result['settings'];

            List<SettingModel> settingModels = [];
            if (settings.isNotEmpty) {
              settingModels =
                  settings.map((e) => SettingModel.fromJson(e)).toList();

              bool isEmabledAds = true;
              try {
                final SettingModel? findModel = settingModels.firstWhereOrNull(
                    (element) => element.title == 'ENABLED_ADMOB');
                if (findModel != null) {
                  isEmabledAds = findModel.isEnabledAds;
                }
              } catch (_) {}

              box.pEnabledAds.val = isEmabledAds;
            }

            if (packages.length > 1) {
              packages.sort((x, y) => int.parse(x['id_package'].toString())
                  .compareTo(int.parse(y['id_package'].toString())));
            }

            aPIObject.update((val) {
              val!.results = result;
              val.packages = packages;
              val.settings = settingModels;
              val.isLoading = false;
            });
          }
        }
      });
    } catch (e) {
      debugPrint("$tAG getSettings Error ${e.toString()}");
    }
  }

  getMaxHitByPackage() {
    final userLoggenId = box.getUser();
    if (userLoggenId != null) {
      final String userPackage = userLoggenId['type_package'].toString();
      debugPrint(userPackage);

      List<dynamic> getPP = aPIObject.value.packages ?? [];

      for (var item in getPP) {
        //debugPrint(item.toString());
        if (item['code_package'].toString() == userPackage) {
          //debugPrint("founded");
          //debugPrint(item.toString());
          final int max = int.parse(item['counter_try'].toString());
          return max;
        }
      }
    }

    return 10;
  }

  firstDone() {
    box.pFirst.val = false;
    update();
    debugPrint("$tAG box.pFirst.val ${box.pFirst.val}");
  }

// login
  loginApp(final dynamic dataUser) async {
    box.pIdUserDb.val = dataUser['id_user'];
    box.pLogin.val = true;
    box.pUserData.val = jsonEncode(dataUser);
  }

  // logout
  logoutApp() async {
    box.pIdUserDb.val = '';
    box.pLogin.val = false;
    box.pUserData.val = '';

    try {
      if (box.pGoogleSignIn.val) {
        googleSignIn!.signOut();
      }
    } catch (_) {}

    try {
      if (box.pAppleSignIn.val) {
        //googleSignIn!.signOut();
      }
    } catch (_) {}
  }

  final dataUser = DataUser().obs;
  getUserAsync() async {
    debugPrint(
        "$tAG getUserAsync check box.pInPackagePage.val ${box.pInPackagePage.val}");

    try {
      if (box.pInPackagePage.val || !box.pLogin.val) return;

      userRepository.getUser()!.then((response) {
        if (response != null && response.statusCode == 200) {
          //debugPrint(response.bodyString);
          dynamic dataresult = jsonDecode(response.bodyString!);
          if (dataresult['result'] != null && dataresult['result'].length > 0) {
            dynamic result = dataresult['result'];
            List<dynamic> jsonResp = result;
            dynamic rowUser = jsonResp[0];
            //print(rowUser);

            dataUser.update((val) {
              val!.user = rowUser;
              val.isLogin = box.pLogin.val;
            });

            box.pCodePackage.val = rowUser['type_package'];
            box.pUserData.val = jsonEncode(rowUser);

            final checkGoogleSignIn =
                rowUser['type_account'] == 'GOOGLE_SIGNIN';
            if (checkGoogleSignIn) {
              box.pGoogleSignIn.val = true;
              initGoogleSignIn();
            }

            final checkAppleSignIn = rowUser['type_account'] == 'APPLE_SIGNIN';
            if (checkAppleSignIn) {
              box.pAppleSignIn.val = true;
            }

            Future.delayed(const Duration(milliseconds: 2200), () {
              autoResetTrialIsEnd();
            });
          }
        }
      });
    } catch (e) {
      debugPrint("$tAG getUserAsync Error ${e.toString()}");
    }
  }

  final processIsEnd = false.obs;
  autoResetTrialIsEnd() async {
    try {
      if (processIsEnd.value) return;

      processIsEnd.value = true;
      Future.delayed(const Duration(seconds: 12), () {
        processIsEnd.value = false;
      });

      final user = box.getUser();
      int getMax = int.parse(user['counter_max'].toString());

      if (getMax < 1) {
        box.pCodePackage.val = '';
        await userRepository.updateCounter({"max": "0"});

        showLoadingBottom();

        Future.delayed(const Duration(milliseconds: 2200), () {
          box.pCodePackage.val = '';

          Future.delayed(const Duration(milliseconds: 2200), () {
            Utility.customSnackBar(
                Get.context!, "Your counter remaining is end. Thank you...");

            Get.offAll(HomePage());
          });
        });
      }
    } catch (e) {
      debugPrint("$tAG autoResetTrialIsEnd Error ${e.toString()}");
    }
  }

  //show dialogOTP Verification
  showOTPCodeEmail(final String codeEmail, final dynamic dataUser,
      {final VoidCallback? callback}) {
    return Get.bottomSheet(
      Container(
        width: Get.width,
        height: Get.height / 2.1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: Get.theme.primaryColor.withOpacity(.7),
          ),
          child: Column(
            children: [
              const SizedBox(height: 32),
              Text("OTP Code From Email",
                  style: Get.theme.textTheme.headlineSmall!
                      .copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Text("Make sure input 6 digits properly",
                  style: Get.theme.textTheme.bodyMedium!
                      .copyWith(color: AppColor.greyExtraLight)),
              const SizedBox(height: 25),
              OTPTextField(
                length: 6,
                width: Get.width,
                fieldWidth: 45,
                style: const TextStyle(fontSize: 18),
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldStyle: FieldStyle.box,
                outlineBorderRadius: 18,
                contentPadding: const EdgeInsets.all(2),
                otpFieldStyle: OtpFieldStyle(
                    backgroundColor: Get.theme.dialogBackgroundColor),
                onCompleted: (pin) {
                  debugPrint("Completed: $pin codeEmail $codeEmail");
                  if (pin.trim() == codeEmail.trim()) {
                    Get.back();

                    if (callback != null) {
                      Future.delayed(const Duration(milliseconds: 1200), () {
                        callback();
                      });
                    }
                  }
                },
              ),
              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                      child: const Text("Close"),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      isDismissible: false,
      backgroundColor: Colors.transparent,
      barrierColor: Get.theme.dialogBackgroundColor.withOpacity(.75),
    );
  }

  // logout confirmation
  showDialogConfirmLogout(
      final BuildContext context, final AppController appController) {
    Get.defaultDialog(
        title: "Confirmation",
        middleText: "Are you sure to Logout?",
        backgroundColor: Get.theme.primaryColor.withOpacity(.7),
        titleStyle: Get.theme.textTheme.bodyLarge!
            .copyWith(fontWeight: FontWeight.bold, color: AppColor.white),
        middleTextStyle: TextStyle(color: AppColor.white),
        textConfirm: "Yes",
        textCancel: "Cancel",
        confirmTextColor: AppColor.white,
        cancelTextColor: AppColor.white,
        buttonColor: Get.theme.primaryColor,
        barrierDismissible: false,
        radius: 10,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
        onConfirm: () async {
          Get.back();

          Future.microtask(() {
            appController.showLoadingBottom(
                duration: const Duration(milliseconds: 2500));

            Future.delayed(const Duration(milliseconds: 1500), () async {
              await logoutApp();

              Future.delayed(const Duration(milliseconds: 2500), () {
                Get.offAll(AuthScreen(screenHeight: Get.height));
              });
            });
          });
        });
  }

  // delete account confirmation
  showDialogConfirmDeleteAccount(
      final BuildContext context, final AppController appController) {
    Get.defaultDialog(
        title: "Confirmation",
        middleText: "Are you sure to Delete Your Account Membership?",
        backgroundColor: Get.theme.primaryColor.withOpacity(.7),
        titleStyle: Get.theme.textTheme.bodyLarge!
            .copyWith(fontWeight: FontWeight.bold, color: AppColor.white),
        middleTextStyle: TextStyle(color: AppColor.white),
        textConfirm: "Yes",
        textCancel: "Cancel",
        confirmTextColor: AppColor.white,
        cancelTextColor: AppColor.white,
        buttonColor: Get.theme.primaryColor,
        barrierDismissible: false,
        radius: 10,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
        onConfirm: () async {
          Get.back();

          Future.microtask(() {
            appController.showLoadingBottom(
                duration: const Duration(milliseconds: 2500));

            Future.delayed(const Duration(milliseconds: 1500), () async {
              await logoutApp();

              Future.delayed(const Duration(milliseconds: 2500), () {
                Get.offAll(AuthScreen(screenHeight: Get.height));
              });
            });
          });
        });
  }

  showLoadingBottom({final Duration? duration, final double? height}) {
    Future.delayed(duration ?? const Duration(milliseconds: 2100), () {
      Get.back();
    });
    return Get.bottomSheet(
      Container(
        width: Get.width,
        height: height ?? Get.height / 2.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: Get.theme.primaryColor.withOpacity(.7),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      barrierColor: Get.theme.dialogBackgroundColor.withOpacity(.75),
    );
  }

  showSuccessBottom(
      {final Duration? duration,
      final double? height,
      final VoidCallback? callback}) {
    Future.delayed(duration ?? const Duration(milliseconds: 3500), () {
      Get.back();

      if (callback != null) {
        callback();
      }
    });
    return Get.bottomSheet(
      Container(
        width: Get.width,
        height: height ?? Get.height / 2.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: AppColor.white,
              border: Border.all(color: AppColor.greyLabel)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              SizedBox(
                width: 120,
                height: 120,
                child: Image.asset("assets/success02.gif"),
              ),
              TypeText(
                "Process successful...",
                style: Get.theme.textTheme.headlineSmall,
                duration: const Duration(milliseconds: 2000),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      barrierColor: AppColor.greyExtraLight.withOpacity(.5),
    );
  }

  gotoRenewalDialog() {
    final user = box.getUser();

    try {
      aPIObject.value.packages!.firstWhere((element) =>
          element['code_package'].toString() ==
          user['type_package'].toString());
    } catch (e) {
      debugPrint("profilepage error ${e.toString()}");
    }

    showInfoMembership(user);
  }

  showInfoMembership(final dynamic user) {
    return Get.bottomSheet(
      Container(
        width: Get.width,
        height: Get.height / 1.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              width: Get.width,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: AppColor.white,
                  border: Border.all(color: AppColor.greyLabel)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text("Package ${user['type_package']}",
                        style: Get.theme.textTheme.headlineMedium),
                    Text("Expired At ${user['expired_at']}"),
                    const SizedBox(height: 10),
                    Text("${user['counter_max']} Credits Remaining ",
                        style: Get.theme.textTheme.headlineMedium!.copyWith(
                            color: Get.theme.primaryColor, fontSize: 18)),
                    const SizedBox(height: 10),
                    const Text("What will you get after renewal: "),
                    const Text("Free Trial can not proceed for next renewal "),
                    const Text(
                        "Only paid member will be got processing successful "),
                    const Text("Credit Card is required. "),
                    const SizedBox(height: 10),
                    const Text(
                        "by click Confirm & Submit button, you are agree for our policy & privacy also our User Terms & Condition! ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Get.theme.primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              )),
                          child: const Text("Confirm"),
                          onPressed: () async {
                            int getMax =
                                int.parse(user['counter_max'].toString());
                            debugPrint("getMax: $getMax");

                            if (getMax < 1) {
                              await autoResetTrialIsEnd();
                            }

                            Get.back();

                            Future.microtask(() => Get.to(PackagePage()));
                          },
                        )),
                  ],
                ),
              ),
            ),
            Positioned(
                right: 5,
                top: 5,
                child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(BootstrapIcons.x_circle_fill,
                        color: Get.theme.primaryColor)))
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      barrierColor: AppColor.greyExtraLight.withOpacity(.5),
    );
  }

  // option image generation
  final inputNumberImage = 1.0.obs;
  final inputSizeImage = "256".obs;
  final arraySizeImage = ["256", "512", "1024"];

  showimageOptions() {
    inputNumberImage.value = double.parse(box.pNumberImage.val.toString());
    inputSizeImage.value = box.pSizeImage.val;

    return Get.bottomSheet(
      Container(
        width: Get.width,
        height: Get.height / 1.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              width: Get.width,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: AppColor.white,
                  border: Border.all(color: AppColor.greyLabel)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text("Image Generation Options ",
                        style: Get.theme.textTheme.headlineSmall),
                    const SizedBox(height: 5),
                    Text("Adjustment your image generation options ",
                        style: Get.theme.textTheme.bodySmall),
                    const SizedBox(height: 20),
                    Obx(
                      () => SizedBox(
                        width: double.maxFinite,
                        height: 60,
                        child: CupertinoSlider(
                          min: 1,
                          max: 10,
                          value: inputNumberImage.value,
                          thumbColor: Colors.amber,
                          onChanged: (value) {
                            inputNumberImage.value = value;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Obx(
                      () => SizedBox(
                        width: double.maxFinite,
                        child: Text(
                            "Number of image: ${inputNumberImage.value.toInt()}",
                            style: Get.theme.textTheme.labelLarge),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Wrap(
                        children: arraySizeImage.map((e) {
                      final val = e.toString();

                      return Obx(
                        () => InkWell(
                          onTap: () {
                            inputSizeImage.value = val;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: inputSizeImage.value == val
                                  ? Get.theme.primaryColor
                                  : AppColor.greyExtraLight,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            margin:
                                const EdgeInsets.only(right: 10, bottom: 10),
                            child: Text("Size $e",
                                style: Get.theme.textTheme.bodyMedium!.copyWith(
                                    color: inputSizeImage.value == val
                                        ? Colors.white
                                        : AppColor.greyLabel)),
                          ),
                        ),
                      );
                    }).toList()),
                    const SizedBox(height: 10),
                    Text("Size of image: ${box.pSizeImage.val}",
                        style: Get.theme.textTheme.labelLarge),
                    const SizedBox(height: 20),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Get.theme.primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              )),
                          child: const Text("Saved"),
                          onPressed: () async {
                            box.pNumberImage.val =
                                inputNumberImage.value.toInt();
                            box.pSizeImage.val = inputSizeImage.value;
                            Get.back();
                          },
                        )),
                  ],
                ),
              ),
            ),
            Positioned(
                right: 5,
                top: 5,
                child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(BootstrapIcons.x_circle_fill,
                        color: Get.theme.primaryColor)))
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      barrierColor: AppColor.greyExtraLight.withOpacity(.5),
    );
  }

  //check list of Availabilities
  checkAvailitiesAPI() async {
    debugPrint("$tAG checkAvailitiesAPI running...");

    final openAI = OpenAI.instance.build(
      token: Constants.apiKeyToken,
      baseOption: HttpSetup(
        receiveTimeout: Duration(milliseconds: Constants.maxTimeoutStream),
      ),
      enableLog: true,
    );

    try {
      final models = await openAI.listModel();
      if (models.data.isNotEmpty) {
        debugPrint("models data length ${models.data.length}");
        models.data.map((e) {
          debugPrint("models e ${e.toString()}");
        });
      }
    } catch (_) {
      //debugPrint("Error checkAvailitiesAPI listModel ${e.toString()}");
    }

    try {
      final engines = await openAI.listEngine();
      if (engines.data.isNotEmpty) {
        debugPrint("engines data length ${engines.data.length}");
        engines.data.map((e) {
          debugPrint("engines e ${e.toString()}");
        });
      }
    } catch (_) {
      //debugPrint("Error checkAvailitiesAPI listEngine ${e.toString()}");
    }
  }
}

class DataUser {
  dynamic user;
  bool? isLogin;
}
