import 'package:dio/dio.dart';

/// Cliente HTTP central da aplicação (baseado em Dio).
///
/// Hoje os dados vêm de `lib/data/mock_deals.dart` e `mock_affiliates.dart`.
/// Quando o backend (Supabase) estiver disponível, basta apontar [baseUrl]
/// para a URL do projeto Supabase e plugar o token de autenticação no
/// interceptor abaixo. Os contratos de request/response estão documentados
/// em `achou_achado_api/api_report.md`.
class ApiClient {
  ApiClient({String? baseUrl})
      : dio = Dio(
          BaseOptions(
            baseUrl: baseUrl ?? _defaultBaseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _accessToken;
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  // TODO: substituir pela URL do projeto Supabase (Settings > API > Project URL).
  static const _defaultBaseUrl = 'https://api.achadosbr.com/v1';

  final Dio dio;
  String? _accessToken;

  void setAccessToken(String? token) => _accessToken = token;
}
