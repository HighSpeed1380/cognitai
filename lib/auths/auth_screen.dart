import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:uuid/uuid.dart';
import 'package:app/app/home_page.dart';
import 'package:app/auths/widgets/fade_slide_transition.dart';
import 'package:app/auths/widgets/register_form.dart';
import 'package:app/helpers/app_color.dart';
import 'package:app/helpers/app_controller.dart';
import 'package:app/helpers/utility.dart';
import 'package:app/services/repository/user_repository.dart';

import 'widgets/custom_clippers/index.dart';
import 'widgets/header.dart';
import 'package:app/helpers/constants.dart';
import 'package:app/widgets/typewriter/type_text.dart';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';

class AuthScreen extends StatefulWidget {
  final double screenHeight;

  const AuthScreen({
    super.key,
    required this.screenHeight,
  });

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _headerTextAnimation;
  late final Animation<double> _formElementAnimation;
  late final Animation<double> _whiteTopClipperAnimation;
  late final Animation<double> _blueTopClipperAnimation;
  late final Animation<double> _greyTopClipperAnimation;

  final AppController appController = AppController.to;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: kLoginAnimationDuration,
    );
    final fadeSlideTween = Tween<double>(begin: 0.0, end: 1.0);
    _headerTextAnimation = fadeSlideTween.animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.0,
        0.6,
        curve: Curves.easeInOut,
      ),
    ));
    _formElementAnimation = fadeSlideTween.animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.7,
        1.0,
        curve: Curves.easeInOut,
      ),
    ));
    final clipperOffsetTween = Tween<double>(
      begin: widget.screenHeight,
      end: 0.0,
    );
    _blueTopClipperAnimation = clipperOffsetTween.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.2,
          0.7,
          curve: Curves.easeInOut,
        ),
      ),
    );
    _greyTopClipperAnimation = clipperOffsetTween.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.35,
          0.7,
          curve: Curves.easeInOut,
        ),
      ),
    );
    _whiteTopClipperAnimation = clipperOffsetTween.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.5,
          0.7,
          curve: Curves.easeInOut,
        ),
      ),
    );
    _animationController.forward();
    Future.microtask(() => appController.firstDone());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  final UserRepository userRepository = UserRepository();
  final isBackVisible = false.obs;
  final authModelScreen = AuthModelScreen().obs;

  @override
  Widget build(BuildContext context) {
    debugPrint("loginscreen build...${appController.box.pFirst.val} ");

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kWhite,
      body: Stack(
        children: <Widget>[
          // const Spacer(),
          AnimatedBuilder(
            animation: _whiteTopClipperAnimation,
            builder: (_, Widget? child) {
              return ClipPath(
                clipper: WhiteTopClipper(
                  yOffset: _whiteTopClipperAnimation.value,
                ),
                child: child,
              );
            },
            child: Container(color: kGrey),
          ),
          AnimatedBuilder(
            animation: _greyTopClipperAnimation,
            builder: (_, Widget? child) {
              return ClipPath(
                clipper: GreyTopClipper(
                  yOffset: _greyTopClipperAnimation.value,
                ),
                child: child,
              );
            },
            child: Container(color: kBlue),
          ),
          AnimatedBuilder(
            animation: _blueTopClipperAnimation,
            builder: (_, Widget? child) {
              return ClipPath(
                clipper: BlueTopClipper(
                  yOffset: _blueTopClipperAnimation.value,
                ),
                child: child,
              );
            },
            child: Container(color: kWhite),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Header(animation: _headerTextAnimation),
                  const Spacer(),
                  Obx(() => isBackVisible.value
                      ? formInputPassword()
                      : formInputEmail()),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Obx(
                      () => Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          isBackVisible.value
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      )),
                                  child: const Text("Back"),
                                  onPressed: () {
                                    //gotoNextPage(appController);
                                    isBackVisible.value = false;
                                  },
                                )
                              : const Spacer(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Get.theme.primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                            child: Text(isBackVisible.value
                                ? authModelScreen.value.textSubmit!
                                : "Continue"),
                            onPressed: () async {
                              final String getMail = textEmail.text.trim();
                              if (getMail.isEmpty) {
                                Utility.customSnackBar(
                                    context, 'Email is empty!');
                                return;
                              }

                              if (!getMail.isEmail) {
                                Utility.customSnackBar(
                                    context, 'Email invalid!');
                                return;
                              }

                              SystemChannels.textInput
                                  .invokeMethod('TextInput.hide');

                              if (isBackVisible.value) {
                                // check password
                                final String getPasswd = textPasswd.text;
                                if (getPasswd.isEmpty) {
                                  Utility.customSnackBar(
                                      context, 'Password invalid!');
                                  return;
                                }

                                authModelScreen.update((val) {
                                  val!.getOtpCode = '';
                                  val.email = getMail;
                                  val.password = getPasswd;
                                });

                                gotoNextPage(appController);
                                return;
                              }

                              focusNodeEmail.unfocus();
                              // showConfirmationOTPCode(getMail);
                              //cambios melvi contreras
                              isBackVisible.value = true;
                              Future.microtask(
                                  () => focusNodePassword.requestFocus());
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),

                  /*GetPlatform.isAndroid
                        ? optionAuth(appController)
                        : const SizedBox.shrink() */
                  FadeSlideTransition(
                    animation: _formElementAnimation,
                    additionalOffset: 0.0,
                    child: optionAuth(appController),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  showConfirmationOTPCode(final String getEmail) {
    Get.defaultDialog(
        title: "Confirmation",
        middleText:
            "It should send OTP code, please wait and check on your Inbox/Spam/Junk folder.\r\nAre you sure to proceed signin up with email address $getEmail?",
        backgroundColor: Get.theme.primaryColor.withOpacity(.7),
        titleStyle: Get.theme.textTheme.bodyLarge!
            .copyWith(fontWeight: FontWeight.bold, color: AppColor.white),
        middleTextStyle: TextStyle(color: AppColor.white),
        textConfirm: "Confirm",
        textCancel: "Cancel",
        confirmTextColor: AppColor.white,
        cancelTextColor: AppColor.white,
        buttonColor: Get.theme.primaryColor,
        barrierDismissible: false,
        radius: 10,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
        onConfirm: () async {
          Get.back();

          Future.microtask(() {
            doPushOTPCode(getEmail);
          });
        });
  }

  doPushOTPCode(final String getMail) async {
    authModelScreen.update((val) {
      val!.getOtpCode = '';
      val.email = getMail;
    });

    appController.showLoadingBottom(
        duration: const Duration(milliseconds: 1100), height: Get.height / 3.5);

    await Future.delayed(const Duration(milliseconds: 2100), () async {
      debugPrint("push userRepository.sendOTP response code is waiting1111 ..");

      Future.microtask(() {
        Get.snackbar('Information',
            "Please wait or you can try again, to get your OTP SignIn the flutter app",
            duration: const Duration(seconds: 5));
      });

      try {
        final Response? response = await userRepository.sendOTP(getMail);
        debugPrint("userRepository.sendOTP response code is waiting222 ..");
        //debugPrint(
        //    "userRepository.sendOTP response.statusCode: ${response!.statusCode}");

        if (response != null &&
            response.statusCode == 200 &&
            response.bodyString != null) {
          debugPrint("userRepository.sendOTP response code is waiting333 ..");

          Future.delayed(const Duration(milliseconds: 600), () {
            Get.snackbar('Information',
                "Waiting push OTP to your email address...\r\nIf no response, retry again in a minute...",
                duration: const Duration(seconds: 5));
          });

          dynamic dataresult = jsonDecode(response.bodyString!);
          if (dataresult['result'] != null) {
            dynamic jsonResp = dataresult['result'];
            final String getCode = jsonResp['code'].toString();
            final dynamic user = jsonResp['user'];
            authModelScreen.update((val) {
              val!.getOtpCode = getCode;
              val.user = user;
              val.textSubmit = user != null && user['id_user'] != null
                  ? 'Sign-In'
                  : 'Sign-Up';
            });
            debugPrint("get code $getCode");

            Future.delayed(const Duration(milliseconds: 4500), () {
              appController.showOTPCodeEmail(
                getCode,
                user,
                callback: () {
                  isBackVisible.value = true;
                  Future.microtask(() => focusNodePassword.requestFocus());
                },
              );
            });
          }
        }
      } on TimeoutException catch (_) {
        // catch timeout here..
        debugPrint("TimeoutException occured...");
      } catch (e) {
        // error
        debugPrint("Error occured... ${e.toString()}");
      }
    });
  }

  Widget formInputEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10, left: 25),
          child: TypeText(
            "Enter your email address",
            duration: Duration(milliseconds: 4000),
          ),
        ),
        FadeSlideTransition(
          animation: _formElementAnimation,
          additionalOffset: 0.0,
          child: inputEmail(),
        ),
      ],
    );
  }

  Widget formInputPassword() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
        padding: EdgeInsets.only(bottom: 10, left: 25),
        child: TypeText(
          "Enter your password",
          duration: Duration(milliseconds: 4000),
        ),
      ),
      FadeSlideTransition(
        animation: _formElementAnimation,
        additionalOffset: 0.0,
        child: inputPassword(),
      ),
    ]);
  }

  final TextEditingController textEmail = TextEditingController();
  final FocusNode focusNodeEmail = FocusNode();
  Widget inputEmail() {
    return Container(
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
          keyboardType: TextInputType.emailAddress,
          controller: textEmail,
          focusNode: focusNodeEmail,
          style: const TextStyle(fontSize: 18),
          cursorRadius: const Radius.circular(25),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 5),
            hintText: 'Type your email address',
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
    );
  }

  final TextEditingController textPasswd = TextEditingController();
  final FocusNode focusNodePassword = FocusNode();
  final isObsecure = true.obs;
  Widget inputPassword() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
            style: const TextStyle(fontSize: 18),
            onSubmitted: (val) {},
            onChanged: (val) {},
            obscureText: isObsecure.value,
            focusNode: focusNodePassword,
            keyboardType: TextInputType.text,
            controller: textPasswd,
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

  Widget optionAuth(final AppController appController) {
    return Container(
      width: Get.width,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.secondary.withOpacity(.2),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () async {
                  await pushGoogleSignIn();
                },
                icon: const Icon(BootstrapIcons.google, color: Colors.red),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.secondary.withOpacity(.2),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () async {
                  //Utility.customSnackBar(context, 'Coming soon!');
                  await pushAppleSignIn();
                },
                icon: const Icon(BootstrapIcons.apple, color: Colors.black),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.secondary.withOpacity(.2),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  Utility.customSnackBar(context, 'Coming soon!');
                },
                icon: const Icon(BootstrapIcons.facebook, color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
    );
  }

  pushGoogleSignIn() async {
    try {
      appController.showLoadingBottom(
          height: Get.height / 3.5,
          duration: const Duration(milliseconds: 3000));
      appController.initGoogleSignIn();

      Future.delayed(const Duration(milliseconds: 2000), () async {
        final GoogleSignInAccount? googleSigned =
            await appController.handleGoogleSignIn();
        if (googleSigned == null) {
          Future.microtask(() => Utility.customSnackBar(context,
              'This feature is not available at your device. Thank you'));
        } else {
          final String email = googleSigned.email;
          final String getFullname = googleSigned.displayName ?? 'Unknown';
          final String pic =
              googleSigned.photoUrl ?? Constants.defaultProfilePic;
          final String uid = googleSigned.id;

          appController.box.pIdUserAuth.val = uid;

          final dataJson = {
            "fullname": getFullname,
            "email": email,
            "password": "${Random().nextInt(10000 + 100)}",
            "image": pic,
            "type_account": "GOOGLE_SIGNIN",
          };

          debugPrint(dataJson.toString());

          final Response? response =
              await userRepository.signIn3Party(dataJson);
          if (response != null &&
              response.statusCode == 200 &&
              response.bodyString != null) {
            Future.microtask(() => Utility.customSnackBar(
                Get.context!, 'Welcome to $getFullname!'));

            dynamic dataresult = jsonDecode(response.bodyString!);
            if (dataresult['result'] != null && dataresult['code'] == '200') {
              List<dynamic> jsonResp = dataresult['result'];
              dynamic rowUser = jsonResp[0];

              appController.loginApp(jsonResp[0]);
              appController.box.pGoogleSignIn.val = true;

              appController.showLoadingBottom(height: Get.height / 3.5);

              await Future.delayed(const Duration(milliseconds: 2200));
              appController.box.pCodePackage.val =
                  rowUser['type_package'].toString();

              Get.offAll(HomePage());
            } else {
              Utility.customSnackBar(Get.context!,
                  'Error sign in account, ${dataresult['message']}');
            }
          } else {
            Utility.customSnackBar(
                Get.context!, 'No Response, Try again later...!');
          }
        }
      });
    } catch (e) {
      debugPrint("Error pushGoogleSignIn ${e.toString()}");
    }
  }

  //Create user from apple sign in
  // ref: https://firebase.flutter.dev/docs/auth/social/
  // ref: https://dev.to/offlineprogrammer/flutter-firebase-authentication-apple-sign-in-1m64

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  pushAppleSignIn() async {
    try {
      appController.showLoadingBottom(
          height: Get.height / 3.5,
          duration: const Duration(milliseconds: 3000));

      Future.delayed(const Duration(milliseconds: 2000), () async {
        final rawNonce = generateNonce();
        final nonce = sha256ofString(rawNonce);

        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: nonce,
        );

        if (appleCredential.email == null ||
            appleCredential.identityToken == null) {
          Future.microtask(() => Utility.customSnackBar(context,
              'This feature is not available at your device. Thank you'));
          return;
          //throw Exception('Apple login cancelled by user');
        } else {
          final displayName =
              '${appleCredential.givenName} ${appleCredential.familyName}';
          final userEmail = '${appleCredential.email}';
          debugPrint(
              "handleAppleSignIn displayName : $displayName userEmail: $userEmail");
          final String email = userEmail;
          final String getFullname = displayName;
          final String pic = Constants.defaultProfilePic;
          final String uid =
              appleCredential.userIdentifier ?? const Uuid().v1();
          appController.box.pIdUserAuth.val = uid;

          final dataJson = {
            "fullname": getFullname,
            "email": email,
            "password": "${Random().nextInt(10000 + 100)}",
            "image": pic,
            "type_account": "APPLE_SIGNIN",
          };

          debugPrint(dataJson.toString());

          final Response? response =
              await userRepository.signIn3Party(dataJson);
          if (response != null &&
              response.statusCode == 200 &&
              response.bodyString != null) {
            Future.microtask(() => Utility.customSnackBar(
                Get.context!, 'Welcome to $getFullname!'));

            dynamic dataresult = jsonDecode(response.bodyString!);
            if (dataresult['result'] != null && dataresult['code'] == '200') {
              List<dynamic> jsonResp = dataresult['result'];
              dynamic rowUser = jsonResp[0];

              appController.loginApp(jsonResp[0]);
              appController.box.pAppleSignIn.val = true;

              appController.showLoadingBottom(height: Get.height / 3.5);

              await Future.delayed(const Duration(milliseconds: 2200));
              appController.box.pCodePackage.val =
                  rowUser['type_package'].toString();

              Get.offAll(HomePage());
            } else {
              Utility.customSnackBar(Get.context!,
                  'Error sign in account, ${dataresult['message']}');
            }
          } else {
            Utility.customSnackBar(
                Get.context!, 'No Response, Try again later...!');
          }
        }
      });
    } catch (e) {
      debugPrint("Error pushAppleSignIn ${e.toString()}");
    }
  }

  gotoNextPage(final AppController appController) {
    // if create account
    final getUser = authModelScreen.value.user;
    if (getUser != null && getUser['id_user'] != null) {
      final String getEmail = authModelScreen.value.email!;
      final String getPasswd = authModelScreen.value.password!;
      debugPrint("sign in.... ");
      // go to login
      appController.showLoadingBottom(height: Get.height / 3.5);

      Future.delayed(const Duration(milliseconds: 1200), () async {
        final Response? response = await userRepository
            .signIn({"email": getEmail, "password": getPasswd});
        if (response != null &&
            response.statusCode == 200 &&
            response.bodyString != null) {
          dynamic dataresult = jsonDecode(response.bodyString!);
          debugPrint(dataresult.toString());

          if (dataresult['result'] != null && dataresult['code'] == '200') {
            List<dynamic> jsonResp = dataresult['result'];

            dynamic rowUser = jsonResp[0];

            appController.box.pPasswd.val = getPasswd;
            Future.microtask(() => Utility.customSnackBar(
                Get.context!, 'Welcome to ${rowUser['display_name']}!'));
            appController.loginApp(rowUser);
            appController.box.pCodePackage.val =
                rowUser['type_package'].toString();

            Get.offAll(HomePage());
          } else {
            Utility.customSnackBar(
                Get.context!, 'Error sign in, ${dataresult['message']}');
          }
        } else {
          Utility.customSnackBar(
              Get.context!, 'No Response, Try again later...!');
        }
      });
    } else {
      Get.to(RegisterForm(
          email: authModelScreen.value.email!,
          password: authModelScreen.value.password!));
    }
  }
}

class AuthModelScreen {
  String? getOtpCode;
  dynamic user;
  String? textSubmit = 'Sign-In';
  String? email;
  String? password;
}
