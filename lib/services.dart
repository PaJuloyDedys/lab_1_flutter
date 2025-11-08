import 'package:lab_3/data/local/shared_prefs_store.dart';
import 'package:lab_3/data/local/local_auth_repo.dart';
import 'package:lab_3/data/local/local_watchlist_store.dart';

import 'package:lab_3/data/remote/tmdb_api.dart';
import 'package:lab_3/data/remote/remote_movie_repo.dart';
import 'package:lab_3/domain/movie_repo.dart';

final store = SharedPrefsStore();
final auth  = LocalAuthRepository(store);
final watch = LocalWatchlistStore(store);

final tmdb  = TmdbApi();
final MovieRepository movies = RemoteMovieRepository(tmdb);
