import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:app/app/home_screen.dart';
import 'package:app/helpers/ads_helper.dart';
import 'package:app/helpers/app_controller.dart';
import 'package:app/helpers/constants.dart';
import 'package:app/pages/about_page.dart';
import 'package:app/pages/chatbot_page.dart';
import 'package:app/pages/generate_image_page.dart';
import 'package:app/pages/packages/package_page.dart';
import 'package:app/pages/profile_page.dart';
import 'package:app/widgets/commons/cache_image.dart';
import 'package:app/pages/setting_page.dart';
import 'package:app/pages/voice_text_page.dart';
import 'package:app/widgets/circle_bottom_navigation_bar/circle_bottom_navigation_bar.dart';
import 'package:app/widgets/circle_bottom_navigation_bar/widgets/tab_data.dart';
import 'package:app/pages/scan_ocr_page.dart';

class HomePage extends StatelessWidget {
  static String tAG = "HomePage";
  HomePage({super.key});
  final AppController appController = AppController.to;

  /*
  set for bottom navigation
   */

  final double bottomNavBarHeight = 60;
  /*
  set for bottom navigation
   */

  final GlobalKey keyPopup = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final bannerContainer = AdsHelper.bannerContainer;
    final dynamic userLoggedIn = appController.box.getUser();
    return WillPopScope(
      onWillPop: () => onBackPress(),
      child: Container(
        width: Get.width,
        height: Get.height,
        color: Colors.white,
        child: Obx(
          () => bodyContainer(context, userLoggedIn, bannerContainer,
              appController.selectedPos.value),
        ),
      ),
    );
  }

  Widget bodyContainer(final BuildContext context, final dynamic userLoggedIn,
      final Rx<WidgetAdsBanner> bannerContainer, final int position) {
    return Container(
      width: Get.width,
      height: Get.height,
      color: Colors.white,
      child: Scaffold(
        extendBody: true,
        body: switchBodyScreen(position),
        bottomNavigationBar: CircleBottomNavigationBar(
          initialSelection: position,
          // circleColor: Get.theme.primaryColor,
          activeIconColor: Colors.grey,
          inactiveIconColor: Colors.grey,
          tabs: [
            TabData(
              icon: BootstrapIcons.house,
              iconSize: 22, // Optional
            ),
            TabData(icon: BootstrapIcons.person, iconSize: 22),
            TabData(icon: BootstrapIcons.gear, iconSize: 22),
            TabData(icon: BootstrapIcons.info_square, iconSize: 22),
          ],
          onTabChangedListener: (index) => appController.setPosition(index),
        ),
      ),
    );
  }

  Widget switchBodyScreen(final int position) {
    if (position == 1) {
      return const ProfilePage();
    } else if (position == 2) {
      return SettingPage();
    } else if (position == 3) {
      return AboutPage();
    }
    return HomeScreen(appController: appController);
  }

  final _channel = MethodChannel(Constants.methodChannel);
  Future<bool> onBackPress() {
    debugPrint("onBackPress MyHomePage...");
    if (GetPlatform.isAndroid) {
      if (Navigator.of(Get.context!).canPop()) {
        return Future.value(true);
      } else {
        _channel.invokeMethod('sendToBackground');

        return Future.value(false);
      }
    } else {
      return Future.value(true);
    }
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
              Text(Constants.appSubName, style: Get.theme.textTheme.titleLarge),
            ],
          ),
          InkWell(
            onTap: () {
              Get.to(const ProfilePage());
            },
            child: Container(
              decoration: BoxDecoration(
                color: Get.theme.primaryColor,
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.all(3),
              child: SizedBox(
                width: 30,
                height: 30,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CacheImage(
                    path: user['profile_pic'].toString(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
