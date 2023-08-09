import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/app/home_page.dart';
import 'package:app/helpers/app_color.dart';
import 'package:app/helpers/app_controller.dart';
import 'package:app/helpers/constants.dart';
import 'package:app/helpers/utility.dart';
import 'package:app/services/repository/user_repository.dart';
import 'package:app/widgets/typewriter/type_text.dart';

class RegisterForm extends StatelessWidget {
  RegisterForm({super.key, required this.email, required this.password});

  final String email;
  final String password;

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
              const SizedBox(height: 5),
              Flexible(child: createScrollBody()),
            ],
          ),
        ),
      ),
    );
  }

  final UserRepository userRepository = UserRepository();
  final AppController appController = AppController.to;

  Widget createScrollBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Account Registration",
                style: Get.theme.textTheme.headlineSmall!.copyWith(
                    color: AppColor.black, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text("Verified Email"),
            const SizedBox(height: 5),
            Wrap(
              children: [
                const Icon(BootstrapIcons.check_circle_fill,
                    color: Colors.green),
                const SizedBox(width: 5),
                Text(
                  email,
                  style: Get.theme.textTheme.bodyMedium!.copyWith(
                    color: Get.theme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            formInputFullname(),
            const SizedBox(height: 20),
            formInputRePassword(),
            const SizedBox(height: 30),
            Container(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Get.theme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                child: const Text("Submit"),
                onPressed: () {
                  final String getFullname = textFullname.text.trim();
                  if (getFullname.isEmpty) {
                    Utility.customSnackBar(Get.context!, 'Fullname invalid!');
                    return;
                  }

                  if (getFullname.length > 27) {
                    Utility.customSnackBar(
                        Get.context!, 'Fullname max 27 characters!');
                    return;
                  }

                  final String getRePasswd = textRePasswd.text.trim();
                  if (getRePasswd.isEmpty) {
                    Utility.customSnackBar(
                        Get.context!, 'Re-Password invalid!');
                    return;
                  }

                  if (getRePasswd.length < 6) {
                    Utility.customSnackBar(
                        Get.context!, 'Password min 6 characters!');
                    return;
                  }

                  if (getRePasswd != password) {
                    Utility.customSnackBar(
                        Get.context!, 'Password does not matched');
                    return;
                  }

                  appController.showLoadingBottom(height: Get.height / 3.5);

                  Future.delayed(const Duration(milliseconds: 1200), () async {
                    final Response? response = await userRepository
                        .createAccount({
                      "fullname": getFullname,
                      "email": email,
                      "password": password
                    });
                    if (response != null &&
                        response.statusCode == 200 &&
                        response.bodyString != null) {
                      Future.microtask(() => Utility.customSnackBar(
                          Get.context!, 'Welcome to $getFullname!'));

                      dynamic dataresult = jsonDecode(response.bodyString!);
                      if (dataresult['result'] != null &&
                          dataresult['code'] == '200') {
                        List<dynamic> jsonResp = dataresult['result'];
                        appController.box.pPasswd.val = password;
                        appController.loginApp(jsonResp[0]);

                        await Future.delayed(
                            const Duration(milliseconds: 2200));
                        appController.showSuccessBottom(callback: () {
                          Get.offAll(HomePage());
                        });
                      } else {
                        Utility.customSnackBar(Get.context!,
                            'Error create account, ${dataresult['message']}');
                      }
                    } else {
                      Utility.customSnackBar(
                          Get.context!, 'No Response, Try again later...!');
                    }
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  final TextEditingController textFullname = TextEditingController();
  Widget formInputFullname() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10, left: 0),
          child: TypeText(
            "Enter your fullname",
            duration: Duration(milliseconds: 4000),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 0),
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

  Widget formInputRePassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10, left: 0),
          child: TypeText(
            "Retype your password again",
            duration: Duration(milliseconds: 4000),
          ),
        ),
        inputRePassword(),
      ],
    );
  }

  final TextEditingController textRePasswd = TextEditingController();
  final isObsecure = true.obs;
  Widget inputRePassword() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Get.theme.primaryColor),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Obx(
          () => TextField(
            onSubmitted: (val) {},
            obscureText: isObsecure.value,
            keyboardType: TextInputType.text,
            controller: textRePasswd,
            cursorRadius: const Radius.circular(25),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                  left: 10, right: 10, top: 15, bottom: 5),
              hintText: 'Minimal 6 alphanumeric',
              prefixIcon: Container(
                margin: const EdgeInsets.only(right: 10, left: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  //color: Get.theme.primaryColor,
                ),
                child: Icon(
                  BootstrapIcons.lock,
                  color: Get.theme.primaryColor,
                  size: 20,
                ),
              ),
              suffixIcon: InkWell(
                onTap: () {
                  isObsecure.value = !isObsecure.value;
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 10, left: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    isObsecure.value
                        ? BootstrapIcons.eye_slash
                        : BootstrapIcons.eye,
                    color: Get.theme.primaryColor,
                    size: 20,
                  ),
                ),
              ),
              fillColor: Colors.white,
              filled: true,
            ),
          ),
        ),
      ),
    );
  }

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
                        Get.back();
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
                    Text("Create new account for registration",
                        style: Get.theme.textTheme.labelMedium!
                            .copyWith(color: Colors.grey[500])),
                    Text(Constants.labelRegister,
                        style: Get.theme.textTheme.titleLarge),
                    const SizedBox(height: 5),
                  ],
                ),
              ],
            ),
            Icon(BootstrapIcons.person_add,
                color: Get.theme.primaryColor, size: 30)
          ],
        ),
      ),
    );
  }
}
