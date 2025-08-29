class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final String releaseDate;
  final double voteAverage;
  final int voteCount;
  final bool adult;
  final List<int> genreIds;
  final String originalLanguage;
  final String originalTitle;
  final double popularity;
  final bool video;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.adult,
    required this.genreIds,
    required this.originalLanguage,
    required this.originalTitle,
    required this.popularity,
    required this.video,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      releaseDate: json['release_date'] as String? ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] as int? ?? 0,
      adult: json['adult'] as bool? ?? false,
      genreIds:
          (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      originalLanguage: json['original_language'] as String? ?? '',
      originalTitle: json['original_title'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      video: json['video'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'release_date': releaseDate,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'adult': adult,
      'genre_ids': genreIds,
      'original_language': originalLanguage,
      'original_title': originalTitle,
      'popularity': popularity,
      'video': video,
    };
  }

  Movie copyWith({
    int? id,
    String? title,
    String? overview,
    String? posterPath,
    String? backdropPath,
    String? releaseDate,
    double? voteAverage,
    int? voteCount,
    bool? adult,
    List<int>? genreIds,
    String? originalLanguage,
    String? originalTitle,
    double? popularity,
    bool? video,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      releaseDate: releaseDate ?? this.releaseDate,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      adult: adult ?? this.adult,
      genreIds: genreIds ?? this.genreIds,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      originalTitle: originalTitle ?? this.originalTitle,
      popularity: popularity ?? this.popularity,
      video: video ?? this.video,
    );
  }

  // Helper methods for UI
  String get fullPosterUrl {
    if (posterPath == null || posterPath!.isEmpty) return '';
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }

  String get fullBackdropUrl {
    if (backdropPath == null || backdropPath!.isEmpty) return '';
    return 'https://image.tmdb.org/t/p/w780$backdropPath';
  }

  String get formattedRating => voteAverage.toStringAsFixed(1);

  String get formattedYear {
    if (releaseDate.isEmpty) return '';
    try {
      final date = DateTime.parse(releaseDate);
      return date.year.toString();
    } catch (e) {
      return '';
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Movie &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          overview == other.overview &&
          posterPath == other.posterPath &&
          backdropPath == other.backdropPath &&
          releaseDate == other.releaseDate &&
          voteAverage == other.voteAverage &&
          voteCount == other.voteCount &&
          adult == other.adult &&
          genreIds.toString() == other.genreIds.toString() &&
          originalLanguage == other.originalLanguage &&
          originalTitle == other.originalTitle &&
          popularity == other.popularity &&
          video == other.video;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      overview.hashCode ^
      posterPath.hashCode ^
      backdropPath.hashCode ^
      releaseDate.hashCode ^
      voteAverage.hashCode ^
      voteCount.hashCode ^
      adult.hashCode ^
      genreIds.hashCode ^
      originalLanguage.hashCode ^
      originalTitle.hashCode ^
      popularity.hashCode ^
      video.hashCode;
}
