import 'package:lab_3/domain/movies.dart';

abstract class MovieRepository {
  Future<List<MovieSummary>> popular({int page = 1});
  Future<List<MovieSummary>> search(String query, {int page = 1});
  Future<MovieDetails> details(int id);
}
