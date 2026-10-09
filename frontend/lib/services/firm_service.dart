import 'package:supabase_flutter/supabase_flutter.dart';

class FirmService {
  final supabase = Supabase.instance.client;

  Future<bool> validateFirmCode(String setupCode) async {
    final result = await supabase
        .from('firms')
        .select()
        .eq('setup_code', setupCode)
        .eq('active', true);

    return result.isNotEmpty;
  }
}