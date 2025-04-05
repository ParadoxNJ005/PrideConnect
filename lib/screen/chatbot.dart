import 'dart:developer';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';
import 'package:prideconnect/screen/profilePage.dart';
import 'package:prideconnect/utils/contstants.dart';
import '../components/logo.dart';

class ChatBot extends StatefulWidget {
  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  // Initialize Vertex AI
  final vertexAI = FirebaseVertexAI.instance;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return; // Same as JS: if (!input.trim()) return;

    if (mounted) {
      setState(() {
        _messages.add({"sender": "user", "text": message}); // Match JS key names
        _isLoading = true;
      });
    }

    try {
      // Use Vertex AI generative model (equivalent to generateAIResponse )
      final model = vertexAI.generativeModel(
        model: 'gemini-1.5-flash',
      );

      // Generate content based on the user's message
      final response = await model.generateContent([Content.text(message)]);
      String botResponse = response.text ?? "I couldn't understand that.";

      if (botResponse.isEmpty) {
        throw Exception("Empty response from AI."); // Match JS error
      }

      if (mounted) {
        setState(() {
          _messages.add({"sender": "bot", "text": botResponse});
        });
      }
    } catch (error) {
      log("Error fetching AI response: $error"); // Match JS console log
      if (mounted) {
        setState(() {
          _messages.add({"sender": "bot", "text": "Error fetching response."});
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Helper method to parse text and apply bold formatting for *text*
  List<TextSpan> _parseText(String text, Color color) {
    final List<TextSpan> spans = [];
    final RegExp boldRegex = RegExp(r'\*(.*?)\*'); // Detects *text* like JS
    int lastEnd = 0;

    for (final match in boldRegex.allMatches(text)) {
      // Add text before the bold section
      if (match.start > lastEnd) {
        spans.add(TextSpan(
          text: text.substring(lastEnd, match.start),
          style: TextStyle(color: color, fontSize: 16),
        ));
      }
      // Add the bold section
      spans.add(TextSpan(
        text: match.group(1), // Text inside *...*
        style: TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ));
      lastEnd = match.end;
    }

    // Add remaining text after the last bold section
    if (lastEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastEnd),
        style: TextStyle(color: color, fontSize: 16),
      ));
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.PrideAPPCOLOUR,
      appBar: AppBar(
        title: const Text(
          "Chat Bot",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Constants.PrideAPPCOLOUR,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => ProfilePage()));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/loading.png',
                    fit: BoxFit.contain),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Center(child: _buildGetInvolved()),
            )
                : ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUserMessage = message["sender"] == "user"; // Match JS sender key
                isUserMessage
                    ? log(message["text"]!)
                    : log(message["text"]!);
                return Container(
                  alignment: isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isUserMessage
                          ? Colors.blueAccent
                          : Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: isUserMessage
                            ? const Radius.circular(12)
                            : Radius.zero,
                        bottomRight: isUserMessage
                            ? Radius.zero
                            : const Radius.circular(12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          spreadRadius: 1,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: RichText(
                      text: TextSpan(
                        children: _parseText(
                          message["text"]!, // Match JS text key
                          isUserMessage ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: LogoAnimationWidget(),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      ),
                      onSubmitted: (value) {
                        _sendMessage(value);
                        _controller.clear();
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final message = _controller.text;
                    _sendMessage(message);
                    _controller.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.send, color: Colors.blueAccent, size: 18),
                      SizedBox(width: 5),
                      Text('Send', style: TextStyle(color: Colors.blueAccent)),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildGetInvolved() {
    final List<Map<String, IconData>> missions = [
      {"Career Growth": Icons.work},
      {"Laws and Rules": Icons.rule},
      {"Community": Icons.groups},
      {"Safe Space": Icons.security},
      {"Mentorship": Icons.help},
      {"Support": Icons.favorite},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: missions.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white)),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(missions[index].values.first,
                    color: Colors.white, size: 45),
                SizedBox(height: 10),
                Text(missions[index].keys.first,
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ],
            ),
          ),
        );
      },
    );
  }
}