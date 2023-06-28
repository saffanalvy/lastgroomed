import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import '../../../data/repositories/armpit_repository.dart';
import '../../../utils/colors.dart';
import '../../../utils/strings.dart';

part 'armpit_state.dart';

class ArmpitCubit extends Cubit<ArmpitState> {
  //Armpit Repository instance
  final ArmpitRepository _armpitRepo = ArmpitRepository();

  ArmpitCubit() : super(ArmpitInitial());

  //Getting all the Events (DateTime as String) from Armpit Box and then
  //Generating EventList<Event>? object from the Events list
  //By parsing DateTime from String and adding Event objects in
  //EventList<Event>? object also with Event Icon widget and finally
  //Emitting the complete EventList<Event>? object through ArmpitLoadedState
  //To pass it to ArmpitScreen to markedDatesMap property of the
  //CalendarCarousel (from Flutter Calendar Carousel package)
  void getArmpitEventList(String? gender, bool? isDark) async {
    //Emitting loading state
    emit(ArmpitLoadingState());

    try {
      //Initializing a not null but empty EventList
      EventList<Event> armpitEventList = EventList<Event>(events: {});
      //Getting all Armpit Events from ArmpitBox: DateTime as String
      List<String>? allArmpitEvents = await _armpitRepo.getAllArmpitEvents();

      //If there is existing events inside ArmpitBox
      if (allArmpitEvents != null) {
        //For all Date(DateTime as String) inside allArmpitEvents list
        //From ArmpitBox
        for (var date in allArmpitEvents) {
          //Add Event by parsing the current Date (DateTime.parse) in the loop
          armpitEventList.add(
            DateTime.parse(date),
            Event(
              date: DateTime.parse(date),
              title: 'Armpit',
              dot: _getEventIcon(gender, isDark),
            ),
          );
        }
        //Finally emit the EventList<Event>? to ArmpitScreen by using
        //ArmpitLoadedState
        emit(ArmpitLoadedState(armpitEventList));
      }
    } catch (e) {
      //Emitting error state with message
      emit(ArmpitErrorState("Error loading Armpit events"));
    }
  }

  //Add or Remove Armpit Event based on the tapped Date
  void setArmpitEvent(DateTime date) async {
    try {
      //Getting all Armpit Events from ArmpitBox: DateTime as String
      List<String>? allArmpitEvents = await _armpitRepo.getAllArmpitEvents();

      //If Armpit EventList is not empty
      if (allArmpitEvents != null) {
        //If the tapped Date already exists inside the Armpit EventList
        bool isExist = allArmpitEvents.contains(date.toString());
        if (isExist) {
          //Remove tapped Date from Armpit EventList
          _armpitRepo.removeArmpitEvent(date.toString());

          //Emit state to show Unmarked snackbar
          emit(SetArmpitState(false));
          return;
        }
      }

      //Add tapped Date to ArmpitBox
      _armpitRepo.addArmpitEvent(date.toString());
      //Emit state to show Marked snackbar
      emit(SetArmpitState(true));
    } catch (e) {
      //Emitting error state with message
      emit(ArmpitErrorState("Error updating Armpit event"));
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
        radius: 14,
        backgroundColor: constTransparentColor,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Image.asset(
            kEventIconsPath[1], //Trimmer icon
            color: (gender == kFemaleText) ? constFemaleColor : constMaleColor,
          ),
        ),
      ),
    );
  }

  //Close ArmpitBox while closing ArmpitCubit
  @override
  Future<void> close() {
    _armpitRepo.close();
    return super.close();
  }
}
