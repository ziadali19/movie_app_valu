import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app_valu/core/network/failure_model.dart';
import 'package:movie_app_valu/core/network/generic_response.dart';
import 'package:movie_app_valu/features/movie_details/controller/bloc/movie_details_bloc.dart';
import 'package:movie_app_valu/features/movie_details/controller/bloc/movie_details_event.dart';
import 'package:movie_app_valu/features/movie_details/controller/bloc/movie_details_state.dart';
import 'package:movie_app_valu/features/movie_details/data/models/movie_details.dart';
import 'package:movie_app_valu/features/movie_details/data/repository/movie_details_repository.dart';

import 'movie_details_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<BaseMovieDetailsRepository>()])
void main() {
  group('MovieDetailsBloc Tests', () {
    late MockBaseMovieDetailsRepository mockRepository;
    late MovieDetailsBloc movieDetailsBloc;
    late MovieDetails testMovieDetails;
    late ApiResponse<MovieDetails> testApiResponse;

    setUp(() {
      mockRepository = MockBaseMovieDetailsRepository();
      movieDetailsBloc = MovieDetailsBloc(mockRepository);

      testMovieDetails = const MovieDetails(
        id: 1151334,
        title: 'Eenie Meanie',
        overview:
            'A former teenage getaway driver gets dragged back into her unsavory past when a former employer offers her a chance to save the life of her chronically unreliable ex-boyfriend.',
        posterPath: '/12Va3oO3oYUdOd75zM57Nx1976a.jpg',
        backdropPath: '/8jeDyvFQKgss36FbGAmGQVzPXlH.jpg',
        releaseDate: '2025-08-21',
        voteAverage: 6.684,
        voteCount: 79,
        runtime: 106,
        genres: [
          Genre(id: 53, name: 'Thriller'),
          Genre(id: 28, name: 'Action'),
        ],
        originalLanguage: 'en',
        originalTitle: 'Eenie Meanie',
        popularity: 807.1247,
        adult: false,
        video: false,
        tagline: 'He\'s her biggest blind spot.',
        status: 'Released',
        budget: 50000000,
        revenue: 0,
        homepage: 'https://www.20thcenturystudios.com/movies/eenie-meanie',
        imdbId: 'tt15514498',
        originCountry: ['US'],
        productionCompanies: [
          ProductionCompany(
            id: 127928,
            logoPath: '/h0rjX5vjW5r8yEnUBStFarjcLT4.png',
            name: '20th Century Studios',
            originCountry: 'US',
          ),
        ],
        productionCountries: [
          ProductionCountry(iso31661: 'US', name: 'United States of America'),
        ],
        spokenLanguages: [
          SpokenLanguage(
            englishName: 'English',
            iso6391: 'en',
            name: 'English',
          ),
        ],
      );

      testApiResponse = ApiResponse<MovieDetails>.fromTMDBSingle(
        results: testMovieDetails,
        statusCode: 200,
      );
    });

    tearDown(() {
      movieDetailsBloc.close();
    });

    group('Initial state', () {
      test('should have correct initial state', () {
        // Assert
        expect(movieDetailsBloc.state, const MovieDetailsState());
        expect(movieDetailsBloc.state.status, MovieDetailsStatus.initial);
        expect(movieDetailsBloc.state.movieDetails, null);
        expect(movieDetailsBloc.state.errorMessage, null);
        expect(movieDetailsBloc.state.movieId, null);
        expect(movieDetailsBloc.state.isInitial, true);
        expect(movieDetailsBloc.state.isLoading, false);
        expect(movieDetailsBloc.state.isSuccess, false);
        expect(movieDetailsBloc.state.hasError, false);
        expect(movieDetailsBloc.state.hasData, false);
      });
    });

    group('LoadMovieDetailsEvent', () {
      blocTest<MovieDetailsBloc, MovieDetailsState>(
        'should emit [loading, success] when repository returns success',
        build: () {
          when(
            mockRepository.getMovieDetails(movieId: 1151334),
          ).thenAnswer((_) async => Right(testApiResponse));
          return movieDetailsBloc;
        },
        act: (bloc) => bloc.add(LoadMovieDetailsEvent(movieId: 1151334)),
        expect: () => [
          isA<MovieDetailsState>()
              .having(
                (state) => state.status,
                'status',
                MovieDetailsStatus.loading,
              )
              .having((state) => state.movieId, 'movieId', 1151334)
              .having((state) => state.errorMessage, 'errorMessage', null)
              .having((state) => state.movieDetails, 'movieDetails', null),
          isA<MovieDetailsState>()
              .having(
                (state) => state.status,
                'status',
                MovieDetailsStatus.success,
              )
              .having(
                (state) => state.movieDetails,
                'movieDetails',
                testMovieDetails,
              )
              .having((state) => state.errorMessage, 'errorMessage', null)
              .having((state) => state.movieId, 'movieId', 1151334),
        ],
        verify: (_) {
          verify(mockRepository.getMovieDetails(movieId: 1151334)).called(1);
        },
      );

      blocTest<MovieDetailsBloc, MovieDetailsState>(
        'should emit [loading, error] when repository returns error',
        build: () {
          when(mockRepository.getMovieDetails(movieId: 1151334)).thenAnswer(
            (_) async =>
                Left(ApiErrorModel(message: 'Failed to load movie details')),
          );
          return movieDetailsBloc;
        },
        act: (bloc) => bloc.add(LoadMovieDetailsEvent(movieId: 1151334)),
        expect: () => [
          isA<MovieDetailsState>()
              .having(
                (state) => state.status,
                'status',
                MovieDetailsStatus.loading,
              )
              .having((state) => state.movieId, 'movieId', 1151334)
              .having((state) => state.errorMessage, 'errorMessage', null),
          isA<MovieDetailsState>()
              .having(
                (state) => state.status,
                'status',
                MovieDetailsStatus.error,
              )
              .having(
                (state) => state.errorMessage,
                'errorMessage',
                'Failed to load movie details',
              )
              .having((state) => state.movieDetails, 'movieDetails', null)
              .having((state) => state.movieId, 'movieId', 1151334),
        ],
        verify: (_) {
          verify(mockRepository.getMovieDetails(movieId: 1151334)).called(1);
        },
      );

      blocTest<MovieDetailsBloc, MovieDetailsState>(
        'should emit [loading, error] with default message when error message is null',
        build: () {
          when(
            mockRepository.getMovieDetails(movieId: 1151334),
          ).thenAnswer((_) async => Left(ApiErrorModel(message: null)));
          return movieDetailsBloc;
        },
        act: (bloc) => bloc.add(LoadMovieDetailsEvent(movieId: 1151334)),
        expect: () => [
          isA<MovieDetailsState>().having(
            (state) => state.status,
            'status',
            MovieDetailsStatus.loading,
          ),
          isA<MovieDetailsState>()
              .having(
                (state) => state.status,
                'status',
                MovieDetailsStatus.error,
              )
              .having(
                (state) => state.errorMessage,
                'errorMessage',
                'Failed to load movie details',
              ),
        ],
        verify: (_) {
          verify(mockRepository.getMovieDetails(movieId: 1151334)).called(1);
        },
      );

      blocTest<MovieDetailsBloc, MovieDetailsState>(
        'should handle different movie IDs correctly',
        build: () {
          final differentMovieDetails = testMovieDetails.copyWith(
            id: 99999,
            title: 'Different Movie',
          );
          final differentApiResponse = ApiResponse<MovieDetails>.fromTMDBSingle(
            results: differentMovieDetails,
            statusCode: 200,
          );

          when(
            mockRepository.getMovieDetails(movieId: 99999),
          ).thenAnswer((_) async => Right(differentApiResponse));
          return movieDetailsBloc;
        },
        act: (bloc) => bloc.add(LoadMovieDetailsEvent(movieId: 99999)),
        expect: () => [
          isA<MovieDetailsState>()
              .having(
                (state) => state.status,
                'status',
                MovieDetailsStatus.loading,
              )
              .having((state) => state.movieId, 'movieId', 99999),
          isA<MovieDetailsState>()
              .having(
                (state) => state.status,
                'status',
                MovieDetailsStatus.success,
              )
              .having(
                (state) => state.movieDetails?.id,
                'movieDetails.id',
                99999,
              )
              .having(
                (state) => state.movieDetails?.title,
                'movieDetails.title',
                'Different Movie',
              )
              .having((state) => state.movieId, 'movieId', 99999),
        ],
        verify: (_) {
          verify(mockRepository.getMovieDetails(movieId: 99999)).called(1);
        },
      );

      blocTest<MovieDetailsBloc, MovieDetailsState>(
        'should clear previous error when loading new movie details',
        build: () {
          when(
            mockRepository.getMovieDetails(movieId: 1151334),
          ).thenAnswer((_) async => Right(testApiResponse));
          return movieDetailsBloc;
        },
        seed: () => const MovieDetailsState(
          status: MovieDetailsStatus.error,
          errorMessage: 'Previous error',
          movieId: 999,
        ),
        act: (bloc) => bloc.add(LoadMovieDetailsEvent(movieId: 1151334)),
        expect: () => [
          isA<MovieDetailsState>()
              .having(
                (state) => state.status,
                'status',
                MovieDetailsStatus.loading,
              )
              .having((state) => state.errorMessage, 'errorMessage', null)
              .having((state) => state.movieId, 'movieId', 1151334),
          isA<MovieDetailsState>()
              .having(
                (state) => state.status,
                'status',
                MovieDetailsStatus.success,
              )
              .having(
                (state) => state.movieDetails,
                'movieDetails',
                testMovieDetails,
              )
              .having((state) => state.errorMessage, 'errorMessage', null),
        ],
        verify: (_) {
          verify(mockRepository.getMovieDetails(movieId: 1151334)).called(1);
        },
      );
    });

    group('RetryLoadingMovieDetailsEvent', () {
      blocTest<MovieDetailsBloc, MovieDetailsState>(
        'should dispatch LoadMovieDetailsEvent with the same movie ID',
        build: () {
          when(
            mockRepository.getMovieDetails(movieId: 1151334),
          ).thenAnswer((_) async => Right(testApiResponse));
          return movieDetailsBloc;
        },
        act: (bloc) =>
            bloc.add(RetryLoadingMovieDetailsEvent(movieId: 1151334)),
        expect: () => [
          isA<MovieDetailsState>()
              .having(
                (state) => state.status,
                'status',
                MovieDetailsStatus.loading,
              )
              .having((state) => state.movieId, 'movieId', 1151334),
          isA<MovieDetailsState>()
              .having(
                (state) => state.status,
                'status',
                MovieDetailsStatus.success,
              )
              .having(
                (state) => state.movieDetails,
                'movieDetails',
                testMovieDetails,
              ),
        ],
        verify: (_) {
          verify(mockRepository.getMovieDetails(movieId: 1151334)).called(1);
        },
      );

      blocTest<MovieDetailsBloc, MovieDetailsState>(
        'should handle retry after error correctly',
        build: () {
          when(
            mockRepository.getMovieDetails(movieId: 1151334),
          ).thenAnswer((_) async => Right(testApiResponse));
          return movieDetailsBloc;
        },
        seed: () => const MovieDetailsState(
          status: MovieDetailsStatus.error,
          errorMessage: 'Network error',
          movieId: 1151334,
        ),
        act: (bloc) =>
            bloc.add(RetryLoadingMovieDetailsEvent(movieId: 1151334)),
        expect: () => [
          isA<MovieDetailsState>()
              .having(
                (state) => state.status,
                'status',
                MovieDetailsStatus.loading,
              )
              .having((state) => state.movieId, 'movieId', 1151334)
              .having((state) => state.errorMessage, 'errorMessage', null),
          isA<MovieDetailsState>()
              .having(
                (state) => state.status,
                'status',
                MovieDetailsStatus.success,
              )
              .having(
                (state) => state.movieDetails,
                'movieDetails',
                testMovieDetails,
              )
              .having((state) => state.errorMessage, 'errorMessage', null),
        ],
        verify: (_) {
          verify(mockRepository.getMovieDetails(movieId: 1151334)).called(1);
        },
      );

      blocTest<MovieDetailsBloc, MovieDetailsState>(
        'should handle retry with different movie ID',
        build: () {
          final differentMovieDetails = testMovieDetails.copyWith(
            id: 99999,
            title: 'Different Movie',
          );
          final differentApiResponse = ApiResponse<MovieDetails>.fromTMDBSingle(
            results: differentMovieDetails,
            statusCode: 200,
          );

          when(
            mockRepository.getMovieDetails(movieId: 99999),
          ).thenAnswer((_) async => Right(differentApiResponse));
          return movieDetailsBloc;
        },
        seed: () => const MovieDetailsState(
          status: MovieDetailsStatus.error,
          errorMessage: 'Network error',
          movieId: 1151334,
        ),
        act: (bloc) => bloc.add(RetryLoadingMovieDetailsEvent(movieId: 99999)),
        expect: () => [
          isA<MovieDetailsState>()
              .having(
                (state) => state.status,
                'status',
                MovieDetailsStatus.loading,
              )
              .having((state) => state.movieId, 'movieId', 99999),
          isA<MovieDetailsState>()
              .having(
                (state) => state.status,
                'status',
                MovieDetailsStatus.success,
              )
              .having(
                (state) => state.movieDetails?.id,
                'movieDetails.id',
                99999,
              )
              .having(
                (state) => state.movieDetails?.title,
                'movieDetails.title',
                'Different Movie',
              ),
        ],
        verify: (_) {
          verify(mockRepository.getMovieDetails(movieId: 99999)).called(1);
        },
      );
    });

    group('State helper methods', () {
      test('should return correct helper values for initial state', () {
        // Act
        final state = const MovieDetailsState();

        // Assert
        expect(state.isInitial, true);
        expect(state.isLoading, false);
        expect(state.isSuccess, false);
        expect(state.hasError, false);
        expect(state.hasData, false);
      });

      test('should return correct helper values for loading state', () {
        // Act
        final state = const MovieDetailsState(
          status: MovieDetailsStatus.loading,
          movieId: 123,
        );

        // Assert
        expect(state.isInitial, false);
        expect(state.isLoading, true);
        expect(state.isSuccess, false);
        expect(state.hasError, false);
        expect(state.hasData, false);
      });

      test('should return correct helper values for success state', () {
        // Act
        final state = MovieDetailsState(
          status: MovieDetailsStatus.success,
          movieDetails: testMovieDetails,
          movieId: 123,
        );

        // Assert
        expect(state.isInitial, false);
        expect(state.isLoading, false);
        expect(state.isSuccess, true);
        expect(state.hasError, false);
        expect(state.hasData, true);
      });

      test('should return correct helper values for error state', () {
        // Act
        final state = const MovieDetailsState(
          status: MovieDetailsStatus.error,
          errorMessage: 'Error message',
          movieId: 123,
        );

        // Assert
        expect(state.isInitial, false);
        expect(state.isLoading, false);
        expect(state.isSuccess, false);
        expect(state.hasError, true);
        expect(state.hasData, false);
      });
    });

    group('Integration scenarios', () {
      blocTest<MovieDetailsBloc, MovieDetailsState>(
        'should handle multiple sequential movie loads correctly',
        build: () {
          when(
            mockRepository.getMovieDetails(movieId: 1151334),
          ).thenAnswer((_) async => Right(testApiResponse));

          final differentMovieDetails = testMovieDetails.copyWith(
            id: 99999,
            title: 'Different Movie',
          );
          final differentApiResponse = ApiResponse<MovieDetails>.fromTMDBSingle(
            results: differentMovieDetails,
            statusCode: 200,
          );
          when(
            mockRepository.getMovieDetails(movieId: 99999),
          ).thenAnswer((_) async => Right(differentApiResponse));

          return movieDetailsBloc;
        },
        act: (bloc) async {
          bloc.add(LoadMovieDetailsEvent(movieId: 1151334));
          await Future.delayed(const Duration(milliseconds: 100));
          bloc.add(LoadMovieDetailsEvent(movieId: 99999));
        },
        expect: () => [
          // First movie load
          isA<MovieDetailsState>()
              .having(
                (state) => state.status,
                'status',
                MovieDetailsStatus.loading,
              )
              .having((state) => state.movieId, 'movieId', 1151334),
          isA<MovieDetailsState>()
              .having(
                (state) => state.status,
                'status',
                MovieDetailsStatus.success,
              )
              .having(
                (state) => state.movieDetails?.id,
                'movieDetails.id',
                1151334,
              ),
          // Second movie load
          isA<MovieDetailsState>()
              .having(
                (state) => state.status,
                'status',
                MovieDetailsStatus.loading,
              )
              .having((state) => state.movieId, 'movieId', 99999),
          isA<MovieDetailsState>()
              .having(
                (state) => state.status,
                'status',
                MovieDetailsStatus.success,
              )
              .having(
                (state) => state.movieDetails?.id,
                'movieDetails.id',
                99999,
              )
              .having(
                (state) => state.movieDetails?.title,
                'movieDetails.title',
                'Different Movie',
              ),
        ],
        verify: (_) {
          verify(mockRepository.getMovieDetails(movieId: 1151334)).called(1);
          verify(mockRepository.getMovieDetails(movieId: 99999)).called(1);
        },
      );
    });
  });
}

