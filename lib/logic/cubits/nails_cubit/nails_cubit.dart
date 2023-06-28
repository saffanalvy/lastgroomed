import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import '../../../data/repositories/nails_repository.dart';
import '../../../utils/colors.dart';
import '../../../utils/strings.dart';

part 'nails_state.dart';

class NailsCubit extends Cubit<NailsState> {
  //Nails Repository instance
  final NailsRepository _nailsRepo = NailsRepository();

  NailsCubit() : super(NailsInitial());

  //Getting all the Events (DateTime as String) from Nails Box and then
  //Generating EventList<Event>? object from the Events list
  //By parsing DateTime from String and adding Event objects in
  //EventList<Event>? object also with Event Icon widget and finally
  //Emitting the complete EventList<Event>? object through NailsLoadedState
  //To pass it to NailsScreen to markedDatesMap property of the
  //CalendarCarousel (from Flutter Calendar Carousel package)
  void getNailsEventList(String? gender, bool? isDark) async {
    //Emitting loading state
    emit(NailsLoadingState());

    try {
      //Initializing a not null but empty EventList
      EventList<Event> nailsEventList = EventList<Event>(events: {});
      //Getting all Nails Events from NailsBox: DateTime as String
      List<String>? allNailsEvents = await _nailsRepo.getAllNailsEvents();

      //If there is existing events inside NailsBox
      if (allNailsEvents != null) {
        //For all Date(DateTime as String) inside allNailsEvents list
        //From NailsBox
        for (var date in allNailsEvents) {
          //Add Event by parsing the current Date (DateTime.parse) in the loop
          nailsEventList.add(
            DateTime.parse(date),
            Event(
              date: DateTime.parse(date),
              title: 'Nails',
              dot: _getEventIcon(gender, isDark),
            ),
          );
        }
        //Finally emit the EventList<Event>? to NailsScreen by using
        //NailsLoadedState
        emit(NailsLoadedState(nailsEventList));
      }
    } catch (e) {
      //Emitting error state with message
      emit(NailsErrorState("Error loading Nails events"));
    }
  }

  //Add or Remove Nails Event based on the tapped Date
  void setNailsEvent(DateTime date) async {
    try {
      //Getting all Nails Events from NailsBox: DateTime as String
      List<String>? allNailsEvents = await _nailsRepo.getAllNailsEvents();

      //If Nails EventList is not empty
      if (allNailsEvents != null) {
        //If the tapped Date already exists inside the Nails EventList
        bool isExist = allNailsEvents.contains(date.toString());
        if (isExist) {
          //Remove tapped Date from Nails EventList
          _nailsRepo.removeNailsEvent(date.toString());

          //Emit state to show Unmarked snackbar
          emit(SetNailsState(false));
          return;
        }
      }

      //Add tapped Date to NailsBox
      _nailsRepo.addNailsEvent(date.toString());
      //Emit state to show Marked snackbar
      emit(SetNailsState(true));
    } catch (e) {
      //Emitting error state with message
      emit(NailsErrorState("Error updating Nails event"));
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
            kEventIconsPath[3], //Nail Clipper 2 icon
            color: (gender == kFemaleText) ? constFemaleColor : constMaleColor,
          ),
        ),
      ),
    );
  }

  //Close NailsBox while closing NailsCubit
  @override
  Future<void> close() {
    _nailsRepo.close();
    return super.close();
  }
}
