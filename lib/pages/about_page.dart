import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/helpers/constants.dart';
import 'package:app/pages/webview_page.dart';

class AboutPage extends StatelessWidget {
  AboutPage({super.key});

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
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                    color: Colors.transparent,
                  ),
                  itemCount: menus.length,
                  itemBuilder: (context, index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white,
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        child: Icon(BootstrapIcons.check_circle_fill,
                            color: Get.theme.primaryColor),
                      ),
                      title: Text(menus[index]['title'].toString(),
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(menus[index]['value'].toString()),
                      trailing: Icon(menus[index]['icon'],
                          color: Get.theme.primaryColor),
                      onTap: () {
                        String value = menus[index]['value'].toString();
                        if (value.contains('http')) {
                          Get.to(WebviewPage(
                              value, menus[index]['title'].toString()));
                          //Utility.launchURL(value);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final List<dynamic> menus = [
    // {
    //   "title": "Pub.dev ChatGPT",
    //   "icon": BootstrapIcons.chevron_compact_right,
    //   "value": "https://pub.dev/packages/chat_gpt_sdk",
    // },
    // {
    //   "title": "CognitAI Frontpage",
    //   "icon": BootstrapIcons.chevron_compact_right,
    //   "value": "https://CognitAI.erhacorp.id",
    // },
    {
      "title": "Developer Web",
      "icon": BootstrapIcons.chevron_compact_right,
      "value": "https://erhacorp.id",
    },
    {
      "title": "Market Web",
      "icon": BootstrapIcons.chevron_compact_right,
      "value": "https://play.google.com/",
    },
    {
      "title": "Version",
      "icon": BootstrapIcons.chevron_compact_right,
      "value": Constants.appVersion,
    },
  ];

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
                      //Get.back();
                    },
                    child: const SizedBox.shrink(),
                    /*Icon(
                        BootstrapIcons.chevron_left,
                        color: Get.theme.primaryColor,
                      )*/
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text("Information of application",
                        style: Get.theme.textTheme.labelMedium!
                            .copyWith(color: Colors.grey[500])),
                    Text(Constants.labelAbout,
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
