import 'package:supabase_flutter/supabase_flutter.dart';

/// Inicialização do cliente Supabase.
///
/// A URL e a anon key vêm de `--dart-define` para não ficarem hardcoded no
/// repositório (ver `achou_achado_api/supabase/README.md`):
///
/// ```
/// flutter run \
///   --dart-define=SUPABASE_URL=https://xxxx.supabase.co \
///   --dart-define=SUPABASE_ANON_KEY=eyJ...
/// ```
///
/// Enquanto essas variáveis não forem definidas, [isConfigured] é `false` e
/// o app continua funcionando normalmente com os dados mocados.
class AppSupabase {
  AppSupabase._();

  static const _url = String.fromEnvironment('SUPABASE_URL');
  static const _anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static bool get isConfigured => _url.isNotEmpty && _anonKey.isNotEmpty;

  static Future<void> init() async {
    if (!isConfigured) return;
    await Supabase.initialize(url: _url, anonKey: _anonKey);
  }

  static SupabaseClient get client => Supabase.instance.client;
}