extension MovieDetailsCopyWithTest on MovieDetails {
  MovieDetails copyWith({
    int? id,
    String? title,
    String? overview,
    String? posterPath,
    String? backdropPath,
    String? releaseDate,
    double? voteAverage,
    int? voteCount,
    int? runtime,
    List<Genre>? genres,
    String? originalLanguage,
    String? originalTitle,
    double? popularity,
    bool? adult,
    bool? video,
    String? tagline,
    String? status,
    int? budget,
    int? revenue,
    String? homepage,
    String? imdbId,
    List<String>? originCountry,
    List<ProductionCompany>? productionCompanies,
    List<ProductionCountry>? productionCountries,
    List<SpokenLanguage>? spokenLanguages,
  }) {
    return MovieDetails(
      id: id ?? this.id,
      title: title ?? this.title,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      releaseDate: releaseDate ?? this.releaseDate,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      runtime: runtime ?? this.runtime,
      genres: genres ?? this.genres,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      originalTitle: originalTitle ?? this.originalTitle,
      popularity: popularity ?? this.popularity,
      adult: adult ?? this.adult,
      video: video ?? this.video,
      tagline: tagline ?? this.tagline,
      status: status ?? this.status,
      budget: budget ?? this.budget,
      revenue: revenue ?? this.revenue,
      homepage: homepage ?? this.homepage,
      imdbId: imdbId ?? this.imdbId,
      originCountry: originCountry ?? this.originCountry,
      productionCompanies: productionCompanies ?? this.productionCompanies,
      productionCountries: productionCountries ?? this.productionCountries,
      spokenLanguages: spokenLanguages ?? this.spokenLanguages,
    );
  }
}
