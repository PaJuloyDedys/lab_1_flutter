import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lab_3/domain/movies.dart';
import 'package:lab_3/services.dart' as di;
import 'package:lab_3/widgets/rating_stars.dart';
import 'package:lab_3/router.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});
  @override
  State<MoviesScreen> createState() => _S();
}

class _S extends State<MoviesScreen> {
  List<MovieSummary> items = [];
  bool loading = true;
  String query = '';

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => loading = true);
    items = query.isEmpty ? await di.movies.popular() : await di.movies.search(query);
    setState(() => loading = false);
  }

  Future<void> _openDetails(MovieSummary m) async {
    final added = await Navigator.pushNamed(context, AppRoutes.movieDetails, arguments: m.id);
    if (added == true && mounted) {
      // повернемось на цей екран і скажемо попередньому, що були зміни
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Movies'),
        actions: [ IconButton(icon: const Icon(Icons.refresh), onPressed: _load), ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search movies...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onSubmitted: (v){ query = v.trim(); _load(); },
            ),
          ),
          if (loading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.66, crossAxisSpacing: 12, mainAxisSpacing: 12),
                itemCount: items.length,
                itemBuilder: (_, i) {
                  final m = items[i];
                  return InkWell(
                    onTap: () => _openDetails(m),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: m.posterUrl == null
                                ? Container(color: Colors.black12)
                                : CachedNetworkImage(imageUrl: m.posterUrl!, fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(m.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                        Row(children: [
                          RatingStars(m.rating5, size: 14),
                          const SizedBox(width: 6),
                          Text('${m.year}', style: Theme.of(c).textTheme.bodySmall),
                        ]),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
