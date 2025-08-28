part of 'main_navigation_bloc.dart';

@immutable
sealed class MainNavigationEvent {}

class ChangeNavBarTabEvent extends MainNavigationEvent {
  final int index;

  ChangeNavBarTabEvent({required this.index});
}
