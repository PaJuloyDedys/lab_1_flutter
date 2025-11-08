class MovieSummary {
  const MovieSummary({
    required this.id,
    required this.title,
    required this.year,
    required this.posterUrl,
    required this.rating5,
  });

  final int id;
  final String title;
  final int year;
  final String? posterUrl;
  final double rating5;
}

class MovieDetails {
  const MovieDetails({
    required this.id,
    required this.title,
    required this.year,
    required this.overview,
    required this.posterUrl,
    required this.backdropUrl,
    required this.rating5,
  });

  final int id;
  final String title;
  final int year;
  final String overview;
  final String? posterUrl;
  final String? backdropUrl;
  final double rating5;
}
