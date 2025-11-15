import 'package:movie_app_valu/features/movie_details/domain/entities/movie_details_entity.dart';

class GenreModel extends Genere {
  const GenreModel({required super.id, required super.name});

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GenreModel && other.id == id && other.name == name;
  }

  @override
  int get hashCode => Object.hash(id, name);
}

class ProductionCompanyModel extends ProductionCompany {
  const ProductionCompanyModel({
    required super.id,
    required super.name,
    required super.originCountry,
    super.logoPath,
  });

  factory ProductionCompanyModel.fromJson(Map<String, dynamic> json) {
    return ProductionCompanyModel(
      id: json['id'] as int? ?? 0,
      logoPath: json['logo_path'] as String?,
      name: json['name'] as String? ?? '',
      originCountry: json['origin_country'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'logo_path': logoPath,
      'name': name,
      'origin_country': originCountry,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductionCompanyModel &&
        other.id == id &&
        other.logoPath == logoPath &&
        other.name == name &&
        other.originCountry == originCountry;
  }

  @override
  int get hashCode => Object.hash(id, logoPath, name, originCountry);
}

class ProductionCountryModel extends ProductionCountry {
  const ProductionCountryModel({required super.iso31661, required super.name});

  factory ProductionCountryModel.fromJson(Map<String, dynamic> json) {
    return ProductionCountryModel(
      iso31661: json['iso_3166_1'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'iso_3166_1': iso31661, 'name': name};
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductionCountryModel &&
        other.iso31661 == iso31661 &&
        other.name == name;
  }

  @override
  int get hashCode => Object.hash(iso31661, name);
}

class SpokenLanguageModel extends SpokenLanguage {
  const SpokenLanguageModel({
    required super.englishName,
    required super.iso6391,
    required super.name,
  });

  factory SpokenLanguageModel.fromJson(Map<String, dynamic> json) {
    return SpokenLanguageModel(
      englishName: json['english_name'] as String? ?? '',
      iso6391: json['iso_639_1'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'english_name': englishName, 'iso_639_1': iso6391, 'name': name};
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SpokenLanguageModel &&
        other.englishName == englishName &&
        other.iso6391 == iso6391 &&
        other.name == name;
  }

  @override
  int get hashCode => Object.hash(englishName, iso6391, name);
}

class MovieDetailsModel extends MovieDetails {
  MovieDetailsModel({
    required super.id,
    required super.title,
    required super.overview,
    required super.posterPath,
    required super.backdropPath,
    required super.releaseDate,
    required super.voteAverage,
    required super.voteCount,
    required super.runtime,
    required super.genres,
    required super.originalLanguage,
    required super.originalTitle,
    required super.popularity,
    required super.adult,
    required super.video,
    required super.tagline,
    required super.status,
    required super.budget,
    required super.revenue,
    required super.homepage,
    required super.imdbId,
    required super.originCountry,
    required super.productionCompanies,
    required super.productionCountries,
    required super.spokenLanguages,
  });

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailsModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      releaseDate: json['release_date'] as String? ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] as int? ?? 0,
      runtime: json['runtime'] as int? ?? 0,
      genres:
          (json['genres'] as List<dynamic>?)
              ?.map(
                (genreJson) =>
                    GenreModel.fromJson(genreJson as Map<String, dynamic>),
              )
              .toList() ??
          [],
      originalLanguage: json['original_language'] as String? ?? '',
      originalTitle: json['original_title'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      adult: json['adult'] as bool? ?? false,
      video: json['video'] as bool? ?? false,
      tagline: json['tagline'] as String?,
      status: json['status'] as String? ?? '',
      budget: json['budget'] as int?,
      revenue: json['revenue'] as int?,
      homepage: json['homepage'] as String?,
      imdbId: json['imdb_id'] as String?,
      originCountry:
          (json['origin_country'] as List<dynamic>?)
              ?.map((country) => country as String)
              .toList() ??
          [],
      productionCompanies:
          (json['production_companies'] as List<dynamic>?)
              ?.map(
                (companyJson) => ProductionCompanyModel.fromJson(
                  companyJson as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      productionCountries:
          (json['production_countries'] as List<dynamic>?)
              ?.map(
                (countryJson) => ProductionCountryModel.fromJson(
                  countryJson as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      spokenLanguages:
          (json['spoken_languages'] as List<dynamic>?)
              ?.map(
                (languageJson) => SpokenLanguageModel.fromJson(
                  languageJson as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
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
      'runtime': runtime,
      'genres': genres.map((genre) => (genre as GenreModel).toJson()).toList(),
      'original_language': originalLanguage,
      'original_title': originalTitle,
      'popularity': popularity,
      'adult': adult,
      'video': video,
      'tagline': tagline,
      'status': status,
      'budget': budget,
      'revenue': revenue,

      'homepage': homepage,
      'imdb_id': imdbId,
      'origin_country': originCountry,
      'production_companies': productionCompanies
          .map((company) => (company as ProductionCompanyModel).toJson())
          .toList(),
      'production_countries': productionCountries
          .map((country) => (country as ProductionCountryModel).toJson())
          .toList(),
      'spoken_languages': spokenLanguages
          .map((language) => (language as SpokenLanguageModel).toJson())
          .toList(),
    };
  }

  // Helper getters
  String get fullPosterUrl => 'https://image.tmdb.org/t/p/w500$posterPath';
  String get fullBackdropUrl => 'https://image.tmdb.org/t/p/w1280$backdropPath';

  String get formattedRuntime {
    if (runtime <= 0) return 'N/A';
    final hours = runtime ~/ 60;
    final minutes = runtime % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  String get genresText => genres.map((genre) => genre.name).join(', ');

  String get productionCompaniesText =>
      productionCompanies.map((company) => company.name).join(', ');

  String get productionCountriesText =>
      productionCountries.map((country) => country.name).join(', ');

  String get spokenLanguagesText =>
      spokenLanguages.map((language) => language.englishName).join(', ');

  String get originCountryText => originCountry.join(', ');

  String get releaseYear {
    if (releaseDate.isEmpty) return 'N/A';
    try {
      return DateTime.parse(releaseDate).year.toString();
    } catch (e) {
      return 'N/A';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MovieDetailsModel &&
        other.id == id &&
        other.title == title &&
        other.overview == overview &&
        other.posterPath == posterPath &&
        other.backdropPath == backdropPath &&
        other.releaseDate == releaseDate &&
        other.voteAverage == voteAverage &&
        other.voteCount == voteCount &&
        other.runtime == runtime &&
        other.genres.length == genres.length &&
        other.originalLanguage == originalLanguage &&
        other.originalTitle == originalTitle &&
        other.popularity == popularity &&
        other.adult == adult &&
        other.video == video &&
        other.tagline == tagline &&
        other.status == status &&
        other.budget == budget &&
        other.revenue == revenue &&
        other.homepage == homepage &&
        other.imdbId == imdbId &&
        other.originCountry.length == originCountry.length &&
        other.productionCompanies.length == productionCompanies.length &&
        other.productionCountries.length == productionCountries.length &&
        other.spokenLanguages.length == spokenLanguages.length;
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    overview,
    posterPath,
    backdropPath,
    releaseDate,
    voteAverage,
    voteCount,
    runtime,
    genres.length,
    originalLanguage,
    originalTitle,
    popularity,
    adult,
    video,
    tagline,
    status,
    budget,
    revenue,
    Object.hash(
      homepage,
      imdbId,
      originCountry.length,
      productionCompanies.length,
      productionCountries.length,
      spokenLanguages.length,
    ),
  );
}
