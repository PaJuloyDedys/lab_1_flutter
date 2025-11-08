import 'dart:convert';

abstract class KVStore {
  Future<bool> setString(String key, String value);
  Future<String?> getString(String key);
  Future<bool> remove(String key);

  Future<bool> setStringList(String key, List<String> value);
  Future<List<String>?> getStringList(String key);
}

Map<String, dynamic> parseJsonOrEmpty(String? s) {
  if (s == null || s.isEmpty) return <String, dynamic>{};
  try {
    return jsonDecode(s) as Map<String, dynamic>;
  } catch (_) {
    return {};
  }
}

List<Map<String, dynamic>> parseListJsonOrEmpty(String? s) {
  if (s == null || s.isEmpty) return <Map<String, dynamic>>[];
  try {
    final list = jsonDecode(s) as List<dynamic>;
    return list.cast<Map<String, dynamic>>();
  } catch (_) {
    return <Map<String, dynamic>>[];
  }
}
