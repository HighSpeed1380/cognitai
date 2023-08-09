import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/widgets/popup_menu2/popup_menu_2.dart';

class OptionMessage extends StatelessWidget {
  OptionMessage(
      {super.key,
      this.child,
      required this.copyClicked,
      required this.shareClicked});

  final Widget? child;
  final VoidCallback copyClicked;
  final VoidCallback shareClicked;
  final GlobalKey uniqueKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ContextualMenu(
      targetWidgetKey: uniqueKey,
      ctx: context,
      maxColumns: 2,
      backgroundColor: Get.theme.primaryColor,
      highlightColor: Colors.white,
      onDismiss: () {},
      items: [
        CustomPopupMenuItem(
          press: () {
            copyClicked();
          },
          title: 'Copy',
          textAlign: TextAlign.justify,
          textStyle: const TextStyle(color: Colors.white, fontSize: 11),
          image: const Icon(BootstrapIcons.clipboard2, color: Colors.white),
        ),
        CustomPopupMenuItem(
          press: () {
            //Get.to(AboutPage());
            shareClicked();
          },
          title: 'Share',
          textAlign: TextAlign.justify,
          textStyle: const TextStyle(color: Colors.white, fontSize: 11),
          image: const Icon(BootstrapIcons.share, color: Colors.white),
        ),
      ],
      child: Container(
        key: uniqueKey,
        padding: const EdgeInsets.only(top: 0),
        child: child ??
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(55),
                  color: Get.theme.primaryColor),
              padding: const EdgeInsets.all(15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(55),
                child: const Icon(
                  BootstrapIcons.three_dots,
                  color: Colors.white,
                ),
              ),
            ),
      ),
    );
  }
}
