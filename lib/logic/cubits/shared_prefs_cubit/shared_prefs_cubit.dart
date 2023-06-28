import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/shared_prefs.dart';

part 'shared_prefs_state.dart';

class SharedPrefsCubit extends Cubit<SharedPrefsState> {
  SharedPrefsCubit() : super(InitialState());

  //Getting Shared Preferences from SharedPrefs class and
  //Emitting gender and isDark preferences though FetchPrefsState
  void getPrefs() {
    //Getting gender value
    String gender = SharedPrefs.getGender;
    //Getting isDark value
    bool isDark = SharedPrefs.getIsDark;

    //Setting gender value as male if gender is empty
    gender = (gender.isNotEmpty) ? gender : "male";

    //Emitting gender & isDark though FetchPrefsState
    emit(FetchPrefsState(gender, isDark));
  }

  //Getting SharedPrefs data then
  //Setting new gender value and finally
  //Emitting gender and isDark preferences though FetchPrefsState
  void setSettingsGenderPreferences(String gender) async {
    emit(LoadingState());
    try {
      //Setting new gender value
      SharedPrefs.setGender(gender);

      //Getting isDark value
      final isDark = SharedPrefs.getIsDark;

      //Emitting gender & isDark though FetchPrefsState
      emit(FetchPrefsState(gender, isDark));
    } catch (e) {
      //Emitting error state with message
      emit(ErrorState("Error updating gender to $gender"));
    }
  }

  //Getting Shared Preferences data then
  //Setting new isDark value and finally
  //Emitting gender and isDark preferences though FetchPrefsState
  void setSettingsIsDarkPreferences(bool isDark) async {
    emit(LoadingState());
    try {
      //Setting new isDark value
      SharedPrefs.setIsDark(isDark);

      //Getting gender value
      final gender = SharedPrefs.getGender;

      //Emitting gender & isDark though FetchPrefsState
      emit(FetchPrefsState(gender, isDark));
    } catch (e) {
      //Emitting error state with message
      emit(ErrorState(
          "Error updating theme mode to ${(isDark) ? 'Dark' : 'Light'}"));
    }
  }

  //For first time launch of Last Groomed app, set selected gender and
  //Get system's theme mode if light or dark and then based on these
  //Set gender and isDark values to Shared Preferences and
  //Emit InitialDataSavedState
  void setInitialPreferences(String gender) async {
    //Emit loading state
    emit(LoadingState());
    try {
      //Setting new gender value
      SharedPrefs.setGender(gender);

      //Check system theme mode's brightness of light/dark mode and
      //Get if light/dark mode
      var brightness =
          SchedulerBinding.instance.platformDispatcher.platformBrightness;
      bool isDark = brightness == Brightness.dark;

      //Setting new isDark value
      SharedPrefs.setIsDark(isDark);

      //Emitting gender through InitialDataSavedState so that
      //Welcome snackbar can get gender color
      emit(InitialDataSavedState(gender));
    } catch (e) {
      //Emitting error state with message
      emit(ErrorState("Error updating your gender"));
    }
  }
}
