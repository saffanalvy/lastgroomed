part of 'haircut_cubit.dart';

abstract class HaircutState {}

class HaircutInitial extends HaircutState {}

class HaircutLoadingState extends HaircutState {}

//Passing error message though HaircutErrorState
class HaircutErrorState extends HaircutState {
  final String message;
  HaircutErrorState(this.message);
}

//HaircutLoadedState passes the entire Haircut EventList (calendar)
class HaircutLoadedState extends HaircutState {
  final EventList<Event> haircutEventList;
  HaircutLoadedState(this.haircutEventList);
}

//Based on SetHaircutState, marked or unmarked snackbar is shown
class SetHaircutState extends HaircutState {
  final bool marking;
  SetHaircutState(this.marking);
}
