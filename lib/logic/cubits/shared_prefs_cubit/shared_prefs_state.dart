part of 'shared_prefs_cubit.dart';

abstract class SharedPrefsState {}

class InitialState extends SharedPrefsState {}

class LoadingState extends SharedPrefsState {}

//Passing error message though ErrorState
class ErrorState extends SharedPrefsState {
  final String message;
  ErrorState(this.message);
}

//Passing gender though InitialDataSavedState
class InitialDataSavedState extends SharedPrefsState {
  final String gender;
  InitialDataSavedState(this.gender);
}

//Passing gender & isDark values though FetchPrefsState
class FetchPrefsState extends SharedPrefsState {
  final String? gender;
  final bool? isDark;
  FetchPrefsState(this.gender, this.isDark);
}
