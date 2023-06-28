import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import '../../../data/repositories/pubes_repository.dart';
import '../../../utils/colors.dart';
import '../../../utils/strings.dart';

part 'pubes_state.dart';

class PubesCubit extends Cubit<PubesState> {
  //Pubes Repository instance
  final PubesRepository _pubesRepo = PubesRepository();

  PubesCubit() : super(PubesInitial());

  //Getting all the Events (DateTime as String) from Pubes Box and then
  //Generating EventList<Event>? object from the Events list
  //By parsing DateTime from String and adding Event objects in
  //EventList<Event>? object also with Event Icon widget and finally
  //Emitting the complete EventList<Event>? object through PubesLoadedState
  //To pass it to PubesScreen to markedDatesMap property of the
  //CalendarCarousel (from Flutter Calendar Carousel package)
  void getPubesEventList(String? gender, bool? isDark) async {
    //Emitting loading state
    emit(PubesLoadingState());

    try {
      //Initializing a not null but empty EventList
      EventList<Event> pubesEventList = EventList<Event>(events: {});
      //Getting all Pubes Events from PubesBox: DateTime as String
      List<String>? allPubesEvents = await _pubesRepo.getAllPubesEvents();

      //If there is existing events inside PubesBox
      if (allPubesEvents != null) {
        //For all Date(DateTime as String) inside allPubesEvents list
        //From PubesBox
        for (var date in allPubesEvents) {
          //Add Event by parsing the current Date (DateTime.parse) in the loop
          pubesEventList.add(
            DateTime.parse(date),
            Event(
              date: DateTime.parse(date),
              title: 'Pubes',
              dot: _getEventIcon(gender, isDark),
            ),
          );
        }
        //Finally emit the EventList<Event>? to PubesScreen by using
        //PubesLoadedState
        emit(PubesLoadedState(pubesEventList));
      }
    } catch (e) {
      //Emitting error state with message
      emit(PubesErrorState("Error loading Pubes events"));
    }
  }

  //Add or Remove Pubes Event based on the tapped Date
  void setPubesEvent(DateTime date) async {
    try {
      //Getting all Pubes Events from PubesBox: DateTime as String
      List<String>? allPubesEvents = await _pubesRepo.getAllPubesEvents();

      //If Pubes EventList is not empty
      if (allPubesEvents != null) {
        //If the tapped Date already exists inside the Pubes EventList
        bool isExist = allPubesEvents.contains(date.toString());
        if (isExist) {
          //Remove tapped Date from Pubes EventList
          _pubesRepo.removePubesEvent(date.toString());

          //Emit state to show Unmarked snackbar
          emit(SetPubesState(false));
          return;
        }
      }

      //Add tapped Date to PubesBox
      _pubesRepo.addPubesEvent(date.toString());
      //Emit state to show Marked snackbar
      emit(SetPubesState(true));
    } catch (e) {
      //Emitting error state with message
      emit(PubesErrorState("Error updating Pubes event"));
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
        radius: 15,
        backgroundColor: constTransparentColor,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Image.asset(
            kEventIconsPath[2], //Razor icon
            color: (gender == kFemaleText) ? constFemaleColor : constMaleColor,
          ),
        ),
      ),
    );
  }

  //Close PubesBox while closing PubesCubit
  @override
  Future<void> close() {
    _pubesRepo.close();
    return super.close();
  }
}
