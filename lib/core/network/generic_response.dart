class ApiResponse<T> {
  final int? status;
  final bool success;
  final int? page;
  final T? results;
  final int? totalPages;
  final int? totalResults;

  ApiResponse({
    this.status,
    this.success = false,
    this.page,
    this.results,
    this.totalPages,
    this.totalResults,
  });

  // Factory for TMDB paginated responses - T should be List<ItemType>
  factory ApiResponse.fromTMDBPaginated({
    required Map<String, dynamic> json,
    required T results, // Pass the constructed List<ItemType> as T
    required int statusCode,
  }) {
    return ApiResponse<T>(
      status: statusCode == 200 ? 0 : 1,
      success: statusCode == 200,
      page: json['page'] as int?,
      results: results, // T can be List<Movie>, List<SearchResult>, etc.
      totalPages: json['total_pages'] as int?,
      totalResults: json['total_results'] as int?,
    );
  }

  // Factory for TMDB single item responses - T is the single object
  factory ApiResponse.fromTMDBSingle({
    required T results, // Pass the single object as T
    required int statusCode,
  }) {
    return ApiResponse<T>(
      status: statusCode == 200 ? 0 : 1,
      success: statusCode == 200,
      results: results, // T can be Movie, MovieDetails, etc.
    );
  }

  // Factory for error responses
  factory ApiResponse.error({required String errorMessage, int? statusCode}) {
    return ApiResponse<T>(
      status: 1, // 1 = error in your pattern
      success: false,
    );
  }

  // Helper getters
  bool get isSuccess => success && results != null;
  bool get hasError => !success;

  // TMDB-specific helpers
  bool get hasPagination => page != null && totalPages != null;
  bool get hasNextPage => hasPagination && page! < totalPages!;
  bool get hasPreviousPage => hasPagination && page! > 1;
  int get nextPage => hasNextPage ? page! + 1 : page!;

  // Flexible results helper - works for both List<T> and single T
  bool get hasResults {
    if (results == null) return false;
    if (results is List) return (results as List).isNotEmpty;
    return true; // Single object exists
  }

  // Get results as List<T> (for paginated responses)
  List<dynamic>? get resultsList {
    if (results is List) return results as List<dynamic>;
    return null;
  }

  // Get results as single object (for single item responses)
  T? get singleResult => results;
}
