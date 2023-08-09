import 'dart:convert';
import 'dart:io';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/helpers/app_color.dart';
import 'package:app/helpers/app_controller.dart';
import 'package:app/helpers/utility.dart';
import 'package:app/services/repository/user_repository.dart';
import 'package:app/widgets/commons/cache_image.dart';
import 'package:app/widgets/typewriter/type_text.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({super.key}) {
    final dynamic userLoggedIn = AppController.to.box.getUser();
    itemUpdate.update((val) {
      val!.userLoggedIn = userLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppController appController = AppController.to;

    return Container(
      width: Get.width,
      height: Get.height,
      color: Colors.white,
      child: Scaffold(
        body: SafeArea(
          child: Obx(
            () => itemUpdate.value.userLoggedIn == null
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      topHeader(appController, itemUpdate.value.userLoggedIn),
                      Flexible(
                        child: SingleChildScrollView(
                          child: createChildBody(
                              appController, itemUpdate.value.userLoggedIn),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  final itemUpdate = ItemUpdate().obs;

  createChildBody(
      final AppController appController, final dynamic userLoggedIn) {
    const double heightImage = 120;
    const double heightContainer = heightImage * 2;

    textFullname.text = userLoggedIn['display_name'].toString();

    itemUpdate.update((val) {
      val!.fullname = textFullname.text;
    });

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    width: Get.width,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(120),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: SizedBox(
                      width: heightImage,
                      height: heightImage,
                      child: Obx(
                        () => ClipRRect(
                          borderRadius: BorderRadius.circular(120),
                          child: itemUpdate.value.imageFile != null
                              ? Image.file(
                                  itemUpdate.value.imageFile!,
                                  width: heightImage,
                                  fit: BoxFit.cover,
                                )
                              : CacheImage(
                                  path: userLoggedIn['profile_pic'].toString(),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(120),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: SizedBox(
                      width: heightImage,
                      height: heightImage,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(120),
                        child: IconButton(
                          onPressed: () {},
                          iconSize: 33,
                          icon: Icon(BootstrapIcons.camera,
                              color: AppColor.greyExtraLight),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    height: heightContainer * .9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Get.theme.primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  )),
                              child: const Text("CAMERA"),
                              onPressed: () {
                                pickImageSource(appController, 2);
                              }),
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
                              child: const Text("GALLERY"),
                              onPressed: () {
                                pickImageSource(appController, 1);
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        formInputFullname(userLoggedIn),
      ],
    );
  }

  final TextEditingController textFullname = TextEditingController();
  final FocusNode focusNodeFullanem = FocusNode();
  Widget formInputFullname(final dynamic userLoggedIn) {
    textFullname.text = userLoggedIn['display_name'].toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10, left: 25),
          child: TypeText(
            "Enter your fullname",
            duration: Duration(milliseconds: 4000),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Get.theme.primaryColor),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: TextField(
              onSubmitted: (val) {},
              keyboardType: TextInputType.name,
              controller: textFullname,
              focusNode: focusNodeFullanem,
              cursorRadius: const Radius.circular(25),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                    left: 10, right: 10, top: 15, bottom: 5),
                hintText: 'Type your fullname',
                prefixIcon: Container(
                  margin: const EdgeInsets.only(right: 10, left: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    //color: Get.theme.primaryColor,
                  ),
                  child: Icon(BootstrapIcons.inbox,
                      color: Get.theme.primaryColor, size: 20),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget topHeader(final AppController appController, final dynamic user) {
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
                        Get.back();
                        AppController.to.getUserAsync();
                      },
                      child: Icon(
                        BootstrapIcons.chevron_left,
                        color: Get.theme.primaryColor,
                      )),
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
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Get.theme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                  child: const Text("SAVE"),
                  onPressed: () {
                    confirmSave(appController);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  //confimrSave
  final double maxHeight = 512;
  final double maxWidth = 512;

  String basename(String path) {
    return path.split('/').last;
  }

  final ImagePicker _picker = ImagePicker();
  pickImageSource(final AppController appController, final int tipe) async {
    // pick gallery
    if (tipe == 1) {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
      );
      if (image != null) {
        itemUpdate.update((val) {
          val!.imageFile = File(image.path);
        });

        Future.microtask(() async {
          String? base64Image =
              base64Encode(itemUpdate.value.imageFile!.readAsBytesSync());
          await startUpload(appController,
              basename(itemUpdate.value.imageFile!.path), base64Image);
        });
      }
    }
    // camera photo
    else {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
      );
      if (image != null) {
        itemUpdate.update((val) {
          val!.imageFile = File(image.path);
        });

        Future.microtask(() async {
          String? base64Image =
              base64Encode(itemUpdate.value.imageFile!.readAsBytesSync());
          await startUpload(appController,
              basename(itemUpdate.value.imageFile!.path), base64Image);
        });
      }
    }
  }

  confirmSave(final AppController appController) {
    String getName = textFullname.text.trim();
    if (getName.isEmpty) {
      Utility.customSnackBar(Get.context!, "Fullname invalid...");
      return;
    }

    if (getName.length < 6) {
      Utility.customSnackBar(Get.context!, "Fullname 6 characters min...");
      return;
    }

    itemUpdate.update((val) {
      val!.fullname = getName;
    });

    debugPrint("try to update user");
    appController.showLoadingBottom(duration: const Duration(seconds: 5));

    Future.delayed(const Duration(milliseconds: 2200), () {
      // just update fullname & image profile pic
      updateUser(appController, getName);
    });
  }

  updateUser(final AppController appController, final String name) async {
    try {
      var dataPush = {
        "fullname": name,
        "image": itemUpdate.value.urlServer,
        "action": "update_fullname",
      };

      debugPrint(jsonEncode(dataPush));
      final Response? result = await UserRepository().updateUser(dataPush);
      dynamic dataresult = jsonDecode(result!.bodyString!);
      if (dataresult['code'] == '200') {
        debugPrint(dataresult.toString());

        dynamic result = dataresult['result'];
        List<dynamic> jsonResp = result;
        dynamic rowUser = jsonResp[0];

        appController.box.pCodePackage.val = rowUser['type_package'];
        appController.box.pUserData.val = jsonEncode(rowUser);

        itemUpdate.update((val) {
          val!.userLoggedIn = rowUser;
        });

        Utility.customSnackBar(Get.context!, "Process success...");
      } else {
        Utility.customSnackBar(
            Get.context!, "Process failed, try again later...");
      }
    } catch (e) {
      debugPrint("edit profile, updateUser error ${e.toString()}");
      Utility.customSnackBar(
          Get.context!, "Process failed, try again later...");
    }
  }

  startUpload(final AppController appController, final String fileName,
      final String base64Image) async {
    try {
      String idUser = itemUpdate.value.userLoggedIn['id_user'];

      var dataPush = jsonEncode({
        "filename": fileName,
        "id": idUser,
        "image": base64Image,
      });

      //debugPrint(dataPush);
      var path = "uploader/upload_image_temp";
      debugPrint(path);

      final Response? result =
          await appController.provider.pushResponse(path, dataPush);
      dynamic dataresult = jsonDecode(result!.bodyString!);
      //debugPrint(_result);
      //EasyLoading.dismiss();
      if (dataresult['code'] == '200') {
        //EasyLoading.showSuccess("Process success...");
        String fileUploaded = "${dataresult['result']['file']}";
        debugPrint(fileUploaded);

        itemUpdate.update((val) {
          val!.result = dataresult;
          val.urlServer = fileUploaded;
        });

        debugPrint(
            "editprofile page file image server ${itemUpdate.value.urlServer}");

        //Utility.customSnackBar(Get.context!, "Process success...");
      } else {
        Utility.customSnackBar(Get.context!, "Process failed...");
      }

      String respCode = result.statusCode == 200
          ? dataresult['code'] == '200'
              ? "Uploaded"
              : "ErrorServer"
          : "ServerError";

      debugPrint(respCode);
    } catch (e) {
      debugPrint("edut profile page Error startUpload ${e.toString()}");
    }
  }
}

class ItemUpdate {
  dynamic userLoggedIn;
  String? fullname;
  File? imageFile;
  String? urlServer;
  dynamic result;
}
