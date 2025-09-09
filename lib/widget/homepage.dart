import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../open_ai_service.dart';


class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final OpenAIService _openAIService = OpenAIService();
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  SpeechToText _speech = SpeechToText();

  void _sendMessage() async {
    final text = _controller.text;
    if (text.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "content": text});
    });
    _controller.clear();

    final aiResponse = await _openAIService.sendMessage(text);

    setState(() {
      _messages.add({"role": "assistant", "content": aiResponse});
    });
  }

  Future<void> startListening() async {
    await _speech.initialize();
    _speech.listen(onResult: (result) {
      _controller.text = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AI Assistant")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg["role"] == "user";
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(msg["content"] ?? ""),
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0 , color: Colors.black),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextField(
                      controller: _controller,
                      cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: "Enter text",
                      border: InputBorder.none, // removes underline
                      enabledBorder: InputBorder.none, // removes underline when not focused
                      focusedBorder: InputBorder.none, // removes underline when focused
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: _sendMessage,
              )
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
