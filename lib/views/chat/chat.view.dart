import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../models/Message.dart';
import '../../service/open_ai.service.dart';
import '../../utils/constants.dart';

class ChatView extends StatefulWidget {
  static String routeName = 'chat';
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController messageController = TextEditingController();
  final SpeechToText speechToText = SpeechToText();
  final OpenAIService openAiService = OpenAIService();
  List<Message> messages = [];
  FlutterTts flutterTts = FlutterTts();
  String currentSpeech = '';
  bool isListening = false;
  bool isProcessingMessage = false;
  bool isSpeaking = false;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
    isSpeaking = false;
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {
      isListening = true;
    });
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {
      isListening = false;
    });
  }

  void onSpeechResult(SpeechRecognitionResult result) async {
    final recognizedWords = result.recognizedWords;
    print(recognizedWords);

    setState(() {
      currentSpeech = recognizedWords;
    });

    if (!speechToText.isListening) {
      final userMessage = Message(
        text: currentSpeech,
        isUser: true,
        isImage: false,
      );
      setState(() {
        messages.add(userMessage);
        isProcessingMessage = true;
      });

      final response = await openAiService.isArtPromptAPI(currentSpeech);

      final botMessage = Message(
        text: response,
        isUser: false,
        isImage: response.contains('https://oaidalleapiprodscus.blob.core.windows.net'),
      );
      setState(() {
        messages.add(botMessage);
        isProcessingMessage = false;
      });

      setState(() {
        currentSpeech = '';
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kTertiaryColor,
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Visibility(
                      visible: messages.isNotEmpty,
                      child: FadeInUp(
                        delay: Duration(milliseconds: 100),
                        child: Column(
                          children: messages.map((message) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Align(
                                alignment:
                                message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                                child: message.isImage
                                    ? SizedBox(
                                  width: screenWidth * 0.8,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.network(
                                          message.text,
                                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            } else {
                                              return Center(
                                                child: LoadingAnimationWidget.threeArchedCircle(
                                                    color: Colors.blueAccent,
                                                    size: 50
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                  ,
                                )
                                    : Stack(
                                  children: [
                                    Container(
                                      width: screenWidth * 0.8,
                                      padding: EdgeInsets.only(left: screenWidth * 0.02, right: screenWidth * 0.02, top: screenWidth * 0.02, bottom: screenWidth * 0.04),
                                      decoration: BoxDecoration(
                                        color: message.isUser
                                            ? Colors.blueAccent.shade200
                                            : Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(15),
                                          topRight: const Radius.circular(15),
                                          bottomLeft: message.isUser
                                              ? const Radius.circular(15)
                                              : const Radius.circular(0),
                                          bottomRight: message.isUser
                                              ? const Radius.circular(0)
                                              : const Radius.circular(15),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: message.isUser
                                                ? Colors.white
                                                : Colors.blueAccent.shade100,
                                            blurRadius: 5,
                                          ),
                                        ],
                                        border: Border.all(
                                          color: message.isUser
                                              ? Colors.blueAccent
                                              : Colors.blue.withOpacity(0.2),
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Text(
                                        message.text,
                                        style: TextStyle(
                                          color: message.isUser ? Colors.white : Colors.black,
                                          fontSize: 15,
                                          fontFamily: 'Cera-Pro',
                                        ),
                                      ),
                                    ),
                                    if (!message.isUser)
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: IconButton(
                                          onPressed: () async {
                                            setState(() {
                                              isSpeaking = !isSpeaking;
                                            });
                                            if (isSpeaking) {
                                              await flutterTts.stop();
                                            } else {
                                              await systemSpeak(message.text);
                                            }
                                          },
                                          icon: Icon(
                                            isSpeaking ? Icons.volume_up : Icons.volume_off, size: 20,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5,),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  width: screenWidth * 0.94,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.only(left: 10, right: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 6,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextField(
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            cursorColor: Colors.blueAccent,
                            controller: messageController,
                            decoration: const InputDecoration(
                              hintText: "Envie sua mensagem...",
                              border: InputBorder.none,
                            ),
                            maxLines: null,
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: () async {
                            final userMessageText = messageController.text;
                            messageController.clear();
                            if (userMessageText.isNotEmpty) {
                              final userMessage = Message(
                                text: userMessageText,
                                isUser: true,
                                isImage: false,
                              );
                              setState(() {
                                messages.add(userMessage);
                                isProcessingMessage = true;
                              });
                              final response = await openAiService.isArtPromptAPI(userMessageText);
                              final botMessage = Message(
                                text: response,
                                isUser: false,
                                isImage: response.contains(
                                  'https://oaidalleapiprodscus.blob.core.windows.net',
                                ),
                              );
                              setState(() {
                                messages.add(botMessage);
                                isProcessingMessage = false;
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}