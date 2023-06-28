import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import '../../../logic/cubits/shave_cubit/shave_cubit.dart';
import '../../../logic/cubits/shared_prefs_cubit/shared_prefs_cubit.dart';
import '../../../utils/colors.dart';
import '../../../utils/strings.dart';
import '../../../utils/groomed_snackbar.dart';

class ShaveScreen extends StatefulWidget {
  const ShaveScreen({super.key});

  @override
  State<ShaveScreen> createState() => _ShaveScreenState();
}

class _ShaveScreenState extends State<ShaveScreen> {
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
            //Calling getShaveEventList method from ShaveCubit to
            //Get marked dates list as EventList<Event>? from
            //ShaveLoadedState
            context
                .read<ShaveCubit>()
                .getShaveEventList(state.gender, state.isDark);

            //Bloc Consumer for ShaveCubit
            return BlocConsumer<ShaveCubit, ShaveState>(
              listener: (context, state2) {
                //Show snackbar if error
                if (state2 is ShaveErrorState) {
                  GroomedSnackbar.showSnackBar(
                    context: context,
                    type: 2,
                    gender: state.gender,
                    message: state2.message,
                  );
                }

                //Show snackbar if tapped on calendar event/date
                if (state2 is SetShaveState) {
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
                //Show loading widget for ShaveLoadingState
                if (state2 is ShaveLoadingState) {
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

                //If all Shave events are loaded then show the Calendar
                if (state2 is ShaveLoadedState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      //Header (Button is just for show)
                      OutlinedButton(
                        onPressed: () {},
                        child: Text(
                          "Shave",
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
                        markedDatesMap: state2.shaveEventList, //EventList
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
                          //Set or remove Shave event
                          context.read<ShaveCubit>().setShaveEvent(p0);

                          //Load entire Shave Event List on tapping event/date
                          context
                              .read<ShaveCubit>()
                              .getShaveEventList(state.gender, state.isDark);
                        },
                      ),

                      //Showing the Last Shave Date by
                      //Getting the Shave events map and
                      //If it is not empty then
                      //From the events map taking the last date and
                      //Formatting it as May 15, 1988 format
                      Text(
                        (state2.shaveEventList.events.isNotEmpty)
                            ? 'Last Shave: ${DateFormat.yMMMMd('en_US').format(state2.shaveEventList.events.keys.last)}'
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

                //If state2 is not ShaveLoadedState
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
