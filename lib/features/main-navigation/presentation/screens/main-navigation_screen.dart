import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app_valu/core/theming/colors.dart';
import 'package:movie_app_valu/features/movies/presentation/screens/movies_list_screen.dart';

import '../../controller/bloc/main_navigation_bloc.dart';
import '../components/bottom_nav_bar.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainNavigationBloc, MainNavigationState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: ColorsManager.background,
          body: IndexedStack(
            index: state.currentIndex,
            children: [
              // Tab 1: Movies (Popular)
              const MoviesListScreen(),

              // Tab 2: Search (Placeholder for now)
              const SizedBox.shrink(),

              // Tab 3: Favorites (Placeholder for now)
              const SizedBox.shrink(),
            ],
          ),
          bottomNavigationBar: BottomNavBar(
            index: state.currentIndex,
            onTap: (index) {
              context.read<MainNavigationBloc>().add(
                ChangeNavBarTabEvent(index: index),
              );
            },
          ),
        );
      },
    );
  }
}
