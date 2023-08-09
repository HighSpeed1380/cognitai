import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:encrypt/encrypt.dart' as encyrpt;
import 'package:app/widgets/ball_loading/ball_bounce_loading.dart';
import 'package:app/widgets/ball_loading/ball.dart';

class Utility {
  static String basename(String path) {
    return path.split('/').last;
  }

  static String getChatTime(String? date) {
    if (date == null || date.isEmpty) {
      return '';
    }
    String msg = '';
    var dt = DateTime.parse(date).toLocal();

    if (DateTime.now().toLocal().isBefore(dt)) {
      return DateFormat.jm().format(DateTime.parse(date).toLocal()).toString();
    }

    var dur = DateTime.now().toLocal().difference(dt);
    if (dur.inDays > 365) {
      msg = DateFormat.yMMMd().format(dt);
    } else if (dur.inDays > 30) {
      msg = DateFormat.yMMMd().format(dt);
    } else if (dur.inDays > 0) {
      msg = '${dur.inDays} d';
      return dur.inDays == 1 ? '1d' : DateFormat.MMMd().format(dt);
    } else if (dur.inHours > 0) {
      msg = '${dur.inHours} h';
    } else if (dur.inMinutes > 0) {
      msg = '${dur.inMinutes} m';
    } else if (dur.inSeconds > 0) {
      msg = '${dur.inSeconds} s';
    } else {
      msg = 'now';
    }
    return msg;
  }

  static String? getSocialLinks(String? url) {
    if (url != null && url.isNotEmpty) {
      url = url.contains("https://www") || url.contains("http://www")
          ? url
          : url.contains("www") &&
                  (!url.contains('https') && !url.contains('http'))
              ? 'https://$url'
              : 'https://www.$url';
    } else {
      return null;
    }
    debugPrint('Launching URL : $url');
    return url;
  }

  static void share(String message, {String? subject}) {
    if (message.isNotEmpty) {
      Share.share(message, subject: subject);
    }
  }

  static launchURLNew(String url) async {
    if (url == "") {
      return;
    }

    debugPrint("launchURL url $url");
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      debugPrint('Could not launch $url');
    }
  }

  static appIcon(final double padding) {
    return Container(
      margin: const EdgeInsets.only(right: 0),
      padding: EdgeInsets.all(padding),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Get.theme.primaryColor.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(2, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            child: Image.asset('assets/chatbot-waving4.gif', width: 30),
          ),
        ],
      ),
    );
  }

  static String getCreditRemaining(final dynamic getUserLoggedIn) {
    String textMax = "0";
    int getUserMax = 0;
    if (getUserLoggedIn['counter_max'] != null) {
      getUserMax = int.parse(getUserLoggedIn['counter_max'].toString());
      textMax = getUserMax.toString();

      if (getUserMax > 999) {
        double gm = getUserMax / 1000;
        int gMax = gm.toInt();
        textMax = "${gMax}K";
      }
    }

    return textMax;
  }

  static void copyToClipBoard({
    required BuildContext context,
    required String text,
    required String message,
  }) {
    var data = ClipboardData(text: text);
    Clipboard.setData(data);
    customSnackBar(context, message);
  }

  static customSnackBar(BuildContext context, String msg,
      {double height = 30, Color backgroundColor = Colors.black}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final snackBar = SnackBar(
      backgroundColor: backgroundColor,
      content: Text(
        msg,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static get loading => SizedBox(
        height: 60,
        width: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BallBounceLoading(
              duration: const Duration(seconds: 2),
              ballStyle: BallStyle(
                size: 8,
                color: Get.theme.primaryColor,
              ),
            ),
          ],
        ),
      );

  static get loading2 => SizedBox(
        height: 60,
        width: 180,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BallBounceLoading(
              duration: const Duration(seconds: 4),
              ballStyle: BallStyle(
                size: 15,
                color: Get.theme.primaryColor,
              ),
            ),
          ],
        ),
      );

  /// ecnrypted - decrypted
  /// usage String encoded = Utility.checkEncryptDecrypt('1234567890');
  /// String decoded = Utility.checkDecrypt(encoded);
  /// debugPrint("Check Decode Decrypted $decoded");

  static checkEncryptDecrypt(final String source) {
    String plainText = source;
    //'test password';
    /*final encyrpt.Key key =
        encyrpt.Key.fromUtf8('12345678901234567890123456789012');
    final iv = encyrpt.IV.fromLength(16);*/

    final encrypter = encyrpt.Encrypter(encyrpt.AES(key));

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);

    debugPrint(decrypted);
    // Lorem ipsum dolor sit amet, consectetur adipiscing elit
    //print(encrypted.base64);
    debugPrint(encrypted.base16); //.toString());

    return encrypted.base16;
  }

  static final encyrpt.Key key =
      encyrpt.Key.fromUtf8('12345678901234567890123456789012');
  static final iv = encyrpt.IV.fromLength(16);

  static checkDecrypt(final String encoded) {
    final encrypter = encyrpt.Encrypter(encyrpt.AES(key));

    final String decrypted =
        encrypter.decrypt(encyrpt.Encrypted.fromBase16(encoded), iv: iv);

    debugPrint(
        decrypted); // Lorem ipsum dolor sit amet, consectetur adipiscing elit

    return decrypted;
  }
}
