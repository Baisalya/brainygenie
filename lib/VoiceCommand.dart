import 'package:brainygenie/Const/api_services.dart';
import 'package:flutter/material.dart';

import 'package:speech_to_text/speech_to_text.dart';
import 'package:avatar_glow/avatar_glow.dart';



enum ChatType { user, bot }

class ChatMessage {
  final String text;
  final ChatType type;

  const ChatMessage({required this.text, required this.type});
}

class VoiceCommand extends StatefulWidget {
  const VoiceCommand({Key? key}) : super(key: key);

  @override
  _VoiceCommandState createState() => _VoiceCommandState();
}

class _VoiceCommandState extends State<VoiceCommand> {
  final List<ChatMessage> messages = [];
  SpeechToText speechToText = SpeechToText();
  var Qry = "Hold the mic to ask Questions";
  bool ispress = false;
  var scrollController = ScrollController();

  void scrollMethod() {
    scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut);
  }

  @override
  void initState() {
    super.initState();
    // Initialize the speech to text plugin
    speechToText.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 65, top: 20),
              child: FloatingActionButton(
                child: Icon(Icons.textsms),
                onPressed: () {
                  //...
                },
                heroTag: null,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            /*** Voice question button ****/
            AvatarGlow(
              endRadius: 70.0,
              animate: ispress,
              duration: Duration(milliseconds: 3000),
              glowColor: Colors.blueGrey,
              repeatPauseDuration: Duration(microseconds: 100),
              showTwoGlows: true,
              child: FloatingActionButton(
                child: AvatarGlow(
                  endRadius: 20.0,
                  animate: ispress,
                  duration: Duration(milliseconds: 3000),
                  glowColor: Colors.blueGrey,
                  repeatPauseDuration: Duration(microseconds: 100),
                  showTwoGlows: true,
                  child: GestureDetector(
                    onTapDown: (details) async {
                      if (!ispress) {
                        var available = await speechToText.initialize();
                        if (available) {
                          setState(() {
                            ispress = true;
                          });
                          speechToText.listen(
                              onResult: ((result) {
                                setState(() {
                                  Qry = result.recognizedWords;
                                });
                              }));
                        } else {
                          setState(() {
                            Qry = "Speech to text not available";
                          });
                        }
                      }
                    },
                    onTapUp: (details) async {
                      setState(() {
                        ispress = false;
                      });
                      speechToText.stop();
                      messages.add(ChatMessage(text: Qry, type: ChatType.user));
                      var msg = await ApiServices.sendMessage(Qry);
                      setState(() {
                        messages.add(ChatMessage(text: msg, type: ChatType.bot));
                      });
                    },
                    child: Icon(ispress ? Icons.mic : Icons.mic_none_rounded),
                  ),

                ),
                onPressed: () => () {},
                heroTag: null,
              ),
            )
          ],
        ),
        /** App Bar**/
        appBar: AppBar(
        leading: Icon(Icons.sort),
    centerTitle: true,
    title: const Text(
    "Ask Your Question",
      style: TextStyle(
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
          color: Colors.white),
    ),
        ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 18),
        child: Column(
          children: [
            Text(
              Qry,
              style: TextStyle(
                  color: ispress ? Colors.black26 : Colors.blueAccent,
                  fontWeight: FontWeight.w200,
                  fontSize: 25),
            ),
            Expanded(
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  controller: scrollController,
                  shrinkWrap: true,
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return chatbubble(
                        chattext: messages[index].text,
                        type: messages[index].type);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  /*** for chat show ui **/
  Widget chatbubble({required chattext, required ChatType type}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          child: Icon(Icons.person_outline, color: Colors.white),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
            ),
            child: Text(
              "$chattext",
              style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

