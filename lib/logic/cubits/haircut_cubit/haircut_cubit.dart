import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import '../../../data/repositories/haircut_repository.dart';
import '../../../utils/colors.dart';
import '../../../utils/strings.dart';

part 'haircut_state.dart';

class HaircutCubit extends Cubit<HaircutState> {
  //Haircut Repository instance
  final HaircutRepository _haircutRepo = HaircutRepository();

  HaircutCubit() : super(HaircutInitial());

  //Getting all the Events (DateTime as String) from Haircut Box and then
  //Generating EventList<Event>? object from the Events list
  //By parsing DateTime from String and adding Event objects in
  //EventList<Event>? object also with Event Icon widget and finally
  //Emitting the complete EventList<Event>? object through HaircutLoadedState
  //To pass it to HaircutScreen to markedDatesMap property of the
  //CalendarCarousel (from Flutter Calendar Carousel package)
  void getHaircutEventList(String? gender, bool? isDark) async {
    //Emitting loading state
    emit(HaircutLoadingState());

    try {
      //Initializing a not null but empty EventList
      EventList<Event> haircutEventList = EventList<Event>(events: {});
      //Getting all Haircut Events from HaircutBox: DateTime as String
      List<String>? allHaircutEvents = await _haircutRepo.getAllHaircutEvents();

      //If there is existing events inside HaircutBox
      if (allHaircutEvents != null) {
        //For all Date(DateTime as String) inside allHaircutEvents list
        //From HaircutBox
        for (var date in allHaircutEvents) {
          //Add Event by parsing the current Date (DateTime.parse) in the loop
          haircutEventList.add(
            DateTime.parse(date),
            Event(
              date: DateTime.parse(date),
              title: 'Haircut',
              dot: _getEventIcon(gender, isDark),
            ),
          );
        }
        //Finally emit the EventList<Event>? to HaircutScreen by using
        //HaircutLoadedState
        emit(HaircutLoadedState(haircutEventList));
      }
    } catch (e) {
      //Emitting error state with message
      emit(HaircutErrorState("Error loading haircut events"));
    }
  }

  //Add or Remove Haircut Event based on the tapped Date
  void setHaircutEvent(DateTime date) async {
    try {
      //Getting all Haircut Events from HaircutBox: DateTime as String
      List<String>? allHaircutEvents = await _haircutRepo.getAllHaircutEvents();

      //If Haircut EventList is not empty
      if (allHaircutEvents != null) {
        //If the tapped Date already exists inside the Haircut EventList
        bool isExist = allHaircutEvents.contains(date.toString());
        if (isExist) {
          //Remove tapped Date from Haircut EventList
          _haircutRepo.removeHaircutEvent(date.toString());

          //Emit state to show Unmarked snackbar
          emit(SetHaircutState(false));
          return;
        }
      }

      //Add tapped Date to HaircutBox
      _haircutRepo.addHaircutEvent(date.toString());
      //Emit state to show Marked snackbar
      emit(SetHaircutState(true));
    } catch (e) {
      //Emitting error state with message
      emit(HaircutErrorState("Error updating haircut event"));
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
        radius: 13,
        backgroundColor: constTransparentColor,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Image.asset(
            kEventIconsPath[0], //Scissor icon
            color: (gender == kFemaleText) ? constFemaleColor : constMaleColor,
          ),
        ),
      ),
    );
  }

  //Close HaircutBox while closing HaircutCubit
  @override
  Future<void> close() {
    _haircutRepo.close();
    return super.close();
  }
}
