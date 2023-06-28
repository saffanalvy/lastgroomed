part of 'nails_cubit.dart';

abstract class NailsState {}

class NailsInitial extends NailsState {}

class NailsLoadingState extends NailsState {}

//Passing error message though NailsErrorState
class NailsErrorState extends NailsState {
  final String message;
  NailsErrorState(this.message);
}

//NailsLoadedState passes the entire Nails EventList (calendar)
class NailsLoadedState extends NailsState {
  final EventList<Event> nailsEventList;
  NailsLoadedState(this.nailsEventList);
}

//Based on SetNailsState, marked or unmarked snackbar is shown
class SetNailsState extends NailsState {
  final bool marking;
  SetNailsState(this.marking);
}
