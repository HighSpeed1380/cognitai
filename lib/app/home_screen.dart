import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/helpers/ads_helper.dart';
import 'package:app/helpers/app_color.dart';
import 'package:app/helpers/app_controller.dart';
import 'package:app/helpers/constants.dart';
import 'package:app/helpers/utility.dart';
import 'package:app/pages/chatbot_page.dart';
import 'package:app/pages/generate_image_page.dart';
import 'package:app/pages/packages/package_page.dart';
import 'package:app/pages/profile_page.dart';
import 'package:app/widgets/commons/cache_image.dart';
import 'package:app/pages/voice_text_page.dart';
import 'package:app/pages/scan_ocr_page.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.appController});

  final AppController appController;

  @override
  Widget build(BuildContext context) {
    final bannerContainer = AdsHelper.bannerContainer;
    final dynamic userLoggedIn = appController.box.getUser();
    return SafeArea(
      child: Stack(
        children: [
          Container(
            width: Get.width,
            height: Get.height,
            color: Colors.white,
            child: Column(
              children: [
                //row top
                Obx(
                  () => topHeader(
                      appController.dataUser.value.user ?? userLoggedIn),
                ),
                iconShortcuts(userLoggedIn),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),
                Container(
                  width: Get.width / 1.11,
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    Constants.wording1,
                    style: Get.theme.textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Container(
                  width: Get.width / 1.11,
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    Constants.wording3,
                    style: Get.theme.textTheme.bodySmall,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Get.theme.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                    child: Text(
                      "${Utility.getCreditRemaining(appController.dataUser.value.user ?? userLoggedIn)} Credit Remaining",
                      style: const TextStyle(fontSize: 19),
                    ),
                    onPressed: () {
                      appController.gotoRenewalDialog();
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Lottie.asset('assets/lottie_animation.json',
                      width: 300, height: 300),
                ),
              ],
            ),
          ),
          Obx(
            () => showBottomAds(appController.box.pEnabledAds.val,
                bannerContainer.value.aContainer),
          ),
        ],
      ),
    );
  }

  Widget showBottomAds(final bool enabledShow, final Widget? adsWidget) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: !enabledShow
          ? const SizedBox.shrink()
          : Container(
              width: Get.width,
              padding: EdgeInsets.zero,
              child: adsWidget ?? const SizedBox.shrink()),
    );
  }

  Widget iconShortcuts(final dynamic rowUser) {
    final List<dynamic> icons = Constants.iconTops;
    return Container(
      padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10, right: 3),
      alignment: Alignment.center,
      width: Get.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: icons.map(
          (e) {
            final int indx = icons.indexOf(e);
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  debugPrint("clickedd...");
                  bool gotoPackage = false;
                  if (appController.box.pCodePackage.val == '') {
                    gotoPackage = true;
                  }

                  try {
                    int getCounterMax =
                        int.parse(rowUser['counter_max'].toString());
                    if (getCounterMax < 1) {
                      gotoPackage = true;
                    }
                  } catch (_) {}

                  if (gotoPackage) {
                    Get.to(PackagePage(isBackForce: true));
                    return;
                  }

                  if (indx == 0) {
                    Get.to(ChatbotPage(appController: appController));
                  } else if (indx == 1) {
                    Get.to(GenerateImagePage());
                  } else if (indx == 2) {
                    Get.to(VoiceTextPage());
                  } else if (indx == 3) {
                    Get.to(ScanOcrPage());
                  } else {
                    //Get.snackbar('Information', 'Coming Soon..');
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 15),
                  padding: const EdgeInsets.all(17),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Get.theme.primaryColor.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset:
                            const Offset(2, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  width: Get.width / 5.26,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        child: e['icon'],
                      ),
                      const SizedBox(height: 5),
                      Text("${e['title']}",
                          style: Get.theme.textTheme.labelMedium),
                    ],
                  ),
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  Widget topHeader(final dynamic user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user['display_name'].toString(),
                  style: Get.theme.textTheme.labelMedium!
                      .copyWith(color: Colors.grey[500])),
              Wrap(
                children: [
                  Text(Constants.appSubName,
                      style: Get.theme.textTheme.titleLarge),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      "(${Constants.appVersion})",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColor.greyLabel2,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
