class Genere {
  final int id;
  final String name;
  const Genere({required this.id, required this.name});
}

class ProductionCompany {
  final int id;
  final String name;
  final String originCountry;
  final String? logoPath;
  const ProductionCompany({
    required this.id,
    required this.name,
    required this.originCountry,
    this.logoPath,
  });
}

class ProductionCountry {
  final String iso31661;
  final String name;
  const ProductionCountry({required this.iso31661, required this.name});
}

class SpokenLanguage {
  final String englishName;
  final String iso6391;
  final String name;
  const SpokenLanguage({
    required this.englishName,
    required this.iso6391,
    required this.name,
  });
}

class MovieDetails {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final String releaseDate;
  final double voteAverage;
  final int voteCount;
  final int runtime;
  final List<Genere> genres;
  final String originalLanguage;
  final String originalTitle;
  final double popularity;
  final bool adult;
  final bool video;
  final String? tagline;
  final String status;
  final int? budget;
  final int? revenue;
  final String? homepage;
  final String? imdbId;
  final List<String> originCountry;
  final List<ProductionCompany> productionCompanies;
  final List<ProductionCountry> productionCountries;
  final List<SpokenLanguage> spokenLanguages;
  const MovieDetails({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.runtime,
    required this.genres,
    required this.originalLanguage,
    required this.originalTitle,
    required this.popularity,
    required this.adult,
    required this.video,
    required this.tagline,
    required this.status,
    required this.budget,
    required this.revenue,
    required this.homepage,
    required this.imdbId,
    required this.originCountry,
    required this.productionCompanies,
    required this.productionCountries,
    required this.spokenLanguages,
  });
}
