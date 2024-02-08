import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import '../colors.dart';
import '../constants.dart';


const String apiSecretKey = apiKey; // Replace with your actual API key

class ChatMessage {
  final String text;
  final ChatMessageType chatMessageType;

  ChatMessage({required this.text, required this.chatMessageType});
}

enum ChatMessageType {
  user,
  bot,
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  bool isLoading = false;
  bool isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    KeyboardVisibilityController().onChange.listen((bool visible) {
      setState(() {
        isKeyboardVisible = visible;
      });
    });

    // Generate the bot's response and add it as the initial message
    String value = "Hello!\nHow may I assist you today?";
    _addBotMessage(value);
  }

  void _addBotMessage(String message) {
    setState(() {
      var processedMessage = postProcessText(message);
      _messages.add(
        ChatMessage(
          text: processedMessage,
          chatMessageType: ChatMessageType.bot,
        ),
      );
      Future.delayed(const Duration(milliseconds: 1)).then((_) {
        _scrollDown(); // Scroll to the latest message
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.only(bottom: isKeyboardVisible ? 300 : 0),
                child: _buildChatScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatScreen() {
    return Column(
      children: [
        Expanded(
          child: _buildList(),
        ),
        Visibility(
          visible: isLoading,
          child:  const Padding(
            padding: EdgeInsets.all(8.0),
            child: SpinKitThreeBounce(
              color: AppColors.colorWhiteHighEmp,
              size: 20,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              _buildInput(),
              _buildSubmit(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubmit() {
    return Visibility(
      visible: !isLoading,
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: CircleAvatar(
          backgroundColor: AppColors.colorWhiteHighEmp,
          maxRadius: 23.r,
          child: IconButton(
            padding: const EdgeInsets.only(top: 2, right: 4),
            icon: SvgPicture.asset("assets/images/send.svg"),
            onPressed: () async {
              setState(() {
                _messages.add(
                  ChatMessage(
                    text: _textController.text,
                    chatMessageType: ChatMessageType.user,
                  ),
                );
                isLoading = true;
              });

              var input = _textController.text;
              _textController.clear();

              generateResponse(input).then((value) {
                print('Generated response: $value');
                setState(() {
                  isLoading = false;
                  _messages.add(
                    ChatMessage(
                      text: value,
                      chatMessageType: ChatMessageType.bot,
                    ),
                  );
                  Future.delayed(const Duration(milliseconds: 50)).then((_) {
                    _scrollDown(); // Scroll to the latest message
                  });
                });
              });

              Future.delayed(const Duration(milliseconds: 50)).then((_) {
                _scrollDown(); // Scroll to the latest message
              });
            },
          ),
        ),
      ),
    );
  }

  Expanded _buildInput() {
    return Expanded(
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        style: const TextStyle(color: AppColors.colorBlackHighEmp),
        controller: _textController,
        decoration: InputDecoration(
          fillColor: AppColors.colorWhiteHighEmp,
          filled: true,
          hintText: "Type here",
          contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          hintStyle: const TextStyle(color: AppColors.colorBlackLowEmp),
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _messages.length,
      reverse: false, // Changed from true to false
      itemBuilder: (context, index) {
        var message = _messages[index]; // Changed to access messages directly
        return ChatMessageWidget(
          text: message.text,
          chatMessageType: message.chatMessageType,
        );
      },
    );
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<String> generateResponse(String prompt) async {
    var url = Uri.https(
      "api.openai.com",
      "/v1/chat/completions",
    );

    // Load text from file
    String fileText = await getTextFromFile();

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiSecretKey',
      },
      body: json.encode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "system", "content": "You are a personal assistant giving information about Islam. You are given some texts which are $fileText"},
          {"role": "system", "content": "If someone asks question that is not relevant to islam or any religion, give them answer relevant to Islam and Religion."},
          {"role": "system", "content": "If someone greets you, you greet them back and state your purpose as a Islamic Chat Bot."},
          {"role": "system", "content": "If someone greets you, you greet them back from the organization."},
          {"role": "system", "content": "If there is no internet connection, inform the user about it and apologize."},
          {"role": "user", "content": "Give response from texts which are given to you and only give answers to questions relevant to Islam. Now give response on  $prompt"}
        ]
      }),
    );

    print('Response body: ${response.body}');

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    if (jsonResponse.containsKey('choices')) {
      var choices = jsonResponse['choices'] as List<dynamic>;
      if (choices.isNotEmpty && choices[0].containsKey('message')) {
        var message = choices[0]['message'];
        if (message.containsKey('content')) {
          var content = message['content'] as String;
          var processedContent = postProcessText(
              content); // Apply post-processing to the bot's response
          print("Response content: $processedContent");
          return processedContent;
        }
      }
    }

    return 'Failed to generate response.';
  }

  Future<String> getTextFromFile() async {
    try {
      return await rootBundle.loadString('assets/data.txt');
    } catch (e) {
      print('Error reading file: $e');
      return '';
    }
  }



  String postProcessText(String rawText) {
    // Implement your post-processing logic here
    // This is just a basic example, you can modify it according to your needs
    // Here, we remove any leading/trailing spaces and line breaks
    var processedText = rawText.trim();
    return processedText;
  }
}

class ChatMessageWidget extends StatelessWidget {
  const ChatMessageWidget({
    Key? key,
    required this.text,
    required this.chatMessageType,
  }) : super(key: key);

  final String text;
  final ChatMessageType chatMessageType;

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 2 / 3;
    final isUserMessage = chatMessageType == ChatMessageType.user;
    final borderRadius = BorderRadius.only(
      bottomLeft: Radius.circular(isUserMessage ? 8 : 0),
      bottomRight: Radius.circular(isUserMessage ? 0 : 8),
      topLeft: const Radius.circular(8),
      topRight: const Radius.circular(8),
    );

    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(maxWidth: maxWidth),
        decoration: BoxDecoration(
          color: AppColors.colorWhiteHighEmp,
          borderRadius: borderRadius,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
}