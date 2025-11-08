import 'package:shared_preferences/shared_preferences.dart';
import 'package:lab_3/core/kv_store.dart';

final class SharedPrefsStore implements KVStore {
  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  @override
  Future<bool> setString(String key, String value) async {
    final p = await _prefs;
    return p.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    final p = await _prefs;
    return p.getString(key);
  }

  @override
  Future<bool> remove(String key) async {
    final p = await _prefs;
    return p.remove(key);
  }

  @override
  Future<bool> setStringList(String key, List<String> value) async {
    final p = await _prefs;
    return p.setStringList(key, value);
  }

  @override
  Future<List<String>?> getStringList(String key) async {
    final p = await _prefs;
    return p.getStringList(key);
  }
}
