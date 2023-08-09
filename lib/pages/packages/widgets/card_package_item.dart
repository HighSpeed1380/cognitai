import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardPackageItem extends StatelessWidget {
  final dynamic package;
  final Color color;
  const CardPackageItem(
      {super.key, required this.package, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: cardPackage(package),
    );
  }

  Widget cardPackage(final dynamic data) {
    //debugPrint(data['details'].toString());

    List<dynamic> details = [
      {"title": "0"}
    ];
    details.addAll(data['details']);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Container(
            width: Get.width,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: color),
            child: Text(
              "${data['title']}",
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
              "${data['description']}",
              style: Get.theme.textTheme.labelLarge,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              children: details.map((item) {
                if (item['title'] == '0') {
                  return rowHeader(data);
                }
                return rowCard(item['title']);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget rowHeader(final dynamic item) {
    String descPrice = " FREE ";
    if (item['price'].toString() != '0') {
      descPrice = "${item['currency']} ${item['price']}/mon";
    }
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Chip(
        label: Text(
          descPrice,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 19,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        backgroundColor: color,
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
