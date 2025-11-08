import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lab_3/secrets.dart';

class TmdbApi {
  static const _base = 'https://api.themoviedb.org/3';
  static const imgBase = 'https://image.tmdb.org/t/p/w500';

  final _client = http.Client();
  final String apiKey = Secrets.tmdbApiKey;

  Uri _u(String path, [Map<String, String>? q]) =>
      Uri.parse('$_base$path').replace(queryParameters: {
        'api_key': apiKey,
        'language': 'en-US',
        ...?q,
      });

  Future<Map<String, dynamic>> getJson(String path, [Map<String, String>? q]) async {
    final res = await _client.get(_u(path, q));
    if (res.statusCode != 200) {
      throw Exception('TMDb ${res.statusCode}: ${res.body}');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static String? img(String? path) =>
      (path == null || path.isEmpty) ? null : '$imgBase$path';
}
