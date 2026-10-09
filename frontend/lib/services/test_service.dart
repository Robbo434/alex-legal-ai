import 'package:supabase_flutter/supabase_flutter.dart';

class TestService {
  final supabase = Supabase.instance.client;

  Future<void> testConnection() async {
    final result = await supabase
        .from('firms')
        .select();

    print(result);
  }
}