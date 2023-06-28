import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import '../../../data/repositories/shave_repository.dart';
import '../../../utils/colors.dart';
import '../../../utils/strings.dart';

part 'shave_state.dart';

class ShaveCubit extends Cubit<ShaveState> {
  //Shave Repository instance
  final ShaveRepository _shaveRepo = ShaveRepository();

  ShaveCubit() : super(ShaveInitial());

  //Getting all the Events (DateTime as String) from Shave Box and then
  //Generating EventList<Event>? object from the Events list
  //By parsing DateTime from String and adding Event objects in
  //EventList<Event>? object also with Event Icon widget and finally
  //Emitting the complete EventList<Event>? object through ShaveLoadedState
  //To pass it to ShaveScreen to markedDatesMap property of the
  //CalendarCarousel (from Flutter Calendar Carousel package)
  void getShaveEventList(String? gender, bool? isDark) async {
    //Emitting loading state
    emit(ShaveLoadingState());

    try {
      //Initializing a not null but empty EventList
      EventList<Event> shaveEventList = EventList<Event>(events: {});
      //Getting all Shave Events from ShaveBox: DateTime as String
      List<String>? allShaveEvents = await _shaveRepo.getAllShaveEvents();

      //If there is existing events inside ShaveBox
      if (allShaveEvents != null) {
        //For all Date(DateTime as String) inside allShaveEvents list
        //From ShaveBox
        for (var date in allShaveEvents) {
          //Add Event by parsing the current Date (DateTime.parse) in the loop
          shaveEventList.add(
            DateTime.parse(date),
            Event(
              date: DateTime.parse(date),
              title: 'Shave',
              dot: _getEventIcon(gender, isDark),
            ),
          );
        }
        //Finally emit the EventList<Event>? to ShaveScreen by using
        //ShaveLoadedState
        emit(ShaveLoadedState(shaveEventList));
      }
    } catch (e) {
      //Emitting error state with message
      emit(ShaveErrorState("Error loading Shave events"));
    }
  }

  //Add or Remove Shave Event based on the tapped Date
  void setShaveEvent(DateTime date) async {
    try {
      //Getting all Shave Events from ShaveBox: DateTime as String
      List<String>? allShaveEvents = await _shaveRepo.getAllShaveEvents();

      //If Shave EventList is not empty
      if (allShaveEvents != null) {
        //If the tapped Date already exists inside the Shave EventList
        bool isExist = allShaveEvents.contains(date.toString());
        if (isExist) {
          //Remove tapped Date from Shave EventList
          _shaveRepo.removeShaveEvent(date.toString());

          //Emit state to show Unmarked snackbar
          emit(SetShaveState(false));
          return;
        }
      }

      //Add tapped Date to ShaveBox
      _shaveRepo.addShaveEvent(date.toString());
      //Emit state to show Marked snackbar
      emit(SetShaveState(true));
    } catch (e) {
      //Emitting error state with message
      emit(ShaveErrorState("Error updating Shave event"));
    }
  }

  //Setting up Event Icons based on Gender & Light/Dark mode and
  //Returning the Event Icon Widget
  Widget _getEventIcon(String? gender, bool? isDark) {
    return Container(
      decoration: BoxDecoration(
          color: (isDark != null && isDark == true)
              ? constLightTextColor
              : constDarkTextColor,
          borderRadius: const BorderRadius.all(Radius.circular(1000)),
          border: Border.all(color: constBlueColor, width: 2.0)),
      child: CircleAvatar(
        radius: (gender == kFemaleText) ? 15 : 14,
        backgroundColor: constTransparentColor,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Image.asset(
            kEventIconsPath[
                (gender == kFemaleText) ? 2 : 1], //Trimmer or Razor icon
            color: (gender == kFemaleText) ? constFemaleColor : constMaleColor,
          ),
        ),
      ),
    );
  }

  //Close ShaveBox while closing ShaveCubit
  @override
  Future<void> close() {
    _shaveRepo.close();
    return super.close();
  }
}
