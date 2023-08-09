import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Constants {
  static String appName = "CognitAI";
  static String appVersion = "v. 1.0";
  static String appSubName = "CognitAI";
  static String appStorage = "CognitAI_storage";

  //API Key Token ChatGPT OpenAI...esta es la api de open ai original
  static String apiKeyToken =
      "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";
  //"<update with your OpenAPI Key Paid Account>";
  // https://platform.openai.com/signup

  // homepage
  static String helloGuest = "Hello Guest";

  static String defaultProfilePic =
      'https://cognitai.site/uploaded/def_profile.jpeg';

  // intropge
  static String wording0 =
      '$appName GPT-4 is Fun & Interactive ChatBot Artificial Intelligence';
  static String wording1 =
      '$appName is new chat GPT-4 AI interacts in a conversational way.';
  static String wording2 =
      'This $appName artificial intelligence chatbot with AI, is designed to entertain and engage users in conversation. search anything with AI and multi languages translator ready';
  static String wording3 =
      'Fun and interatives conversational with $appName many input variant ways';

  static List<dynamic> slideWordings = [
    {"title": wording0, "desc": wording2},
    {
      "title": 'ChatBot & DALL·E 2 Text & Image Model',
      "desc":
          'Fun and interatives conversational with ChatBot. Image generation DALL·E 2 Model Image Generation AI. TypeWriter Answer with Animation  Ready!'
    },
    {
      "title": "Membership Plan support with Multi Payments Integrated",
      "desc":
          "Template Module. Three packages available Trial, Limited, Unlimited Membership Package Subscription. Cancellation anytime!"
    },
  ];

  static dynamic packageInfo = {
    "title": "Membership Plan support Paypal, Google Pay, Apple Pay",
    "desc":
        "Template Module. Three packages available Trial, Limited, Unlimited Membership Package Subscription. Cancellation anytime!"
  };

  // chatbot text
  static String questionAnswer = "Question, Answer";
  static String textToImage = "Text to Image";
  static String speechToText = "Speech To Text";
  static String imageToText = "Image To Text - OCR";

  static int maxTimeoutStream = 255; // in seconds

  static String urlDummy = 'https://erhacorp.id/logorh256.png';
  static String labelSetting = "Setting";
  static String labelAbout = "About";
  static String labelPay = "Pay";
  static String labelOrder = "Order";
  static String labelPlaceOrder = "Place Order";
  static String labelRegister = "Register";

//paypal payment
  static String labelPayPaypal = "Paypal Payment";
  static String packageName = "com.cognitaigpt.app";
  static String methodChannel = 'com.cognitaigpt.app/app_retain';

/*
const kTextDavinci3 = 'text-davinci-003';
const kTextDavinci2 = 'text-davinci-002';
const kCodeDavinci2 = 'code-davinci-002';
const kChatGptTurboModel = 'gpt-3.5-turbo'; // gpt 3.5
const kChatGptTurbo0301Model = 'gpt-3.5-turbo-0301';
 */

  static List<dynamic> objectModels = [
    {"title": "gpt-4", "code": "kChatGpt4", "source": kChatGpt4},
    {"title": "gpt-4-0314", "code": "kChatGpt40314", "source": kChatGpt40314},
    {"title": "gpt-4-32k", "code": "kChatGpt432k", "source": kChatGpt432k},
    {
      "title": "gpt-4-32k-0314",
      "code": "kChatGpt432k0314",
      "source": kChatGpt432k0314
    },
    {
      "title": "gpt-3.5-turbo-0301",
      "code": "kChatGptTurbo0301Model",
      "source": kChatGptTurbo0301Model
    },
    {
      "title": "gpt-3.5-turbo",
      "code": "kChatGptTurboModel",
      "source": kChatGptTurboModel
    },
    {
      "title": "text-davinci-003",
      "code": "kTextDavinci3",
      "source": kTextDavinci3
    },
    {
      "title": "text-davinci-002",
      "code": "kTextDavinci2",
      "source": kTextDavinci2
    },
    {
      "title": "code-davinci-002",
      "code": "kCodeDavinci2",
      "source": kCodeDavinci2
    }
  ];

  static String dummyProfilePic =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ6TaCLCqU4K0ieF27ayjl51NmitWaJAh_X0r1rLX4gMvOe0MDaYw&s';

  static String bannerImage = 'https://erhacorp.id/banner_profile.png';

  static int maxLengthDescription = 280;

  static List<String> dummyProfilePicList = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ6TaCLCqU4K0ieF27ayjl51NmitWaJAh_X0r1rLX4gMvOe0MDaYw&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFDjXj1F8Ix-rRFgY_r3GerDoQwfiOMXVt-tZdv_Mcou_yIlUC&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRzDG366qY7vXN2yng09wb517WTWqp-oua-mMsAoCadtncPybfQ&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTq7BgpG1CwOveQ_gEFgOJASWjgzHAgVfyozkIXk67LzN1jnj9I&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRPxjRIYT8pG0zgzKTilbko-MOv8pSnmO63M9FkOvfHoR9FvInm&s',
    'https://cdn5.f-cdn.com/contestentries/753244/11441006/57c152cc68857_thumb900.jpg',
    'https://cdn6.f-cdn.com/contestentries/753244/20994643/57c189b564237_thumb900.jpg'
  ];

  static String findModelChatByTitle(final title) {
    final model = objectModels
        .firstWhere((element) => element['title'].toString() == title);

    return model['code'].toString();
  }

  static List<dynamic> iconTops = [
    {
      "title": "Text",
      "icon":
          Icon(BootstrapIcons.fonts, size: 24, color: Get.theme.primaryColor)
    },
    {
      "title": "Image",
      "icon":
          Icon(BootstrapIcons.image, size: 20, color: Get.theme.primaryColor)
    },
    {
      "title": "Voice",
      "icon": Icon(BootstrapIcons.mic, size: 20, color: Get.theme.primaryColor)
    },
    {
      "title": "Scan",
      "icon":
          Icon(BootstrapIcons.camera, size: 20, color: Get.theme.primaryColor)
    }
  ];

  static List<dynamic> iconPaysIOS = [
    {
      "title": "ApplePay",
      "asset": "assets/applepay_001.png",
    },
    {
      "title": "Paypal",
      "asset": "assets/paypal_001.png",
    },
  ];

  static List<dynamic> iconPaysAndroid = [
    {
      "title": "GooglePay",
      "asset": "assets/googlepay_001.png",
    },
    {
      "title": "Paypal",
      "asset": "assets/paypal_001.png",
    },
  ];

  static List<Color> colors = [
    Colors.deepOrangeAccent,
    Colors.brown,
    Colors.green,
  ];

  static String pageLimit = "0,100";

  static String dummyAnswer =
      'Flutter is a free, open-source mobile app development framework created by Google. It uses the Dart programming language and provides a way to build natively compiled applications for mobile, web, and desktop from a single codebase. It allows developers to create high-performance, visually attractive, and fast-loading mobile applications for both Android and iOS platforms.';
}

// login auth screens
// Colors
const Color kBlue = Color(0xFF306EFF);
const Color kLightBlue = Color(0xFF4985FD);
const Color kDarkBlue = Color(0xFF1046B3);
const Color kWhite = Color(0xFFFFFFFF);
const Color kGrey = Color(0xFFF4F5F7);
const Color kBlack = Color(0xFF2D3243);

// Padding
const double kPaddingS = 8.0;
const double kPaddingM = 16.0;
const double kPaddingL = 32.0;
const double kPaddingXL = 49.0;

// Spacing
const double kSpaceS = 8.0;
const double kSpaceM = 16.0;
const double kSpace14 = 14.0;

// Animation
const Duration kButtonAnimationDuration = Duration(milliseconds: 600);
const Duration kCardAnimationDuration = Duration(milliseconds: 400);
const Duration kRippleAnimationDuration = Duration(milliseconds: 400);
const Duration kLoginAnimationDuration = Duration(milliseconds: 1500);

// Assets
const String kGoogleLogoPath = 'assets/google_logo.png';
