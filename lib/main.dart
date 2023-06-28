import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'logic/cubits/armpit_cubit/armpit_cubit.dart';
import 'logic/cubits/haircut_cubit/haircut_cubit.dart';
import 'logic/cubits/nails_cubit/nails_cubit.dart';
import 'logic/cubits/pubes_cubit/pubes_cubit.dart';
import 'logic/cubits/shared_prefs_cubit/shared_prefs_cubit.dart';
import 'logic/cubits/shave_cubit/shave_cubit.dart';
import 'logic/services/shared_prefs.dart';
import 'routes/app_routes.dart';
import 'utils/colors.dart';
import 'utils/strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Shared Preferences
  await SharedPrefs.init();
  final gender = SharedPrefs.getGender;
  final isDark = SharedPrefs.getIsDark;

  //Hive Database
  await Hive.initFlutter();

  //For Android platform, change color of bottom navbar of android
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: constDarkScaffoldBodyColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  //Portrait Oreintation
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp(gender: gender, isDark: isDark));
}

class MyApp extends StatelessWidget {
  final String gender;
  final bool isDark;
  const MyApp({super.key, required this.gender, required this.isDark});

  @override
  Widget build(BuildContext context) {
    //Instanciating all the Blocs in a MultiBlocProvider
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SharedPrefsCubit(), lazy: false),
        BlocProvider(create: (context) => HaircutCubit(), lazy: false),
        BlocProvider(create: (context) => ShaveCubit(), lazy: false),
        BlocProvider(create: (context) => NailsCubit(), lazy: false),
        BlocProvider(create: (context) => ArmpitCubit(), lazy: false),
        BlocProvider(create: (context) => PubesCubit(), lazy: false),
      ],
      child: MaterialApp(
        title: kAppTitle,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: kFontFamily,
          appBarTheme: AppBarTheme(
            //Setting up App Bar Theme color based on Gender
            color: (gender == kFemaleText) ? constFemaleColor : constMaleColor,
          ),
          colorScheme: ColorScheme.fromSeed(
            //Setting up Primary color based on Light/Dark mode
            primary: (isDark) ? constDarkTextColor : constLightTextColor,
            //Setting up Seed (Material 3) color based on Gender
            seedColor:
                (gender == kFemaleText) ? constFemaleColor : constMaleColor,
          ),
          useMaterial3: true,
        ),
        onGenerateRoute: AppRoutes.onGenerateRoute,
        //If app runs for the first time then initial route is SetGenderScreen
        //Else HomeScreen
        initialRoute: (gender.isEmpty) ? "/set_gender" : "/home",
      ),
    );
  }
}
