import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'logo.dart';

class ChatBot extends StatefulWidget {
  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  @override
  void initState(){
    super.initState();
    const apiKey = 'API_KEY'; // Replace with your actual API key.
    Gemini.init(apiKey: apiKey);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Define allowed keywords
    const allowedKeywords = [
      "recycle", "recycling", "reusable", "reuse", "urjasetu", "renewable",
      "renewables", "sustainable", "sustainability", "eco-friendly", "energy",
      "carbon footprint", "electricity",
      "biogas", "green energy", "clean energy", "environment", "climate change",
      "zero waste", "plastic waste", "upcycle",
      "natural resources","energy efficiency", "sustainable development" , "energy storage", "renewable solutions", "climate action",
      "clean technology", "sustainable energy",
      "environmental impact"
    ];

    // Check if the message contains any of the allowed keywords
    final containsAllowedKeyword = allowedKeywords.any(
          (keyword) => message.toLowerCase().contains(keyword.toLowerCase()),
    );

    if (!containsAllowedKeyword) {
      if (mounted) {
        setState(() {
          _messages.add({"bot": "I can only respond to questions related to Urja Setu, energy generation, renewables, and similar topics."});
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _messages.add({"user": message});
        _isLoading = true;
      });
    }

    try {
      final gemini = Gemini.instance;
      final contextMessage = """
        Urja Setu is a transformative initiative aimed at bridging energy access gaps in underserved communities by promoting renewable energy solutions, empowering rural regions with sustainable power sources, and fostering eco-friendly development. At its core is the development of an advanced Waste-to-Energy (WTE) platform, accessible via both Android and web, which empowers users to recycle waste and contribute to renewable energy production. The platform incorporates several innovative features, including AI-driven waste identification that uses advanced AI/ML algorithms to sort and measure various types of waste such as organic materials, plastics, and batteries. Geolocation services identify nearby WTE plants or collection points, allowing users to schedule waste pickups or drop-offs conveniently. Additionally, the platform offers blockchain-backed rewards, providing users with incentives like coupons, discounts, and energy credits that can be redeemed in cryptocurrency or NFT transactions, encouraging active participation in recycling efforts. Real-time monitoring ensures full transparency, tracking the collection and processing of waste to enhance trust and efficiency. By leveraging a robust technology stack that includes Flutter, React, Node.js, MongoDB/PostgreSQL, TensorFlow, and NumPy, Urja Setu tackles critical challenges such as pollution reduction, waste management inefficiencies, and renewable energy adoption while promoting sustainable habits, economic rewards, and environmental conservation. The initiative integrates cutting-edge technology with community-focused solutions to drive socio-economic progress, reduce carbon footprints, and support a circular economy. Your task: "$message" Respond in no more than 50 words, contextualizing your answer to Urja Setu and its focus areas such as renewable energy, waste-to-energy, recycling, and sustainability.
        """;

      final response = await gemini.prompt(parts: [Part.text(contextMessage)]);
      final botResponse = response?.output ?? "I couldn't understand that.";

      if (mounted) {
        setState(() {
          _messages.add({"bot": botResponse});
        });
      }
    } catch (error) {
      log("error in the chatbot $error");
      if (mounted) {
        setState(() {
          _messages.add({"bot": "An error in UrjaSetu AI"});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('ChatBot', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUserMessage = message.containsKey("user");

                return Container(
                  alignment: isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isUserMessage
                          ? Colors.grey[200]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Text(
                      isUserMessage
                          ? message["user"]!
                          : message["bot"]!,
                      style: TextStyle(fontSize: 16),
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
            padding: EdgeInsets.all(8.0),
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
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      ),
                      onSubmitted: (value) {
                        _sendMessage(value);
                        _controller.clear();
                      },
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final message = _controller.text;
                    _sendMessage(message);
                    _controller.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  ),
                  child: Row(
                    children: [
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
}