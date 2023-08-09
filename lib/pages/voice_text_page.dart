// ignore_for_file: depend_on_referenced_packages

import 'dart:math';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:app/helpers/app_color.dart';
import 'package:app/helpers/app_controller.dart';
import 'package:app/helpers/constants.dart';
import 'package:app/helpers/my_pref.dart';
import 'package:app/helpers/translator_gpt.dart';
import 'package:app/helpers/utility.dart';
import 'package:app/helpers/extention.dart';
import 'package:app/models/message_stream.dart';
import 'package:app/models/speech_object.dart';
import 'package:app/services/repository/user_repository.dart';
import 'package:app/widgets/url_text/custom_url_text.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceTextPage extends StatelessWidget {
  VoiceTextPage({super.key}) {
    Future.microtask(() {
      stt.SpeechToText speech = stt.SpeechToText();
      speechObject.update((val) {
        val!.speech = speech;
      });

      debugPrint("set object speech done");
    });

    Future.microtask(() {
      final apiKeyToken = Constants.apiKeyToken;
      debugPrint(
          "voice text page constructor mainChatGPT apiKeyToken $apiKeyToken");

      final OpenAI mainChatGPT = OpenAI.instance.build(
        token: apiKeyToken,
        baseOption: HttpSetup(
            receiveTimeout: Duration(seconds: Constants.maxTimeoutStream),
            connectTimeout: Duration(seconds: Constants.maxTimeoutStream)),
        enableLog: true,
      );

      final getUser = appController.box.getUser();
      chatGPTObject.update((val) {
        val!.mainChatGPT = mainChatGPT;
        val.thisUser = getUser;
      });
    });
  }

  final AppController appController = AppController.to;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        stopObjectSpeech();
        debugPrint("close page willpopscope");
        return Future.value(true);
      },
      child: Container(
        width: Get.width,
        height: Get.height,
        color: Colors.white,
        child: Scaffold(
          floatingActionButton: Obx(
            () => FloatingActionButton(
              onPressed: () async {
                // check this user counter max
                if (chatGPTObject.value.thisUser != null) {
                  final thisUser = chatGPTObject.value.thisUser;
                  if (int.parse(thisUser['counter_max'].toString()) < 1) {
                    Utility.customSnackBar(context,
                        'This action not eligible for you anymore. Try to renewal/ update package membership plan...!');
                    return;
                  }
                }

                Get.snackbar('Information',
                    'Speak louder to recognize your question...');
                await Future.delayed(const Duration(milliseconds: 500));
                speechListening.value = true;

                await stopObjectSpeech();
                await Future.delayed(const Duration(milliseconds: 500));
                await startListening();
              },
              backgroundColor: !speechListening.value
                  ? Get.theme.primaryColor
                  : Get.theme.primaryColor.withOpacity(.5),
              child: !speechListening.value
                  ? const Icon(BootstrapIcons.mic)
                  : Image.asset('assets/mic-listening-transp.gif',
                      width: Get.width / 3),
            ),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      topHeader(),
                      const SizedBox(height: 20),
                      Flexible(
                        child: Obx(
                          () => inputText.value == ''
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 10),
                                      Text(
                                        "${Constants.appName} Speech Recognition To Text",
                                        textAlign: TextAlign.center,
                                        style:
                                            Get.theme.textTheme.headlineSmall,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                          "Click on Mic, and try to say something of your quesiton, to get smart, genius answer from Bot, using ChatBot WithAI",
                                          textAlign: TextAlign.center,
                                          style: Get
                                              .theme.textTheme.titleMedium!
                                              .copyWith(
                                                  color: AppColor.greyLabel2)),
                                    ],
                                  ))
                              : Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: chatGPTObject.value.mainChatGPT == null
                                      ? const SizedBox()
                                      : createStreamBuilder(inputText.value,
                                          chatGPTObject.value.mainChatGPT!),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final speechObject = SpeechObject().obs;
  startListening() async {
    final speech = speechObject.value.speech;
    if (speech == null) return;

    bool available = await speech.initialize(onStatus: (status) {
      debugPrint("startListening Status ${status.toString()}");
      if (status.toString() == 'done') {
        //speech.cancel();
        //speechListening.value = false;
      }
    }, onError: (error) {
      debugPrint("startListening Error ${error.toString()}");
    });

    debugPrint("startListening available $available");

    if (available) {
      speech.listen(onResult: (final SpeechRecognitionResult result) async {
        String res = result.recognizedWords.trim();
        debugPrint("get words $res");

        if (result.finalResult) {
          final String getText = result.recognizedWords.trim();
          speechObject.update((val) {
            val!.result = getText;
          });

          speechListening.value = false;
          //await Future.delayed(const Duration(milliseconds: 1200));
          submitMessage();
          await stopObjectSpeech();
        }
      });
    } else {
      debugPrint("The user has denied the use of speech recognition.");
    }
    // some time later...
    //speech.stop()
  }

  final UserRepository userRepository = UserRepository();
  final speechListening = false.obs;
  submitMessage() {
    final String getText = speechObject.value.result!;
    if (getText == '') return;

    // check this user counter max
    int getMax = 0;
    final getUser = appController.box.getUser();
    if (getUser != null) {
      final thisUser = getUser;
      chatGPTObject.update((val) {
        val!.thisUser = getUser;
      });

      getMax = int.parse(thisUser['counter_max'].toString());
      if (getMax < 1) {
        Utility.customSnackBar(Get.context!,
            'This action not eligible for you anymore. Try to renewal/ update package membership plan...!');
        return;
      }
    }

    Future.microtask(() => userRepository
        .updateCounter({"max": "${getMax - 1}"})!.then(
            (value) => appController.getUserAsync()));

    final MessageStream msg = MessageStream("${Random().nextInt(100) + 1000}",
        getText, DateTime.now().toUtc().toString(), true);
    responseBot.add(msg);
    generateListMessage(responseBot, true);

    Future.delayed(const Duration(seconds: 2), () {
      scrollToIndex();
    });

    Future.microtask(() => inputText.value = getText);
  }

  final inputText = ''.obs;
  final responseBot = <MessageStream>[].obs;
  final chatGPTObject = ChatGPTObject().obs;
  final MyPref myPref = MyPref.to;

  Widget createStreamBuilder(final String input, final OpenAI mainChatGPT) {
    debugPrint("voice text page createStreamBuilder input $input");
    final String modelChat = myPref.pModelChat.val;
    final int maxToken = myPref.pMaxToken.val;
    final String promptData =
        TranslatorGPT.translateFromModel(input.trim(), myPref);

    if (modelChat == kChatGptTurboModel ||
        modelChat == kChatGptTurbo0301Model ||
        modelChat == kChatGpt4 ||
        modelChat == kChatGpt40314 ||
        modelChat == kChatGpt432k ||
        modelChat == kChatGpt432k0314) {
      var request = ChatCompleteText(
          messages: [Messages(role: Role.user, content: promptData)],
          maxToken: maxToken,
          model: GptTurbo0301ChatModel());

      if (modelChat == kChatGpt4 ||
          modelChat == kChatGpt40314 ||
          modelChat == kChatGpt432k ||
          modelChat == kChatGpt432k0314) {
        request = ChatCompleteText(
            messages: [Messages(role: Role.user, content: promptData)],
            maxToken: maxToken,
            model: Gpt4ChatModel());
      }

      var streamWithAIChatTurbo =
          mainChatGPT.onChatCompletion(request: request).asStream();
      return streamChatCTResponse(streamWithAIChatTurbo);
    } else {
      var streamWithAI = mainChatGPT
          .onCompletion(
            request: CompleteText(
                prompt: promptData,
                model: TextDavinci3Model(),
                maxTokens: maxToken),
          )
          .asStream();
      return streamCTResponse(streamWithAI);
    }
  }

  streamChatCTResponse(final Stream<ChatCTResponse?> streamWithAITurbo) {
    return StreamBuilder<ChatCTResponse?>(
      stream: streamWithAITurbo,
      //builder screen
      builder: (context, AsyncSnapshot<ChatCTResponse?> snapshot) {
        if (snapshot.hasError) {
          debugPrint("snapshot. hasError... ");
          final MessageStream msg = MessageStream(
              "99",
              "No response, try another question Error ${snapshot.error.toString()}",
              DateTime.now().toUtc().toString(),
              false);
          responseBot.add(msg);
          return Obx(() => generateListMessage(responseBot, true));
        }

        if (!snapshot.hasData) {
          debugPrint("snapshot. no data... ");

          return Column(
            children: [
              Flexible(
                  child: Obx(() => generateListMessage(responseBot, true))),
              Utility.loading,
              const SizedBox(height: 50),
            ],
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          debugPrint("snapshot.connectionState waiting... ");
          return Column(
            children: [
              Flexible(
                  child: Obx(() => generateListMessage(responseBot, true))),
              Utility.loading,
              const SizedBox(height: 50),
            ],
          );
        }

        final ChatCTResponse? snapshots = snapshot.requireData;
        for (var choice in snapshots!.choices) {
          if (choice.message != null) {
            debugPrint(
                "found text index ${choice.index} answer ${choice.message!.content}");
            final String getText = choice.message!.content.trim();
            if (getText.isEmpty) {
              final MessageStream msg = MessageStream(
                  "97",
                  "No response, try another question Error ${snapshot.error.toString()}",
                  DateTime.now().toUtc().toString(),
                  false);
              responseBot.add(msg);
              return Obx(
                () => generateListMessage(responseBot, true),
              );
            }

            final MessageStream msg = MessageStream("${choice.index}", getText,
                DateTime.now().toUtc().toString(), false);

            bool isExist = false;
            try {
              final List<MessageStream> lastList = responseBot;
              isExist = lastList.any((MessageStream element) =>
                  element.message.toString().trim() == getText);
            } catch (_) {}

            if (!isExist) {
              responseBot.add(msg);
            }
          }
        }

        return Obx(() => generateListMessage(responseBot, false));
      },
    );
  }

  streamCTResponse(final Stream<CompleteResponse?> streamWithAI) {
    return StreamBuilder<CompleteResponse?>(
      stream: streamWithAI,
      //builder screen
      builder: (context, AsyncSnapshot<CompleteResponse?> snapshot) {
        if (snapshot.hasError) {
          debugPrint("snapshot. hasError... ");
          final MessageStream msg = MessageStream(
              "99",
              "No response, try another question Error ${snapshot.error.toString()}",
              DateTime.now().toUtc().toString(),
              false);
          responseBot.add(msg);
          return Obx(() => generateListMessage(responseBot, true));
        }

        if (!snapshot.hasData) {
          debugPrint("snapshot. no data... ");

          return Column(
            children: [
              Flexible(
                  child: Obx(() => generateListMessage(responseBot, true))),
              Utility.loading,
              const SizedBox(height: 50),
            ],
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          debugPrint("snapshot.connectionState waiting... ");
          return Column(
            children: [
              Flexible(
                  child: Obx(() => generateListMessage(responseBot, true))),
              Utility.loading,
              const SizedBox(height: 50),
            ],
          );
        }

        final CompleteResponse? snapshots = snapshot.requireData;
        for (var choice in snapshots!.choices) {
          debugPrint("found text index ${choice.index} answer ${choice.text}");
          final String getText = choice.text.trim();
          if (getText.isEmpty) {
            final MessageStream msg = MessageStream(
                "97",
                "No response, try another question Error ${snapshot.error.toString()}",
                DateTime.now().toUtc().toString(),
                false);
            responseBot.add(msg);
            return Obx(
              () => generateListMessage(responseBot, true),
            );
          }

          final MessageStream msg = MessageStream("${choice.index}", getText,
              DateTime.now().toUtc().toString(), false);

          bool isExist = false;
          try {
            final List<MessageStream> lastList = responseBot;
            isExist = lastList.any((MessageStream element) =>
                element.message.toString().trim() == getText);
          } catch (_) {}

          if (!isExist) {
            responseBot.add(msg);
          }
        }

        return Obx(() => generateListMessage(responseBot, false));
      },
    );
  }

  final ScrollController _controller = ScrollController();
  generateListMessage(final List<MessageStream> temps, final bool isLoading) {
    final List<MessageStream> lists = temps.reversed.toList();
    scrollToIndex();

    return lists.isEmpty
        ? const SizedBox()
        : ListView.builder(
            controller: _controller,
            shrinkWrap: true,
            reverse: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(0),
            itemCount: lists.length,
            itemBuilder: (context, index) {
              final message = lists[index];

              debugPrint("isLoading $isLoading");

              return InkWell(
                onTap: () {
                  Utility.copyToClipBoard(
                      context: context,
                      text: message.message ?? '',
                      message: 'Copied!');
                },
                onLongPress: () {
                  Utility.share(message.message ?? '',
                      subject: '${Constants.appName} Share');
                },
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.only(
                      top: index >= lists.length - 1 ? 5 : 0,
                      bottom: isLoading
                          ? 0
                          : index == 0
                              ? 50
                              : 0),
                  child: messageWidget(
                      message.message!, message.isMine!, message.createdAt),
                ),
              );
            },
          );
  }

  scrollToIndex() async {
    try {
      Future.delayed(const Duration(milliseconds: 1500), () {
        debugPrint("chat_screen_page scrollToIndex running");

        if (_controller.hasClients) {
          //final position = _controller.position.maxScrollExtent;

          _controller.animateTo(
            0.0,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
        }
      });
    } catch (e) {
      debugPrint("chat_screen_page [Error] ${e.toString()}");
    }
  }

  Widget messageWidget(
      final String response, final bool myQuestion, final String? createdAt) {
    return _message(response, myQuestion, createdAt);
  }

  Widget _message(
      final String text, final bool isMine, final String? createdAt) {
    return Column(
      crossAxisAlignment:
          isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisAlignment:
          isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            const SizedBox(width: 15),
            isMine ? const SizedBox() : Utility.appIcon(6),
            Expanded(
              child: Container(
                alignment:
                    isMine ? Alignment.centerRight : Alignment.centerLeft,
                margin: EdgeInsets.only(
                  right: isMine ? 10 : (Get.width / 4),
                  top: 8,
                  left: isMine ? (Get.width / 4) : 10,
                ),
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: getBorder(isMine),
                        color: isMine
                            ? Get.theme.primaryColor
                            : AppColor.greyLight,
                      ),
                      child: UrlText(
                        text: text.removeSpaces,
                        onHashTagPressed: (tag) {
                          debugPrint("get hashtag $tag");

                          if (tag != '') {
                            //context.gotoPage(HashTagMentionPage(hashTag: tag));
                          }
                        },
                        style: TextStyle(
                          color: isMine ? Colors.white : Colors.black87,
                          height: isMine ? 1 : 1.5,
                        ),
                        urlStyle: const TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
            right: 10,
            left: isMine ? 15 : 30,
            top: isMine ? 5 : 10,
          ),
          child: Text(
            Utility.getChatTime(createdAt),
            style: Get.textTheme.bodySmall!.copyWith(fontSize: 12),
          ),
        )
      ],
    );
  }

  BorderRadius getBorder(bool myMessage) {
    return BorderRadius.only(
      topLeft: const Radius.circular(20),
      topRight: const Radius.circular(20),
      bottomRight:
          myMessage ? const Radius.circular(0) : const Radius.circular(20),
      bottomLeft:
          myMessage ? const Radius.circular(20) : const Radius.circular(0),
    );
  }

  stopObjectSpeech() async {
    if (speechObject.value.speech != null) {
      await speechObject.value.speech!.stop();
    }
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
                        stopObjectSpeech();
                        debugPrint("get back topHeader");
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
                    Text(
                      "Text Based (Model : ${Constants.findModelChatByTitle(MyPref.to.pModelChat.val)})",
                      overflow: TextOverflow.ellipsis,
                      style: Get.theme.textTheme.labelMedium!
                          .copyWith(color: Colors.grey[500], fontSize: 11),
                    ),
                    Text(Constants.speechToText,
                        style: Get.theme.textTheme.titleLarge),
                  ],
                ),
              ],
            ),
            createIconRight(Constants.iconTops[2], 11),
          ],
        ),
      ),
    );
  }

  Widget createIconRight(final dynamic e, final double padding) {
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
            child: e['icon'],
          ),
          const SizedBox(height: 2),
          Text(
            "${e['title']}",
            style: Get.theme.textTheme.labelMedium,
          ),
          const SizedBox(height: 2),
        ],
      ),
    );
  }
}
