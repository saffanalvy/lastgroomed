part of 'shave_cubit.dart';

abstract class ShaveState {}

class ShaveInitial extends ShaveState {}

class ShaveLoadingState extends ShaveState {}

//Passing error message though ShaveErrorState
class ShaveErrorState extends ShaveState {
  final String message;
  ShaveErrorState(this.message);
}

//ShaveLoadedState passes the entire Shave EventList (calendar)
class ShaveLoadedState extends ShaveState {
  final EventList<Event> shaveEventList;
  ShaveLoadedState(this.shaveEventList);
}

//Based on SetShaveState, marked or unmarked snackbar is shown
class SetShaveState extends ShaveState {
  final bool marking;
  SetShaveState(this.marking);
}
