enum MovieStatus { planned, watching, watched }

MovieStatus _statusFromString(String? s) {
  switch (s) {
    case 'watching':
      return MovieStatus.watching;
    case 'watched':
      return MovieStatus.watched;
    default:
      return MovieStatus.planned;
  }
}

String _statusToString(MovieStatus s) {
  switch (s) {
    case MovieStatus.watching:
      return 'watching';
    case MovieStatus.watched:
      return 'watched';
    case MovieStatus.planned:
    default:
      return 'planned';
  }
}

class MovieItem {
  MovieItem({
    required this.id,
    required this.title,
    required this.year,
    this.posterUrl,
    this.watched = false, // залишили для зворотної сумісності
    this.status = MovieStatus.planned,
    this.userRating, // 0..5
  });

  final String id;          // TMDb id як String
  final String title;
  final int year;
  final String? posterUrl;
  final bool watched;       // не використовується напряму, але зберігаємо
  final MovieStatus status; // основний статус
  final int? userRating;    // 0..5

  MovieItem copy({
    String? title,
    int? year,
    String? posterUrl,
    bool? watched,
    MovieStatus? status,
    int? userRating,
  }) =>
      MovieItem(
        id: id,
        title: title ?? this.title,
        year: year ?? this.year,
        posterUrl: posterUrl ?? this.posterUrl,
        watched: watched ?? this.watched,
        status: status ?? this.status,
        userRating: userRating ?? this.userRating,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'year': year,
    'posterUrl': posterUrl,
    'watched': watched,
    'status': _statusToString(status),
    'userRating': userRating,
  };

  factory MovieItem.fromJson(Map<String, dynamic> j) => MovieItem(
    id: j['id'] as String,
    title: j['title'] as String,
    year: j['year'] as int,
    posterUrl: j['posterUrl'] as String?,
    watched: j['watched'] as bool? ?? false,
    status: _statusFromString(j['status'] as String?),
    userRating: (j['userRating'] as num?)?.toInt(),
  );
}
