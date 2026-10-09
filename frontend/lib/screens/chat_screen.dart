import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller =
      TextEditingController();

  final List<Map<String, dynamic>> messages = [];

  bool loading = false;

  Future<void> sendMessage() async {
    final text = controller.text.trim();

    if (text.isEmpty) return;

    setState(() {
      messages.add({
        "message": text,
        "isUser": true,
      });

      loading = true;
    });

    controller.clear();

    try {
      final response = await http.post(
        Uri.parse(
          "http://127.0.0.1:8000/chat",
        ),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "message": text,
        }),
      );

      final data = jsonDecode(response.body);

      setState(() {
        messages.add({
          "message": data["response"],
          "isUser": false,
        });
      });
    } catch (e) {
      setState(() {
        messages.add({
          "message":
              "Error connecting to Alex backend.",
          "isUser": false,
        });
      });
    }

    setState(() {
      loading = false;
    });
  }

  Widget buildMessage(
    String text,
    bool isUser,
  ) {
    return Align(
      alignment: isUser
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 700,
        ),
        margin: const EdgeInsets.only(
          bottom: 12,
        ),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUser
              ? Colors.blue
              : Colors.grey.shade900,
          borderRadius:
              BorderRadius.circular(12),
        ),
        child: isUser
            ? Text(
                text,
                style: const TextStyle(
                  fontSize: 15,
                ),
              )
            : MarkdownBody(
                data: text,
                selectable: true,
                styleSheet: MarkdownStyleSheet(
                  p: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  h1: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  h2: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  h3: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  strong: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  em: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                  listBullet: const TextStyle(
                    color: Colors.white,
                  ),
                  code: TextStyle(
                    backgroundColor:
                        Colors.grey.shade800,
                    color: Colors.greenAccent,
                  ),
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Alex Chat",
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];

                return buildMessage(
                  msg["message"],
                  msg["isUser"],
                );
              },
            ),
          ),
          if (loading)
            const Padding(
              padding: EdgeInsets.all(10),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration:
                        const InputDecoration(
                      hintText:
                          "Ask Alex something...",
                      border:
                          OutlineInputBorder(),
                    ),
                    onSubmitted: (_) =>
                        sendMessage(),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed:
                      loading ? null : sendMessage,
                  icon: const Icon(
                    Icons.send,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}