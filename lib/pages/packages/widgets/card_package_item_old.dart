import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardPackageItemOld extends StatelessWidget {
  final int index;
  const CardPackageItemOld({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: index == 0
          ? cardTrial()
          : index == 1
              ? cardLimited()
              : cardUnLimited(),
    );
  }

  Widget cardUnLimited() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Container(
            width: Get.width,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.green),
            child: Text(
              "Unlimited Membership",
              style: Get.theme.textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 22),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
            ),
            child: Text(
              "Package Unlimited end of 30days counter. For bussiness, executive, coorporate, official partner user subscription.",
              style: Get.theme.textTheme.labelLarge,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(5),
                  child: Chip(
                    label: Text(
                      "\$299.99 per month",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    backgroundColor: Colors.green,
                  ),
                ),
                rowCard(
                  "unlimited text-chat",
                ),
                rowCard(
                  "unlimited image-generation",
                ),
                rowCard(
                  "Credit card required",
                ),
                rowCard(
                  "Unlimitless priviledges",
                ),
                rowCard(
                  "Paypal, GooglePay, ApplePay",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget cardLimited() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Container(
            width: Get.width,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.brown),
            child: Text(
              "Limited Membership",
              style: Get.theme.textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 22),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
            ),
            child: Text(
              "Package Limited end of 30days counter. For developer, startup, community, bussiness partner user subscription.",
              style: Get.theme.textTheme.labelLarge,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(5),
                  child: Chip(
                    label: Text(
                      "\$11.99 per month",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    backgroundColor: Colors.brown,
                  ),
                ),
                rowCard(
                  "30 times text-chat",
                ),
                rowCard(
                  "30 times image-generation",
                ),
                rowCard(
                  "Credit card required",
                ),
                rowCard(
                  "Limited privileges",
                ),
                rowCard(
                  "Paypal, GooglePay, ApplePay",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget cardTrial() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Container(
            width: Get.width,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.deepOrangeAccent),
            child: Text(
              "Trial Membership",
              style: Get.theme.textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 22),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
            ),
            child: Text(
              "Package Free Trial end of 30days counter. For student, personal, individual, learning, and testing user.",
              style: Get.theme.textTheme.labelLarge,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(5),
                  child: Chip(
                    label: Text(
                      "\$0.00 per month",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    backgroundColor: Colors.deepOrangeAccent,
                  ),
                ),
                rowCard(
                  "3 times text-chat",
                ),
                rowCard(
                  "3 times image-generation",
                ),
                rowCard(
                  "No credit card required",
                ),
                rowCard(
                  "Limitless Priviledges",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget rowCard(final String text) {
    return Row(
      children: [
        const Icon(BootstrapIcons.check2_circle, color: Colors.green),
        const SizedBox(width: 8),
        Text(text)
      ],
    );
  }
}
