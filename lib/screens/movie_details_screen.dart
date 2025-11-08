import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lab_3/services.dart' as di;
import 'package:lab_3/widgets/rating_stars.dart';
import 'package:lab_3/features/watchlist/movie.dart';
import 'package:lab_3/domain/movies.dart';

class MovieDetailsScreen extends StatefulWidget {
  const MovieDetailsScreen({super.key, required this.id});
  final int id;

  @override
  State<MovieDetailsScreen> createState() => _S();
}

class _S extends State<MovieDetailsScreen> {
  bool loading = true;
  String? err;
  MovieDetails? data;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { loading = true; err = null; });
    try {
      data = await di.movies.details(widget.id);
    } catch (e) {
      err = e.toString();
    }
    setState(() => loading = false);
  }

  Future<void> _addToWatchlist() async {
    final u = await di.auth.current();
    final d = data;
    if (u == null || d == null) return;

    final item = MovieItem(
      id: d.id.toString(),
      title: d.title,
      year: d.year,
      posterUrl: d.posterUrl ?? d.backdropUrl,
      status: MovieStatus.planned,
    );

    await di.watch.add(u.email, item);

    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Added to watchlist')));
    Navigator.pop(context, true); // ✅ повідомляємо попередній екран/ланцюжок
  }

  @override
  Widget build(BuildContext c) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (err != null) {
      return Scaffold(appBar: AppBar(), body: Center(child: Text(err!)));
    }
    final d = data!;

    return Scaffold(
      appBar: AppBar(title: Text(d.title)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addToWatchlist,
        label: const Text('Add to watchlist'),
        icon: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (d.backdropUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: d.backdropUrl!,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              RatingStars(d.rating5, size: 20),
              const SizedBox(width: 8),
              Text('${d.year}'),
            ],
          ),
          const SizedBox(height: 12),
          Text(d.overview),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
