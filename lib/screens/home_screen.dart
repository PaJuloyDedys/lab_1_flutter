import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lab_3/widgets/app_scaffold.dart';
import 'package:lab_3/services.dart' as di;
import 'package:lab_3/domain/user.dart';
import 'package:lab_3/features/watchlist/movie.dart';
import 'package:lab_3/router.dart';

enum SortBy { title, year, status }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _S();
}

class _S extends State<HomeScreen> {
  User? me;
  List<MovieItem> items = [];
  MovieStatus? filter; // null = all
  SortBy sortBy = SortBy.title;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final u = await di.auth.current();
    final list = u == null ? <MovieItem>[] : await di.watch.all(u.email);
    setState(() { me = u; items = list; });
  }

  Future<void> _openMovies() async {
    final changed = await Navigator.pushNamed(context, AppRoutes.movies);
    if (changed == true) _load();
  }

  void _changeStatus(MovieItem m, MovieStatus s) async {
    if (me == null) return;
    final n = m.copy(status: s, watched: s == MovieStatus.watched);
    await di.watch.update(me!.email, n);
    setState(() {
      items[items.indexWhere((e) => e.id == m.id)] = n;
    });
  }

  void _delete(MovieItem m) async {
    if (me == null) return;
    await di.watch.remove(me!.email, m.id);
    setState(() => items.removeWhere((e) => e.id == m.id));
  }

  List<MovieItem> _filteredSorted() {
    var list = items;
    if (filter != null) list = list.where((e) => e.status == filter).toList();
    switch (sortBy) {
      case SortBy.title:
        list.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case SortBy.year:
        list.sort((a, b) => b.year.compareTo(a.year));
        break;
      case SortBy.status:
        int rank(MovieStatus s) => s == MovieStatus.watched ? 2 : (s == MovieStatus.watching ? 1 : 0);
        list.sort((a, b) => rank(b.status).compareTo(rank(a.status)));
        break;
    }
    return list;
  }

  Color _bgFor(BuildContext c, MovieStatus s) {
    final cs = Theme.of(c).colorScheme;
    switch (s) {
      case MovieStatus.planned:  return cs.secondaryContainer;
      case MovieStatus.watching: return cs.tertiaryContainer;
      case MovieStatus.watched:  return cs.primaryContainer;
    }
  }

  Color _fgFor(BuildContext c, MovieStatus s) {
    final cs = Theme.of(c).colorScheme;
    switch (s) {
      case MovieStatus.planned:  return cs.onSecondaryContainer;
      case MovieStatus.watching: return cs.onTertiaryContainer;
      case MovieStatus.watched:  return cs.onPrimaryContainer;
    }
  }

  Widget _statusChip(BuildContext c, MovieStatus s) {
    final sel = filter == s;
    final label = {
      MovieStatus.planned: 'Planned',
      MovieStatus.watching: 'Watching',
      MovieStatus.watched: 'Watched',
    }[s]!;
    return ChoiceChip(
      label: Text(label),
      selected: sel,
      backgroundColor: _bgFor(c, s).withOpacity(0.45),
      selectedColor: _bgFor(c, s),
      labelStyle: TextStyle(color: sel ? _fgFor(c, s) : null),
      onSelected: (_) => setState(() => filter = sel ? null : s),
    );
  }

  @override
  Widget build(BuildContext c) {
    final title = me == null ? 'Watchlist' : 'Watchlist — ${me!.email}';
    final list = _filteredSorted();

    return AppScaffold(
      title: title,
      child: Column(
        children: [
          // Top actions
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _openMovies,
                icon: const Icon(Icons.movie),
                label: const Text('Movies'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
                child: const Text('Profile'),
              ),
              const Spacer(),
              DropdownButton<SortBy>(
                value: sortBy,
                onChanged: (v) => setState(() => sortBy = v ?? sortBy),
                items: const [
                  DropdownMenuItem(value: SortBy.title,  child: Text('Sort: Title')),
                  DropdownMenuItem(value: SortBy.year,   child: Text('Sort: Year')),
                  DropdownMenuItem(value: SortBy.status, child: Text('Sort: Status')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Filter chips
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: const Text('All'),
                selected: filter == null,
                onSelected: (_) => setState(() => filter = null),
              ),
              _statusChip(c, MovieStatus.planned),
              _statusChip(c, MovieStatus.watching),
              _statusChip(c, MovieStatus.watched),
            ],
          ),
          const SizedBox(height: 8),
          // Content
          Expanded(
            child: list.isEmpty
                ? const Center(child: Text('Your watchlist is empty. Open "Movies" to add.'))
                : ListView.separated(
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _MovieCard(
                item: list[i],
                color: _bgFor(c, list[i].status),
                onSetPlanned: () => _changeStatus(list[i], MovieStatus.planned),
                onSetWatching: () => _changeStatus(list[i], MovieStatus.watching),
                onSetWatched: () => _changeStatus(list[i], MovieStatus.watched),
                onDelete: () => _delete(list[i]),
                fg: _fgFor(c, list[i].status),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieCard extends StatelessWidget {
  const _MovieCard({
    required this.item,
    required this.color,
    required this.fg,
    required this.onSetPlanned,
    required this.onSetWatching,
    required this.onSetWatched,
    required this.onDelete,
  });

  final MovieItem item;
  final Color color;
  final Color fg;
  final VoidCallback onSetPlanned;
  final VoidCallback onSetWatching;
  final VoidCallback onSetWatched;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final statusLabel = {
      MovieStatus.planned: 'Planned',
      MovieStatus.watching: 'Watching',
      MovieStatus.watched: 'Watched',
    }[item.status]!;

    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border(left: BorderSide(color: color, width: 6)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: item.posterUrl == null
                    ? Container(width: 80, height: 120, color: Colors.black12)
                    : CachedNetworkImage(
                    imageUrl: item.posterUrl!,
                    width: 80, height: 120, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text('${item.year}', style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 8),
                    Chip(
                      backgroundColor: color,
                      label: Text(statusLabel),
                      labelStyle: TextStyle(color: fg),
                      side: BorderSide.none,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        TextButton(onPressed: onSetPlanned,  child: const Text('Planned')),
                        TextButton(onPressed: onSetWatching, child: const Text('Watching')),
                        TextButton(onPressed: onSetWatched,  child: const Text('Watched')),
                        const Spacer(),
                        IconButton(onPressed: onDelete, icon: const Icon(Icons.delete)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
