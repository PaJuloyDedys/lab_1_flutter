import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:lab_3/core/kv_store.dart';
import 'package:lab_3/domain/auth_repo.dart';
import 'package:lab_3/domain/user.dart';



const _usersKey = 'users_v1';
const _currentKey = 'current_email';

String hashPassword(String s) => sha256.convert(utf8.encode(s)).toString();

final class LocalAuthRepository implements AuthRepository {
  LocalAuthRepository(this.store);
  final KVStore store;

  Future<Map<String, dynamic>> _allUsers() async {
    return parseJsonOrEmpty(await store.getString(_usersKey));
  }

  Future<void> _saveUsers(Map<String, dynamic> m) async {
    await store.setString(_usersKey, jsonEncode(m));
  }

  @override
  Future<void> register(User u) async {
    final m = await _allUsers();
    if (m.containsKey(u.email)) {
      throw Exception('Email already used');
    }
    m[u.email] = u.toJson();
    await _saveUsers(m);
  }

  @override
  Future<User> login(String email, String pass) async {
    final m = await _allUsers();
    final j = m[email] as Map<String, dynamic>?;
    if (j == null) throw Exception('User not found');
    if (j['hash'] != hashPassword(pass)) throw Exception('Wrong password');
    await store.setString(_currentKey, email);
    return User.fromJson(j);
  }

  @override
  Future<void> logout() => store.remove(_currentKey);

  @override
  Future<User?> current() async {
    final email = await store.getString(_currentKey);
    if (email == null) return null;
    final m = await _allUsers();
    final j = m[email] as Map<String, dynamic>?;
    return j == null ? null : User.fromJson(j);
  }

  @override
  Future<User> update(User u) async {
    final m = await _allUsers();
    if (!m.containsKey(u.email)) {
      throw Exception('User missing');
    }
    m[u.email] = u.toJson();
    await _saveUsers(m);
    return u;
  }
}
