import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:app/helpers/my_pref.dart';

class TranslatorGPT {
  String? defLang;
  List<dynamic> availableLangs = [
    {
      "title": "Default",
      "desc": "No Translator",
    },
    {
      "title": "INDONESIA",
      "desc": "To Indonesia",
    },
    {
      "title": "ENG-THAI",
      "desc": "English To Thailand",
    },
    {
      "title": "THAI-ENG",
      "desc": "Thailand To English",
    },
    {
      "title": "JAPANESE",
      "desc": "To Japanese",
    },
    {
      "title": "VIETNAMESE",
      "desc": "To Vietnamese",
    },
    {
      "title": "MALAY",
      "desc": "To Malay",
    },
    {
      "title": "TAGALOG",
      "desc": "To Tagalog",
    },
    {
      "title": "SPANISH",
      "desc": "To Spanish",
    },
  ];

  dynamic findDescByTitle(final String title) => availableLangs
      .firstWhere((element) => element['title'].toString() == title);

  // add more translator model languages
  static String translateToIndonesia({required String word}) =>
      "Translate this into Indonesia : $word";
  static String translateToVietname({required String word}) =>
      "Translate this into Vietnamese : $word";
  static String translateToMelayu({required String word}) =>
      "Translate this into Malay : $word";
  static String translateToTagalog({required String word}) =>
      "Translate this into Tagalog : $word";
  static String translateToSpanish({required String word}) =>
      "Translate this into Spanish : $word";
  // add more translator model languages

  static String translateFromModel(final String input, final MyPref myPref) {
    String promptData = input.trim();
    if (myPref.pTranslator.val == 'ENG-THAI') {
      promptData = translateEngToThai(word: input.trim());
    } else if (myPref.pTranslator.val == 'THAI-ENG') {
      promptData = translateThaiToEng(word: input.trim());
    } else if (myPref.pTranslator.val == 'JAPANESE') {
      promptData = translateToJapanese(word: input.trim());
    } else if (myPref.pTranslator.val == 'INDONESIA') {
      promptData = translateToIndonesia(word: input.trim());
    } else if (myPref.pTranslator.val == 'VIETNAMESE') {
      promptData = translateToVietname(word: input.trim());
    } else if (myPref.pTranslator.val == 'MALAY') {
      promptData = translateToMelayu(word: input.trim());
    } else if (myPref.pTranslator.val == 'TAGALOG') {
      promptData = translateToTagalog(word: input.trim());
    } else if (myPref.pTranslator.val == 'SPANISH') {
      promptData = translateToSpanish(word: input.trim());
    }

    return promptData;
  }
}


/*
Link ref: https://pub.dev/packages/chat_gpt_sdk

translateEngToThai
translateThaiToEng
translateToJapanese
 */
