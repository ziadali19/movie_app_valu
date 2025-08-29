abstract class SearchEvent {}

/// Search for movies with a query
class SearchMoviesEvent extends SearchEvent {
  final String query;

  SearchMoviesEvent({required this.query});
}

/// Load more search results for pagination
class LoadMoreSearchResultsEvent extends SearchEvent {}

/// Clear search results and query
class ClearSearchEvent extends SearchEvent {}

/// Retry search after an error
class RetrySearchEvent extends SearchEvent {}
