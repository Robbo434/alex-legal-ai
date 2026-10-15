import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;

import '../models/conversation.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller =
      TextEditingController();

  bool loading = false;

  List<Conversation> conversations = [
    Conversation(
      title: "New Chat",
      messages: [],
    ),
  ];

  int selectedConversation = 0;

  Conversation get currentConversation =>
      conversations[selectedConversation];

  void createNewChat() {
    setState(() {
      conversations.insert(
        0,
        Conversation(
          title: "New Chat",
          messages: [],
        ),
      );

      selectedConversation = 0;
    });
  }

  Future<void> sendMessage() async {
    final text = controller.text.trim();

    if (text.isEmpty) return;

    setState(() {
      currentConversation.messages.add({
        "message": text,
        "isUser": true,
      });

      if (currentConversation.title == "New Chat") {
        currentConversation.title =
            text.length > 30
                ? text.substring(0, 30)
                : text;
      }

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
        currentConversation.messages.add({
          "message": data["response"],
          "isUser": false,
        });
      });
    } catch (e) {
      setState(() {
        currentConversation.messages.add({
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
          maxWidth: 800,
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
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 260,
            color: Colors.black87,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.all(12),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: createNewChat,
                      icon: const Icon(Icons.add),
                      label:
                          const Text("New Chat"),
                    ),
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        conversations.length,
                    itemBuilder:
                        (context, index) {
                      final conversation =
                          conversations[index];

                      return ListTile(
                        selected:
                            selectedConversation ==
                                index,
                        leading:
                            const Icon(Icons.chat),
                        title: Text(
                          conversation.title,
                          maxLines: 1,
                          overflow:
                              TextOverflow
                                  .ellipsis,
                        ),
                        onTap: () {
                          setState(() {
                            selectedConversation =
                                index;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                AppBar(
                  title: Text(
                    currentConversation.title,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.all(20),
                    itemCount:
                        currentConversation
                            .messages
                            .length,
                    itemBuilder:
                        (context, index) {
                      final msg =
                          currentConversation
                              .messages[index];

                      return buildMessage(
                        msg["message"],
                        msg["isUser"],
                      );
                    },
                  ),
                ),
                if (loading)
                  const Padding(
                    padding:
                        EdgeInsets.all(10),
                    child:
                        CircularProgressIndicator(),
                  ),
                Padding(
                  padding:
                      const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller:
                              controller,
                          decoration:
                              const InputDecoration(
                            hintText:
                                "Ask Alex something...",
                            border:
                                OutlineInputBorder(),
                          ),
                          onSubmitted:
                              (_) =>
                                  sendMessage(),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                        onPressed: loading
                            ? null
                            : sendMessage,
                        icon: const Icon(
                          Icons.send,
                        ),
                      ),
                    ],
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