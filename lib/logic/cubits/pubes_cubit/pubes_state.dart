part of 'pubes_cubit.dart';

abstract class PubesState {}

class PubesInitial extends PubesState {}

class PubesLoadingState extends PubesState {}

//Passing error message though PubesErrorState
class PubesErrorState extends PubesState {
  final String message;
  PubesErrorState(this.message);
}

//PubesLoadedState passes the entire Pubes EventList (calendar)
class PubesLoadedState extends PubesState {
  final EventList<Event> pubesEventList;
  PubesLoadedState(this.pubesEventList);
}

//Based on SetPubesState, marked or unmarked snackbar is shown
class SetPubesState extends PubesState {
  final bool marking;
  SetPubesState(this.marking);
}
