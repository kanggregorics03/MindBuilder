import 'dart:convert';

List<String> decodeJsonStringList(String rawValue) {
  try {
    final decoded = jsonDecode(rawValue);
    if (decoded is List) {
      return decoded.whereType<String>().toList(growable: false);
    }
  } catch (_) {
    return const <String>[];
  }
  return const <String>[];
}

String encodeJsonStringList(List<String> values) {
  return jsonEncode(values);
}
