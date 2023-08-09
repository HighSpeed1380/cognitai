import 'dart:math';

import 'package:flutter/material.dart';
import 'package:app/pages/full_image_page.dart';
import 'package:app/helpers/app_color.dart';
import 'package:app/widgets/commons/cache_image.dart';
import 'package:get/get.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

class MessageImage extends StatelessWidget {
  const MessageImage({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    final indexHttp = text.indexOf('http');
    //![alt text](https://www.publicdomainpictures.net/pictures/30000/velka/beautiful-red-flower.jpg)
    final imageUrl = text.substring(indexHttp, text.length - 1).trim();
    debugPrint(imageUrl);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      alignment: Alignment.centerRight,
      child: text == ''
          ? const SizedBox.shrink()
          : Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Hero(
                    tag: "img-${Random().nextInt(500) + 100}",
                    child: InkWell(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                      onTap: () {
                        Get.to(FullImagePage(urlImage: imageUrl));
                      },
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                        child: Container(
                          width: Get.width * .83 - 8,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                          ),
                          child: AspectRatio(
                            aspectRatio: 4 / 3,
                            child: CacheImage(
                              path: imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppColor.white.withOpacity(.95),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(30),
                      ),
                      child: IconButton(
                        padding: const EdgeInsets.all(2),
                        constraints: const BoxConstraints(),
                        iconSize: 21,
                        icon: const Icon(BootstrapIcons.download),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
