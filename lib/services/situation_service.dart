import 'dart:convert';

import 'package:http/http.dart' as http;

import 'backend_config.dart';

class SituationServiceException implements Exception {
  const SituationServiceException(this.message);

  final String message;

  @override
  String toString() => message;
}

class SituationService {
  const SituationService({http.Client? client}) : _client = client;

  final http.Client? _client;

  Future<String> refineSituation(String rawSituation) async {
    final http.Client client = _client ?? http.Client();
    final bool shouldClose = _client == null;

    try {
      final Uri uri = Uri.parse(
        '${BackendConfig.baseUrl}/api/situation/refine',
      );
      final http.Response response = await client.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'raw_situation': rawSituation,
        }),
      );

      if (response.statusCode != 200) {
        throw SituationServiceException(
          '상황 문장을 정리하지 못했어요. 백엔드 서버와 API 키 설정을 확인해 주세요.',
        );
      }

      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      final String refinedSituation =
          (data['refined_situation'] as String? ?? '').trim();

      if (refinedSituation.isEmpty) {
        throw const SituationServiceException(
          '서버가 비어 있는 응답을 돌려줬어요.',
        );
      }

      return refinedSituation;
    } on FormatException {
      throw const SituationServiceException(
        '서버 응답 형식을 해석하지 못했어요.',
      );
    } on http.ClientException {
      throw const SituationServiceException(
        '백엔드 서버에 연결하지 못했어요. 서버가 실행 중인지 확인해 주세요.',
      );
    } finally {
      if (shouldClose) {
        client.close();
      }
    }
  }
}
