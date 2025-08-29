import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app_valu/core/widgets/search_bar.dart';
import '../../controller/bloc/search_bloc.dart';
import '../../controller/bloc/search_event.dart';
import '../../controller/bloc/search_state.dart';

class SearchHeader extends StatelessWidget {
  final TextEditingController searchController;

  const SearchHeader({super.key, required this.searchController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return CustomSearchBar(
          controller: searchController,
          hintText: 'Search for movies...',
          onChanged: (query) {
            context.read<SearchBloc>().add(SearchMoviesEvent(query: query));
          },
          onClear: () {
            searchController.clear();
            context.read<SearchBloc>().add(ClearSearchEvent());
          },
          isSearching: state.isSearching,
        );
      },
    );
  }
}
