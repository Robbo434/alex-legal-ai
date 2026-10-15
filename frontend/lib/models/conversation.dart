class Conversation {
  String id;
  String title;
  List<Map<String, dynamic>> messages;

  Conversation({
    required this.id,
    required this.title,
    required this.messages,
  });
}