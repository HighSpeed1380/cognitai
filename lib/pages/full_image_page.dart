import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/widgets/commons/cache_image.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class FullImagePage extends StatelessWidget {
  const FullImagePage({super.key, required this.urlImage});
  final String urlImage;

  @override
  Widget build(BuildContext context) {
    debugPrint("get url $urlImage");
    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: SizedBox(
          width: Get.width,
          height: Get.height,
          child: PhotoView(
            imageProvider: CacheImage.imageProvider(urlImage),
          ),
        ),
      ),
    );
  }
}
