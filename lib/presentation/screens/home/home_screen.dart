import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/cubits/shared_prefs_cubit/shared_prefs_cubit.dart';
import '../../../logic/providers/screen_index_provider.dart';
import '../armpit/armpit_screen.dart';
import '../haircut/haircut_screen.dart';
import '../nails/nails_screen.dart';
import '../pubes/pubes_screen.dart';
import '../shave/shave_screen.dart';
import '../../../utils/colors.dart';
import '../../../utils/strings.dart';
import '../../../utils/groomed_snackbar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Global key instance for bottom navbar
  late GlobalKey<CurvedNavigationBarState> bottomNavigationKey;
  //Screen Index Provider instace for selected screen
  late ScreenIndexProvider screenIndexProvider;
  //List of all 5 calendar screens instance
  late List<StatefulWidget> screens;
  //List of icons of gender:male for bottom navbar instance
  late List<Widget> maleIconsList;
  //List of icons of gender:female for bottom navbar instance
  late List<Widget> femaleIconsList;

  @override
  void initState() {
    //Initiating global key
    bottomNavigationKey = GlobalKey();

    //Assigning screen stateful widgets to screens list
    screens = [
      const HaircutScreen(),
      const ShaveScreen(),
      const NailsScreen(),
      const ArmpitScreen(),
      const PubesScreen(),
    ];

    //Assigning widgets and images to the male icon list
    maleIconsList = [
      CircleAvatar(radius: 20, child: Image.asset(kMaleNavbarIconsPath[0])),
      CircleAvatar(radius: 20, child: Image.asset(kMaleNavbarIconsPath[1])),
      CircleAvatar(radius: 20, child: Image.asset(kMaleNavbarIconsPath[2])),
      CircleAvatar(radius: 20, child: Image.asset(kMaleNavbarIconsPath[3])),
      CircleAvatar(
        radius: 20,
        child: Image.asset(kMaleNavbarIconsPath[4], color: Colors.black),
      ),
    ];

    //Assigning widgets and images to the female icon list
    femaleIconsList = [
      CircleAvatar(radius: 20, child: Image.asset(kFemaleNavbarIconsPath[0])),
      CircleAvatar(radius: 20, child: Image.asset(kFemaleNavbarIconsPath[1])),
      CircleAvatar(radius: 20, child: Image.asset(kFemaleNavbarIconsPath[2])),
      CircleAvatar(radius: 20, child: Image.asset(kFemaleNavbarIconsPath[3])),
      CircleAvatar(
        radius: 20,
        child: Image.asset(kFemaleNavbarIconsPath[4], color: Colors.black),
      ),
    ];

    super.initState();
  }

  @override
  void didChangeDependencies() {
    //Initializing Screen Index Provider
    screenIndexProvider = Provider.of<ScreenIndexProvider>(context);
    //Fetching Shared Preferences and getting gender & isDark values
    context.read<SharedPrefsCubit>().getPrefs();

    super.didChangeDependencies();
  }

  //Changing bottom navbar's selected index to 2 and selecting NailsScreen
  //So that bottom navbar refreshes after clicking or
  //Changing gender in the settings screen so that the
  //Icons of the bottom navbar updates properly and
  //Select the initial screen as the center most screen which is Nails
  void changingBottomBarIndexToUpdateIndexZero() {
    final CurvedNavigationBarState? navBarState =
        bottomNavigationKey.currentState;
    navBarState?.setPage(2);
  }

  @override
  Widget build(BuildContext context) {
    //Bloc Consumer for SharedPrefsCubit
    return BlocConsumer<SharedPrefsCubit, SharedPrefsState>(
      listener: (context, state) {
        if (state is ErrorState) {
          //Show snackbar if error
          GroomedSnackbar.showSnackBar(
            context: context,
            type: 2,
            message: state.message,
          );
        }
      },
      builder: (context, state) {
        //Show circular progress indicator
        if (state is LoadingState) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CircleAvatar(
                    backgroundColor: constTransparentColor,
                    radius: 20,
                    child: Image.asset(kAppIconPath),
                  ),
                ),
              ),
            ),
          );
        }

        //Getting gender & isDark values from SharedPrefsCubit and
        //Preparing theme with scaffold, appbar, bottom navbar and etc.
        //Based on gender & isDark value
        if (state is FetchPrefsState) {
          return SafeArea(
            top: false,
            child: ClipRRect(
              child: Scaffold(
                backgroundColor: (state.isDark!)
                    ? constDarkScaffoldBodyColor
                    : constLightScaffoldBodyColor,
                extendBody: true,
                appBar: AppBar(
                  backgroundColor: (state.gender == kFemaleText)
                      ? constFemaleColor
                      : constMaleColor,
                  title: Text(
                    kAppTitle,
                    style: TextStyle(
                      color: (state.gender == kFemaleText)
                          ? constDarkTextColor
                          : constLightTextColor,
                    ),
                  ),
                  actions: [
                    TextButton.icon(
                      onPressed: () {
                        //Setting global key value of bottom navbar to 2
                        changingBottomBarIndexToUpdateIndexZero();
                        //Navigating to SettingsScreen
                        Navigator.pushNamed(context, "/settings");
                      },
                      icon: Icon(
                        Icons.settings,
                        color: (state.gender == kFemaleText)
                            ? constDarkTextColor
                            : constLightTextColor,
                      ),
                      label: Text(
                        "Settings",
                        style: TextStyle(
                          color: (state.gender == kFemaleText)
                              ? constDarkTextColor
                              : constLightTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                //Getting the selected index value from
                //Selected Index Provider
                //Default is 2
                body: screens[screenIndexProvider.getScreenIndex],
                //Setting Curved Navigation Bar as bottom navbar
                bottomNavigationBar: CurvedNavigationBar(
                  key: bottomNavigationKey,
                  color: (state.gender == kFemaleText)
                      ? constFemaleColor
                      : constMaleColor,
                  backgroundColor: constTransparentColor,
                  height: 60,
                  animationCurve: Curves.easeInOut,
                  //Getting current selected index from
                  //Screen Index Provider
                  index: screenIndexProvider.getScreenIndex,
                  animationDuration: const Duration(milliseconds: 1500),
                  items: (state.gender == kFemaleText)
                      ? femaleIconsList
                      : maleIconsList,
                  onTap: (index) {
                    //Setting new selected screen index value in
                    //Screen Index Provider
                    screenIndexProvider.setScreenIndex(index);
                  },
                ),
              ),
            ),
          );
        }

        //If state is not FetchPrefsState
        return const Scaffold(
          body: SafeArea(
            child: Center(
              child: Text("Something went wrong!"),
            ),
          ),
        );
      },
    );
  }
}
