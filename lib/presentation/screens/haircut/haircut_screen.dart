import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import '../../../logic/cubits/haircut_cubit/haircut_cubit.dart';
import '../../../logic/cubits/shared_prefs_cubit/shared_prefs_cubit.dart';
import '../../../utils/colors.dart';
import '../../../utils/strings.dart';
import '../../../utils/groomed_snackbar.dart';

class HaircutScreen extends StatefulWidget {
  const HaircutScreen({super.key});

  @override
  State<HaircutScreen> createState() => _HaircutScreenState();
}

class _HaircutScreenState extends State<HaircutScreen> {
  //Screen width
  late double screenWidth;
  //Screen height
  late double screenHeight;

  @override
  void didChangeDependencies() {
    //Setting screen width
    screenWidth = MediaQuery.of(context).size.width;
    //Setting screen height
    screenHeight = MediaQuery.of(context).size.height;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      //Bloc Builder for SharedPrefsCubit
      child: BlocBuilder<SharedPrefsCubit, SharedPrefsState>(
        builder: (context, state) {
          //Getting gender & isDark value from SharedPrefsCubit
          if (state is FetchPrefsState) {
            //Calling getHaircutEventList method from HaircutCubit to
            //Get marked dates list as EventList<Event>? from
            //HaircutLoadedState
            context
                .read<HaircutCubit>()
                .getHaircutEventList(state.gender, state.isDark);

            //Bloc Consumer for HaircutCubit
            return BlocConsumer<HaircutCubit, HaircutState>(
              listener: (context, state2) {
                //Show snackbar if error
                if (state2 is HaircutErrorState) {
                  GroomedSnackbar.showSnackBar(
                    context: context,
                    type: 2,
                    gender: state.gender,
                    message: state2.message,
                  );
                }

                //Show snackbar if tapped on calendar event/date
                if (state2 is SetHaircutState) {
                  //Show snackbar if date marked
                  if (state2.marking == true) {
                    GroomedSnackbar.showSnackBar(
                      context: context,
                      type: 1,
                      gender: state.gender,
                      message: "Marked!",
                    );
                  }

                  //Show snackbar if date unmarked
                  if (state2.marking == false) {
                    GroomedSnackbar.showSnackBar(
                      context: context,
                      type: 1,
                      gender: state.gender,
                      message: "Unmarked!",
                    );
                  }
                }
              },
              builder: (context, state2) {
                //Show loading widget for HaircutLoadingState
                if (state2 is HaircutLoadingState) {
                  return Container(
                    width: screenWidth,
                    height: screenHeight / 1.2,
                    color: constTransparentColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CircleAvatar(
                            backgroundColor: constTransparentColor,
                            radius: 20,
                            child: Image.asset(kAppIconPath),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Loading...",
                          style: TextStyle(
                            color: (state.isDark == true)
                                ? constDarkTextColor
                                : constLightTextColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                //If all Haircut events are loaded then show the Calendar
                if (state2 is HaircutLoadedState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      //Header (Button is just for show)
                      OutlinedButton(
                        onPressed: () {},
                        child: Text(
                          "Haircut",
                          style: TextStyle(
                            color: (state.gender == kFemaleText)
                                ? constFemaleColor
                                : constMaleColor,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      //Calendar from Flutter Calendar Carousel package
                      CalendarCarousel(
                        width: screenWidth,
                        height: screenHeight / 1.9,
                        markedDatesMap: state2.haircutEventList, //EventList
                        prevDaysTextStyle: const TextStyle(
                          fontFamily: kFontFamily,
                          fontSize: 14,
                          color: constGreyColor,
                        ),
                        nextDaysTextStyle: const TextStyle(
                          fontFamily: kFontFamily,
                          fontSize: 14,
                          color: constGreyColor,
                        ),
                        todayTextStyle:
                            const TextStyle(fontFamily: kFontFamily),
                        weekdayTextStyle:
                            const TextStyle(fontFamily: kFontFamily),
                        headerTextStyle: const TextStyle(
                          fontFamily: kFontFamily,
                          color: constBlueColor,
                          fontSize: 25,
                        ),
                        weekendTextStyle:
                            const TextStyle(fontFamily: kFontFamily),
                        daysTextStyle: TextStyle(
                          fontFamily: kFontFamily,
                          color: (state.isDark!)
                              ? constDarkTextColor
                              : constLightTextColor,
                        ),
                        onDayPressed: (p0, p1) {
                          //Set or remove Haircut event
                          context.read<HaircutCubit>().setHaircutEvent(p0);

                          //Load entire Haircut Event List on tapping event/date
                          context
                              .read<HaircutCubit>()
                              .getHaircutEventList(state.gender, state.isDark);
                        },
                      ),

                      //Showing the Last Haircut Date by
                      //Getting the Haircut events map and
                      //If it is not empty then
                      //From the events map taking the last date and
                      //Formatting it as May 15, 1988 format
                      Text(
                        (state2.haircutEventList.events.isNotEmpty)
                            ? 'Last Haircut: ${DateFormat.yMMMMd('en_US').format(state2.haircutEventList.events.keys.last)}'
                            : '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: (state.gender == kFemaleText)
                              ? constFemaleColor
                              : constMaleColor,
                          fontSize: 25,
                        ),
                      ),
                    ],
                  );
                }

                //If state2 is not HaircutLoadedState
                return const SizedBox();
              },
            );
          }

          //If state is not FetchPrefsState
          return const SizedBox();
        },
      ),
    );
  }
}
