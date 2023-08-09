import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';
import 'package:app/app/home_page.dart';
import 'package:app/auths/auth_screen.dart';
import 'package:app/helpers/app_color.dart';
import 'package:app/helpers/constants.dart';
import 'package:app/helpers/app_controller.dart';
import 'package:app/helpers/my_pref.dart';
import 'package:app/pages/intro_page.dart';
import 'package:lottie/lottie.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await GetStorage.init(Constants.appStorage);

  //storage local box
  Get.lazyPut<MyPref>(() => MyPref.instance);
  Get.lazyPut<AppController>(() => AppController());

  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColor.greyExtraLight,
    ));

    final AppController appController = AppController.to;
    debugPrint("main dart AppController box ${appController.box.pFirst.val}");
    if (appController.box.pLogin.val) {
      appController.getUserAsync();

      Timer.periodic(const Duration(minutes: 15), (timer) {
        if (appController.box.pLogin.val) {
          appController.adsHelper.init();
          appController.getUserAsync();
        }
      });
    }
    return runApp(MyApp(appController: appController));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.appController});
  final AppController? appController;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    debugPrint("myfirst ${appController!.box.pFirst.val}");
    final box = appController!.box;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      theme: ThemeData(
        brightness: Brightness.light,
        //primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.roboto().fontFamily,
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: AnimatedSplashScreen(
        duration: 3200,
        splash: Lottie.asset('assets/lottie_animation.json',
            width: 300, height: 300),
        splashIconSize: Get.width / 1.6,
        nextScreen: appController!.box.pFirst.val
            ? IntroPage(appController: appController!)
            : box.pLogin.val
                ? HomePage()
                : AuthScreen(screenHeight: Get.height),
        pageTransitionType: PageTransitionType.fade,
        backgroundColor: Colors.white,
      ),
    );
  }
}
