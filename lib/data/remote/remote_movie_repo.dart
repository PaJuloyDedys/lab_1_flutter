import 'package:lab_3/data/remote/tmdb_api.dart';
import 'package:lab_3/domain/movie_repo.dart';
import 'package:lab_3/domain/movies.dart';

class RemoteMovieRepository implements MovieRepository {
  RemoteMovieRepository(this.api);
  final TmdbApi api;

  double _to5(num? v) => ((v ?? 0).toDouble() / 2.0).clamp(0.0, 5.0);

  int _year(String? date) {
    if (date == null || date.isEmpty) return DateTime.now().year;
    final y = int.tryParse(date.split('-').first);
    return y ?? DateTime.now().year;
  }

  MovieSummary _summary(Map j) => MovieSummary(
    id: j['id'] as int,
    title: (j['title'] ?? j['name'] ?? '') as String,
    year: _year(j['release_date'] as String?),
    posterUrl: TmdbApi.img(j['poster_path'] as String?),
    rating5: _to5(j['vote_average'] as num?),
  );

  MovieDetails _details(Map j) => MovieDetails(
    id: j['id'] as int,
    title: (j['title'] ?? j['name'] ?? '') as String,
    year: _year(j['release_date'] as String?),
    overview: (j['overview'] ?? '') as String,
    posterUrl: TmdbApi.img(j['poster_path'] as String?),
    backdropUrl: TmdbApi.img(j['backdrop_path'] as String?),
    rating5: _to5(j['vote_average'] as num?),
  );

  @override
  Future<List<MovieSummary>> popular({int page = 1}) async {
    final j = await api.getJson('/movie/popular', {'page': '$page'});
    final results = (j['results'] as List).cast<Map>();
    return results.map(_summary).toList();
  }

  @override
  Future<List<MovieSummary>> search(String q, {int page = 1}) async {
    final j = await api.getJson('/search/movie', {'query': q, 'page': '$page'});
    final results = (j['results'] as List).cast<Map>();
    return results.map(_summary).toList();
  }

  @override
  Future<MovieDetails> details(int id) async {
    final j = await api.getJson('/movie/$id');
    return _details(j);
  }
}
