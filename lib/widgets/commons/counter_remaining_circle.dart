import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/helpers/app_color.dart';
import 'package:app/helpers/app_controller.dart';

class CounterRemainingCircle extends StatelessWidget {
  const CounterRemainingCircle({super.key, required this.appController});

  final AppController? appController;
  @override
  Widget build(BuildContext context) {
    final getUserLoggedIn = appController!.box.getUser();

    String textMax = "0";
    int getUserMax = 0;
    if (getUserLoggedIn['counter_max'] != null) {
      getUserMax = int.parse(getUserLoggedIn['counter_max'].toString());
      textMax = getUserMax.toString();

      if (getUserMax > 999) {
        double gm = getUserMax / 1000;
        int gMax = gm.toInt();
        textMax = "${gMax}K";
      }
    }

    double fontSize = 25;
    int getMax = appController!.getMaxHitByPackage();
    if (getMax > 99) {
      fontSize = 21;
    }

    Color wordCountColor = Colors.blue;

    if (getUserMax > (getMax * 0.25) && getUserMax < (getMax * 0.75)) {
      wordCountColor = Colors.orange;
    } else if (getUserMax >= (getMax * 0.75)) {
      wordCountColor = Colors.green;
    } else {
      wordCountColor = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      padding: const EdgeInsets.all(3),
      child: Stack(
        children: [
          Container(
            width: 80,
            height: 80,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: wordCountColor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: CircularProgressIndicator(
              value: getMaxLimit(getUserMax, getMax),
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(wordCountColor),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              width: 70,
              height: 70,
              alignment: Alignment.center,
              margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Get.theme.primaryColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Column(
                  children: [
                    Text(
                      textMax,
                      style: Get.theme.textTheme.headlineSmall!
                          .copyWith(color: AppColor.white, fontSize: fontSize),
                    ),
                    Text("Left",
                        style: Get.theme.textTheme.bodySmall!
                            .copyWith(color: AppColor.white)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double getMaxLimit(final int getUser, final int getMax) {
    if (getUser >= getMax) {
      return 1.0;
    }
    var length = getUser;
    var val = length * 100 / (getMax * 100);
    return val;
  }
}
