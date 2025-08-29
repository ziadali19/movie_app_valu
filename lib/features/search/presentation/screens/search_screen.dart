import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/show_toast.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../controller/bloc/search_bloc.dart';
import '../../controller/bloc/search_event.dart';
import '../../controller/bloc/search_state.dart';
import '../components/search_empty_state.dart';
import '../components/search_header.dart';
import '../components/search_initial_state.dart';
import '../components/search_results.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController = ScrollController();

    // Add scroll listener for infinite scroll
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      context.read<SearchBloc>().add(LoadMoreSearchResultsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Movies')),
      backgroundColor: ColorsManager.background,
      body: SafeArea(
        child: Column(
          children: [
            SearchHeader(searchController: _searchController),
            Expanded(child: _buildSearchBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBody() {
    return BlocConsumer<SearchBloc, SearchState>(
      listener: (context, state) {
        if (state.hasError && state.errorMessage != null) {
          showSnackBar(state.errorMessage!, context, false);
        }
      },
      builder: (context, state) {
        if (state.isInitial) {
          return const SearchInitialState();
        }

        if (state.isSearching && !state.hasResults) {
          return const AppLoading();
        }

        if (state.hasError && !state.hasResults) {
          return AppErrorView(
            message: state.errorMessage ?? 'Search failed',
            onRetry: () {
              context.read<SearchBloc>().add(RetrySearchEvent());
            },
          );
        }

        if (state.isEmpty) {
          return SearchEmptyState(query: state.query);
        }

        if (state.hasResults) {
          return SearchResults(
            state: state,
            scrollController: _scrollController,
          );
        }

        return const SearchInitialState();
      },
    );
  }
}
