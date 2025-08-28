import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'main_navigation_event.dart';
part 'main_navigation_state.dart';

class MainNavigationBloc
    extends Bloc<MainNavigationEvent, MainNavigationState> {
  MainNavigationBloc() : super(MainNavigationState()) {
    on<ChangeNavBarTabEvent>(_onChangeNavBarTab);
  }

  Future<void> _onChangeNavBarTab(
    ChangeNavBarTabEvent event,
    Emitter<MainNavigationState> emit,
  ) async {
    emit(state.copyWith(currentIndex: event.index));
  }
}
