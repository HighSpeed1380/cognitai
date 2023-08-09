import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/helpers/app_color.dart';
import 'package:app/helpers/constants.dart';
import 'package:app/helpers/my_pref.dart';
import 'package:app/helpers/translator_gpt.dart';
import 'package:app/pages/webview_page.dart';

class SettingPage extends StatelessWidget {
  SettingPage({super.key});

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
              const SizedBox(height: 20),
              Flexible(
                child: Obx(
                  // ignore: invalid_use_of_protected_member
                  () => genereateListViewSetting(menus.value),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  genereateListViewSetting(final List<dynamic> menuSettings) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(
        color: Colors.transparent,
      ),
      itemCount: menuSettings.length,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        padding: const EdgeInsets.only(bottom: 20),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10, top: 5),
            child: Icon(BootstrapIcons.check_circle_fill,
                color: Get.theme.primaryColor),
          ),
          title: Text(menuSettings[index]['title'].toString(),
              style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(menuSettings[index]['value'].toString()),
          trailing:
              Icon(menuSettings[index]['icon'], color: Get.theme.primaryColor),
          onTap: () {
            String value = menuSettings[index]['value'].toString();
            if (value.contains('http')) {
              Get.to(
                  WebviewPage(value, menuSettings[index]['title'].toString()));
              //Utility.launchURL(value);
            }

            if (index == 0) {
              showBottomSheetModelChat(value);
            } else if (index == 1) {
              showBottomSheetMaxToken(int.parse(value));
            } else if (index == 2) {
              showBottomSheetTranslator(value);
            }
          },
        ),
      ),
    );
  }

  final indexValue = ''.obs;
  showBottomSheetModelChat(final String value) {
    final List<dynamic> objects = Constants.objectModels;
    debugPrint("value $value");
    indexValue.value = value;

    Get.bottomSheet(
      Container(
        height: Get.height / 1.5,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Colors.white,
        ),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                "Model Options ChatBot",
                style: Get.theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              Wrap(
                  children: objects.map((e) {
                final val = e['title'].toString();

                return Obx(
                  () => InkWell(
                    onTap: () {
                      indexValue.value = val;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: indexValue.value == val
                            ? Get.theme.primaryColor
                            : AppColor.greyExtraLight,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      margin: const EdgeInsets.only(right: 10, bottom: 10),
                      child: Text("${e['code']}",
                          style: Get.theme.textTheme.bodyMedium!.copyWith(
                              color: indexValue.value == val
                                  ? Colors.white
                                  : AppColor.greyLabel)),
                    ),
                  ),
                );
              }).toList()),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.greyLabel,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text("Close"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Get.theme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      MyPref.to.pModelChat.val = indexValue.value;

                      menus[0] = {
                        "title": "Model ChatBot",
                        "icon": BootstrapIcons.chevron_compact_right,
                        "value": MyPref.to.pModelChat.val,
                      };

                      debugPrint("reload");
                      Get.back();
                    },
                    child: const Text("Save"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      barrierColor: Get.theme.primaryColor.withOpacity(.3),
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        side: BorderSide(
          width: 1,
          color: Colors.black12,
        ),
      ),
      enableDrag: false,
    );
  }

  final maxValue = 0.0.obs;
  showBottomSheetMaxToken(final int value) {
    maxValue.value = value.toDouble();

    final double maxToken = double.parse(MyPref.to.pMaxToken.val.toString());
    debugPrint("setting_page showBottomSheetMaxToken maxToken $maxToken");

    Get.bottomSheet(
      Container(
        height: Get.height / 2,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Colors.white,
        ),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                "Max Token Request ChatBot",
                style: Get.theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              Obx(
                () => SizedBox(
                  width: double.maxFinite,
                  child: CupertinoSlider(
                    min: 100.0,
                    max: maxToken,
                    value: maxValue.value,
                    onChanged: (value) {
                      maxValue.value = value;
                    },
                  ),
                ),
              ),
              Obx(
                () => SizedBox(
                  width: double.maxFinite,
                  child: Text("Max Token : ${maxValue.value.toInt()}"),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.greyLabel,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text("Close"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Get.theme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      MyPref.to.pMaxToken.val = maxValue.value.toInt();

                      menus[1] = {
                        "title": "Max Token ChatBot",
                        "icon": BootstrapIcons.chevron_compact_right,
                        "value": MyPref.to.pMaxToken.val,
                      };

                      debugPrint("reload");
                      Get.back();
                    },
                    child: const Text("Save"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      barrierColor: Get.theme.primaryColor.withOpacity(.3),
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        side: BorderSide(
          width: 1,
          color: Colors.black12,
        ),
      ),
      enableDrag: false,
    );
  }

  final menus = <dynamic>[
    {
      "title": "Model ChatBot",
      "icon": BootstrapIcons.chevron_compact_right,
      "value": MyPref.to.pModelChat.val,
    },
    {
      "title": "Max Token ChatBot",
      "icon": BootstrapIcons.chevron_compact_right,
      "value": MyPref.to.pMaxToken.val,
    },
    {
      "title": "Translator ChatBot",
      "icon": BootstrapIcons.chevron_compact_right,
      "value": MyPref.to.pTranslator.val,
    },
    // {
    //   "title": "Blog ChatBot WithAI",
    //   "icon": BootstrapIcons.chevron_compact_right,
    //   "value": "https://openai.com/blog/chatgpt/",
    // },
    // {
    //   "title": "About DALL·E 2 WithAI",
    //   "icon": BootstrapIcons.chevron_compact_right,
    //   "value": "https://openai.com/dall-e-2/",
    // },
    // {
    //   "title": "About GPT-4 Open AI",
    //   "icon": BootstrapIcons.chevron_compact_right,
    //   "value": "https://openai.com/product/gpt-4",
    // },
    // {
    //   "title": "More Example WithAI",
    //   "icon": BootstrapIcons.chevron_compact_right,
    //   "value": "https://platform.openai.com/examples",
    // }
  ].obs;

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
                      //appController.setPosition(0);
                      //Get.back();
                    },
                    child: const SizedBox.shrink(),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text("Adjustment your preferences",
                        style: Get.theme.textTheme.labelMedium!
                            .copyWith(color: Colors.grey[500])),
                    Text(Constants.labelSetting,
                        style: Get.theme.textTheme.titleLarge),
                    const SizedBox(height: 5),
                  ],
                ),
              ],
            ),
            Icon(BootstrapIcons.gear, color: Get.theme.primaryColor, size: 30)
          ],
        ),
      ),
    );
  }

  // add bottom translator selection
  final stringVal = ''.obs;
  showBottomSheetTranslator(final String value) {
    final List<dynamic> objects = TranslatorGPT().availableLangs;
    debugPrint("value $value");
    stringVal.value = value;

    Get.bottomSheet(
      Container(
        height: Get.height / 1.5,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Colors.white,
        ),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                "Translator Options ChatBot",
                style: Get.theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              Wrap(
                  children: objects.map((e) {
                final val = e['title'].toString();

                return Obx(
                  () => InkWell(
                    onTap: () {
                      stringVal.value = val;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: stringVal.value == val
                            ? Get.theme.primaryColor
                            : AppColor.greyExtraLight,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      margin: const EdgeInsets.only(right: 10, bottom: 10),
                      child: Text("${e['desc']}",
                          style: Get.theme.textTheme.bodyMedium!.copyWith(
                              color: stringVal.value == val
                                  ? Colors.white
                                  : AppColor.greyLabel)),
                    ),
                  ),
                );
              }).toList()),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.greyLabel,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text("Close"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Get.theme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      MyPref.to.pTranslator.val = stringVal.value;

                      menus[2] = {
                        "title": "Translator ChatBot",
                        "icon": BootstrapIcons.chevron_compact_right,
                        "value": MyPref.to.pTranslator.val,
                      };

                      debugPrint("reload");
                      Get.back();
                    },
                    child: const Text("Save"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      barrierColor: Get.theme.primaryColor.withOpacity(.3),
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        side: BorderSide(
          width: 1,
          color: Colors.black12,
        ),
      ),
      enableDrag: false,
    );
  }
}
