import 'dart:convert';

import 'package:http/http.dart' as http;

import 'backend_config.dart';

class AutomaticThoughtServiceException implements Exception {
  const AutomaticThoughtServiceException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AutomaticThoughtService {
  const AutomaticThoughtService({http.Client? client}) : _client = client;

  final http.Client? _client;

  Future<List<String>> generateAutomaticThoughts({
    required String situation,
    String originalSituation = '',
    List<String> emotions = const <String>[],
  }) async {
    final http.Client client = _client ?? http.Client();
    final bool shouldClose = _client == null;

    try {
      final Uri uri = Uri.parse(
        '${BackendConfig.baseUrl}/api/automatic-thoughts/generate',
      );
      final http.Response response = await client.post(
        uri,
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, dynamic>{
          'situation': situation,
          'original_situation': originalSituation,
          'emotions': emotions,
        }),
      );

      if (response.statusCode != 200) {
        throw const AutomaticThoughtServiceException(
          '자동적 사고 추천을 불러오지 못했어요. 백엔드 서버와 API 설정을 확인해 주세요.',
        );
      }

      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      final List<String> thoughts =
          ((data['automatic_thoughts'] as List?) ?? <dynamic>[])
              .map((dynamic item) => (item as String? ?? '').trim())
              .where((String item) => item.isNotEmpty)
              .toList();

      if (thoughts.isEmpty) {
        throw const AutomaticThoughtServiceException(
          '서버가 추천 생각을 비어 있는 상태로 돌려줬어요.',
        );
      }

      return thoughts;
    } on FormatException {
      throw const AutomaticThoughtServiceException('서버 응답 형식을 해석하지 못했어요.');
    } on http.ClientException {
      throw const AutomaticThoughtServiceException(
        '백엔드 서버에 연결하지 못했어요. 서버가 실행 중인지 확인해 주세요.',
      );
    } finally {
      if (shouldClose) {
        client.close();
      }
    }
  }
}
