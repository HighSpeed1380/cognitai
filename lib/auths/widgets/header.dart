import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';

import 'package:app/helpers/constants.dart';
import 'dart:math';
import 'package:app/auths/widgets/fade_slide_transition.dart';
import 'package:get/get.dart';

class Header extends StatelessWidget {
  final Animation<double> animation;

  const Header({
    super.key,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //logo(kBlue, 48.0),
          createTopIcon(),
          const SizedBox(height: kSpace14),
          FadeSlideTransition(
            animation: animation,
            additionalOffset: 0.0,
            child: Text(
              'Welcome to ${Constants.appName}',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: kBlack, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 2),
          FadeSlideTransition(
            animation: animation,
            additionalOffset: 16.0,
            child: Text(
              Constants.wording3,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: kBlack.withOpacity(0.5)),
            ),
          ),
        ],
      ),
    );
  }

  Widget createTopIcon() {
    return Container(
      margin: const EdgeInsets.only(right: 0),
      padding: const EdgeInsets.all(2),
      //alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Get.theme.primaryColor.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(2, 3), // changes position of shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(33),
        child: Image.asset('assets/LOGO.png', width: 43),
      ),
    );
  }

  Widget logo(final Color color, final double size) {
    return Transform.rotate(
      angle: -pi / 4,
      child: Icon(
        BootstrapIcons.x,
        color: color,
        size: size,
      ),
    );
  }
}
