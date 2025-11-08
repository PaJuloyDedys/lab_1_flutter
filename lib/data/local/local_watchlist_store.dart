import 'dart:convert';
import 'package:lab_3/core/kv_store.dart';
import 'package:lab_3/features/watchlist/movie.dart';

abstract class WatchlistStore {
  Future<List<MovieItem>> all(String ownerEmail);
  Future<void> add(String ownerEmail, MovieItem m);
  Future<void> update(String ownerEmail, MovieItem m);
  Future<void> remove(String ownerEmail, String id);
}

final class LocalWatchlistStore implements WatchlistStore {
  LocalWatchlistStore(this.store);
  final KVStore store;

  String _key(String email) => 'movies_${email}_v1';

  Future<List<MovieItem>> _load(String k) async {
    final list = parseListJsonOrEmpty(await store.getString(k));
    // Для сумісності зі старим форматом (без статусу/постера)
    return list.map((e) {
      final m = Map<String, dynamic>.from(e);
      m['status'] ??= 'planned';
      m['posterUrl'] ??= null;
      return MovieItem.fromJson(m);
    }).toList();
  }

  Future<void> _save(String k, List<MovieItem> items) async {
    await store.setString(
      k,
      jsonEncode(items.map((e) => e.toJson()).toList()),
    );
  }

  @override
  Future<List<MovieItem>> all(String email) async => _load(_key(email));

  @override
  Future<void> add(String email, MovieItem m) async {
    final k = _key(email);
    final list = await _load(k);
    final exists = list.any((e) => e.id == m.id);
    if (!exists) {
      list.add(m);
      await _save(k, list);
    }
  }

  @override
  Future<void> update(String email, MovieItem m) async {
    final k = _key(email);
    final list = await _load(k);
    final i = list.indexWhere((e) => e.id == m.id);
    if (i >= 0) {
      list[i] = m;
      await _save(k, list);
    }
  }

  @override
  Future<void> remove(String email, String id) async {
    final k = _key(email);
    final list = await _load(k)..removeWhere((e) => e.id == id);
    await _save(k, list);
  }
}
