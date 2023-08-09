import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/helpers/app_color.dart';
import 'package:app/helpers/app_controller.dart';
import 'package:app/helpers/constants.dart';
import 'package:app/pages/packages/package_order.dart';
import 'package:app/widgets/swipeable_button_view/swipeable_button_view.dart';
import 'package:app/pages/packages/widgets/card_package_item.dart';

class PackagePage extends StatelessWidget {
  PackagePage({super.key, this.isBackForce}) {
    Future.delayed(Duration.zero, () {
      appController.getSettings();
      appController.box.pInPackagePage.val = true;
      Future.delayed(const Duration(seconds: 8), () {
        appController.box.pInPackagePage.val = false;
      });
    });
  }

  final indexImage = 0.obs;
  final AppController appController = AppController.to;
  final bool? isBackForce;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Scaffold(
          body: Container(
            width: Get.width,
            height: Get.height,
            color: Colors.blue,
            child: Stack(
              children: [
                Container(
                  width: Get.width,
                  height: Get.height / 1.5,
                  padding: EdgeInsets.zero,
                  child: Stack(
                    children: [
                      Obx(() => appController.aPIObject.value.packages ==
                                  null ||
                              appController.aPIObject.value.packages!.isEmpty
                          ? const SizedBox(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(),
                            )
                          : sliderPackages(
                              appController.aPIObject.value.packages!)),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Obx(
                          () => appController.aPIObject.value.packages ==
                                      null ||
                                  appController
                                      .aPIObject.value.packages!.isEmpty
                              ? const SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CircularProgressIndicator(),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: appController
                                      .aPIObject.value.packages!
                                      .map((entry) {
                                    final idx = appController
                                        .aPIObject.value.packages!
                                        .indexOf(entry);
                                    return GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        width:
                                            indexImage.value == idx ? 20 : 12.0,
                                        height:
                                            indexImage.value == idx ? 20 : 12.0,
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 20.0,
                                          horizontal: 4.0,
                                        ),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: indexImage.value == idx
                                              ? Colors.orange
                                              : Get.theme.colorScheme.background
                                                  .withOpacity(0.35),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: Get.width,
                  margin: EdgeInsets.only(top: Get.height / 1.5),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  alignment: Alignment.bottomCenter,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => appController.aPIObject.value.packages == null ||
                                appController.aPIObject.value.packages!.isEmpty
                            ? const SizedBox(
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator(),
                              )
                            : bodySlider(appController
                                .aPIObject.value.packages![indexImage.value]),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (isBackForce != null && isBackForce!)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  )),
                              child: const Text("Back"),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                          if (isBackForce != null && isBackForce!)
                            const SizedBox(width: 10),
                          Obx(
                            () => appController.aPIObject.value.packages ==
                                        null ||
                                    appController
                                        .aPIObject.value.packages!.isEmpty
                                ? const SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CircularProgressIndicator(),
                                  )
                                : orderPackage(
                                    appController,
                                    appController.aPIObject.value
                                        .packages![indexImage.value]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget sliderPackages(final List<dynamic> packages) {
    return CarouselSlider(
      options: CarouselOptions(
          height: Get.height / 1.5,
          enlargeCenterPage: true,
          enlargeFactor: 0.3,
          viewportFraction: 0.85,
          onPageChanged: (index, _) {
            indexImage.value = index;
          }),
      items: packages.map((i) {
        final int idx = packages.indexOf(i);
        Color color = Constants.colors[idx];
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: Get.width,
              margin: const EdgeInsets.only(
                top: 30.0,
                bottom: 10,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 0.0,
                vertical: 15,
              ),
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: CardPackageItem(
                package: i,
                color: color,
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget orderPackage(
      final AppController appController, final dynamic package) {
    bool isFree = true;
    if (package['price'].toString() != '0') {
      isFree = false;
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Get.theme.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          )),
      child: Text(isFree ? "Continue" : "Order Package",
          style:
              Get.theme.textTheme.titleMedium!.copyWith(color: AppColor.white)),
      onPressed: () {
        final List<dynamic> iconPays = GetPlatform.isAndroid
            ? Constants.iconPaysAndroid
            : Constants.iconPaysIOS;
        dynamic method = iconPays[indxSelected.value];

        Get.to(PackageOrder(
            item: appController.aPIObject.value.packages![indexImage.value],
            method: method,
            index: indexImage.value));
      },
    );
  }

  final indxSelected = 0.obs;
  Widget bodySlider(final dynamic package) {
    final List<dynamic> iconPays = GetPlatform.isAndroid
        ? Constants.iconPaysAndroid
        : Constants.iconPaysIOS;

    final price = package['price'].toString();

    String desc =
        "${package['title'].toString()} Price ${package['currency'].toString()} $price/mon";
    if (price == '0') {
      desc = "${package['title'].toString()} is FREE";
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        if (price != '0')
          Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: iconPays.map((e) {
                final idx = iconPays.indexOf(e);
                return InkWell(
                  onTap: () {
                    indxSelected.value = idx;
                  },
                  child: Obx(
                    () => Container(
                      margin: const EdgeInsets.only(right: 10, bottom: 10),
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          color: indxSelected.value == idx
                              ? Get.theme.primaryColor.withOpacity(.9)
                              : AppColor.greyExtraLight,
                          borderRadius: BorderRadius.circular(12)),
                      child: Image.asset(
                        e['asset'],
                        width: Get.width / 4.3,
                      ),
                    ),
                  ),
                );
              }).toList()),
        if (price != '0') const SizedBox(height: 5),
        Text(
          desc,
          textAlign: TextAlign.center,
          style: Get.theme.textTheme.titleMedium!.copyWith(
            color: AppColor.greyLabel2,
          ),
        ),
      ],
    );
  }

  final isFinished = false.obs;
  Widget slideToStart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Obx(
        () => SwipeableButtonView(
          buttonText: 'Slide to Submit',
          buttontextstyle: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
          buttonWidget: const Icon(
            BootstrapIcons.chevron_right,
            color: Colors.grey,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(2, 3), // changes position of shadow
            ),
          ],
          activeColor: Get.theme.primaryColor,
          isFinished: isFinished.value,
          onWaitingProcess: () {
            Future.delayed(const Duration(seconds: 2), () {
              isFinished.value = true;
            });
          },
          onFinish: () async {
            debugPrint("finish...");

            //storage local box
            //Get.lazyPut<MyPref>(() => MyPref.instance);
            //Get.lazyPut<AppController>(() => AppController());
            //Get.offAll(HomePage());

            final List<dynamic> iconPays = GetPlatform.isAndroid
                ? Constants.iconPaysAndroid
                : Constants.iconPaysIOS;

            Get.to(PackageOrder(
                item: const {"total": "Free"},
                method: iconPays[indexImage.value]['title'].toString(),
                index: indexImage.value));
          },
        ),
      ),
    );
  }
}
