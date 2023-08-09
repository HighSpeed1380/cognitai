import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/helpers/constants.dart';
import 'package:app/pages/full_image_page.dart';
import 'package:app/pages/webview_page.dart';
import 'package:app/widgets/commons/counter_remaining_circle.dart';
import 'package:app/helpers/app_controller.dart';
import 'package:app/widgets/commons/cache_image.dart';
import 'package:app/pages/edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppController appController = AppController.to;
    final dynamic userLoggedIn = appController.box.getUser();

    List<dynamic> menus = [
      {
        "title": "${userLoggedIn['display_name']}",
        "icon": BootstrapIcons.chevron_compact_right,
        "value": "Fullname",
      },
      {
        "title": "Password",
        "icon": BootstrapIcons.chevron_compact_right,
        "value": "Change Password",
      },
      {
        "title": "Renewal Package",
        "icon": BootstrapIcons.chevron_compact_right,
        "value": "Membership Package renewal",
      },
      {
        "title": "App Version",
        "icon": BootstrapIcons.chevron_compact_right,
        "value": Constants.appVersion,
      },
      {
        "title": "Logout",
        "icon": BootstrapIcons.chevron_compact_right,
        "value": "Exit from appplication",
      },
      {
        "title": "Delete Account",
        "icon": BootstrapIcons.chevron_compact_right,
        "value": "Delete your account member",
      },
    ];

    return Container(
      width: Get.width,
      height: Get.height,
      color: Colors.white,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => topHeader(
                    appController.dataUser.value.user ?? userLoggedIn),
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: createChildBody(appController, menus, userLoggedIn),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  createChildBody(
      AppController appController, List<dynamic> menus, dynamic userLoggedIn) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Container(
          width: Get.width / 1.1,
          height: Get.height / 3.1,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(FullImagePage(
                          urlImage: userLoggedIn['profile_pic'].toString()));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Get.theme.primaryColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.all(3),
                      child: SizedBox(
                        width: 70,
                        height: 70,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CacheImage(
                            path: userLoggedIn['profile_pic'].toString(),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      //gotoRenewalPage(appController);
                      appController.gotoRenewalDialog();
                    },
                    child: CounterRemainingCircle(appController: appController),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                // child: Text(
                //   'Since: ${userLoggedIn['created_at']}'.toString(),
                //   style: Get.theme.textTheme.bodySmall!.copyWith(fontSize: 12),
                // ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0),
                // child: Text(
                //   'Expired At: ${userLoggedIn['expired_at']}'.toString(),
                //   style: Get.theme.textTheme.bodySmall!
                //       .copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                // ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Get.theme.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                    child: const Text("Edit Profile"),
                    onPressed: () {
                      Get.to(EditProfilePage());
                    }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        ListView.separated(
          separatorBuilder: (context, index) => const Divider(
            color: Colors.transparent,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 30),
          itemCount: menus.length,
          itemBuilder: (context, index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: ListTile(
              title: Text(menus[index]['title'].toString(),
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(menus[index]['value'].toString()),
              trailing:
                  Icon(menus[index]['icon'], color: Get.theme.primaryColor),
              onTap: () {
                String value = menus[index]['value'].toString();
                String title = menus[index]['title'].toString();
                if (value.contains('http')) {
                  //Utility.launchURL(value);
                  Get.to(WebviewPage(value, title));
                } else if (title == 'Logout') {
                  appController.showDialogConfirmLogout(context, appController);
                } else if (title.contains('Renewal')) {
                  //gotoRenewalPage(appController);
                  appController.gotoRenewalDialog();
                } else if (title.contains('Delete Account')) {
                  appController.showDialogConfirmDeleteAccount(
                      context, appController);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget topHeader(final dynamic user) {
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
                    ),*/
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text(user['email'].toString(),
                        style: Get.theme.textTheme.labelMedium!
                            .copyWith(color: Colors.grey[500])),
                    Text(user['display_name'].toString(),
                        style: Get.theme.textTheme.titleLarge),
                    const SizedBox(height: 5),
                  ],
                ),
              ],
            ),
            Text(user['type_package'].toString(),
                style: Get.theme.textTheme.titleLarge!
                    .copyWith(color: Get.theme.primaryColor))
          ],
        ),
      ),
    );
  }
}
