import 'package:supabase_flutter/supabase_flutter.dart';

class ChatService {
  final supabase = Supabase.instance.client;

  Future<void> createConversation({
    required String conversationId,
    required String title,
  }) async {
    final user =
        supabase.auth.currentUser;

    if (user == null) return;

    await supabase.from(
      'conversations',
    ).insert({
      'id': conversationId,
      'user_id': user.id,
      'title': title,
    });
  }

  Future<void> saveMessage({
    required String conversationId,
    required String role,
    required String content,
  }) async {
    await supabase.from(
      'messages',
    ).insert({
      'conversation_id':
          conversationId,
      'role': role,
      'content': content,
    });
  }

  Future<List<dynamic>>
      getConversations() async {
    final user =
        supabase.auth.currentUser;

    if (user == null) return [];

    return await supabase
        .from('conversations')
        .select()
        .eq('user_id', user.id)
        .order(
          'created_at',
          ascending: false,
        );
  }

  Future<List<dynamic>> getMessages(
    String conversationId,
  ) async {
    return await supabase
        .from('messages')
        .select()
        .eq(
          'conversation_id',
          conversationId,
        )
        .order(
          'created_at',
          ascending: true,
        );
  }
}