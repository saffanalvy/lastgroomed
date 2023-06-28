part of 'armpit_cubit.dart';

abstract class ArmpitState {}

class ArmpitInitial extends ArmpitState {}

class ArmpitLoadingState extends ArmpitState {}

//Passing error message though ArmpitErrorState
class ArmpitErrorState extends ArmpitState {
  final String message;
  ArmpitErrorState(this.message);
}

//ArmpitLoadedState passes the entire Armpit EventList (calendar)
class ArmpitLoadedState extends ArmpitState {
  final EventList<Event> armpitEventList;
  ArmpitLoadedState(this.armpitEventList);
}

//Based on SetArmpitState, marked or unmarked snackbar is shown
class SetArmpitState extends ArmpitState {
  final bool marking;
  SetArmpitState(this.marking);
}
