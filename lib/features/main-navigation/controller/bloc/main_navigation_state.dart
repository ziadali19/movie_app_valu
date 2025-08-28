part of 'main_navigation_bloc.dart';

class MainNavigationState {
  final int currentIndex;

  MainNavigationState({this.currentIndex = 0});

  MainNavigationState copyWith({int? currentIndex}) {
    return MainNavigationState(currentIndex: currentIndex ?? this.currentIndex);
  }
}
