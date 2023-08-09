import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:app/helpers/ads_helper.dart';
import 'package:app/helpers/app_controller.dart';
import 'package:app/helpers/constants.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:app/helpers/utility.dart';

class WebviewPage extends StatefulWidget {
  final String url;
  final String? title;

  const WebviewPage(this.url, this.title, {Key? key}) : super(key: key);

  @override
  WebviewPageState createState() => WebviewPageState();
}

class WebviewPageState extends State<WebviewPage> {
  late final WebViewController _controller;
  bool isLoading = false;
  String getUrl = '';
  final AppController x = AppController.to;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    try {
      if (adsHelper.bannerAd != null) {
        Future.delayed(const Duration(seconds: 5), () {
          adsHelper.bannerAd!.load();
        });
      } else {
        adsHelper.init();
      }
    } catch (_) {}

    if (!mounted) return;

    debugPrint("webiew get page url ${widget.url}");

    setState(() {
      isLoading = true;
      getUrl = widget.url;
    });

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            //progressVal.value = progress;
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
              getUrl = url;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
              getUrl = url;
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/') ||
                request.url.startsWith('https://youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  final GlobalKey _scaffoldkey = GlobalKey();
  final AdsHelper adsHelper = AdsHelper.instance;

  @override
  Widget build(BuildContext context) {
    Container? adContainer;

    try {
      if (adsHelper.bannerAd != null) {
        adContainer = Container(
          alignment: Alignment.center,
          width: adsHelper.bannerAd!.size.width.toDouble(),
          height: adsHelper.bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: adsHelper.bannerAd!),
        );
      }
    } catch (_) {}

    return Container(
      width: Get.width,
      height: Get.height,
      color: Colors.white,
      child: Scaffold(
        key: _scaffoldkey,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              topHeader(),
              const SizedBox(height: 0),
              Flexible(
                child: Stack(
                  children: <Widget>[
                    SizedBox(
                      height: Get.height,
                      width: Get.width,
                      child: WebViewWidget(controller: _controller),
                    ),
                    isLoading
                        ? SizedBox(
                            height: Get.height,
                            width: Get.width,
                            child: Center(
                              child: Utility.loading2,
                            ),
                          )
                        : SingleChildScrollView(
                            child: Container(),
                          ),
                    if (adContainer != null)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: SizedBox(
                          width: Get.width,
                          child: adContainer,
                        ),
                      ),
                  ],
                ),
              ),
            ],
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
                    Text("Information",
                        style: Get.theme.textTheme.labelMedium!
                            .copyWith(color: Colors.grey[500])),
                    Text(widget.title ?? Constants.labelSetting,
                        style: Get.theme.textTheme.titleLarge),
                    const SizedBox(height: 5),
                  ],
                ),
              ],
            ),
            Icon(BootstrapIcons.globe, color: Get.theme.primaryColor, size: 30)
          ],
        ),
      ),
    );
  }
}
