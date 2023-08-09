import 'package:get/get.dart';

class AllProvider extends GetConnect {
  static String urlBase = "https://cognitai.site/";
  //static String urlBase = "https://xchatbot.erhacorp.id/";
  static String tokenAPI = 'a7391377c88ca6d43d9c51a166e0d317';

  Future<Response>? pushResponse(final String path, final String encoded) =>
      post(
        urlBase + path,
        encoded,
        contentType: 'application/json; charset=utf-8',
        headers: {
          'Connection': 'keep-alive',
          'User-Agent':
              'Mozilla/5.0 (Android; Mobile; rv:13.0) Gecko/13.0 Firefox/13.0',
          //  GetPlatform.isAndroid?  'Dalvik/2.1.0 (Linux; U; Android 5.1.1; Android SDK built for x86 Build/LMY48X)' : 'CFNetwork/897.15 Darwin/17.5.0 (iPhone/6s iOS/11.3)',
          'Accept-Charset': 'utf-8',
          'x-api-key': tokenAPI,
          'Content-type': 'application/json',
        },
      ).timeout(const Duration(seconds: 1200));
}
