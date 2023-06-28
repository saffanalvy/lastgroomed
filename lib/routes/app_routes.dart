import 'package:flutter/material.dart';
import '../logic/providers/screen_index_provider.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/info/info_screen.dart';
import '../presentation/screens/set_gender/set_gender_screen.dart';
import '../presentation/screens/settings/settings_screen.dart';
import 'package:provider/provider.dart';

//Generating AppRoutes class for generated named routes
class AppRoutes {
  static Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case "/home":
        return MaterialPageRoute(
          //Putting ScreenIndexProvider to provide the selected screen index
          //by the Curved bottom navbar at HomeScreen
          builder: (BuildContext context) => ChangeNotifierProvider(
            create: (_) => ScreenIndexProvider(),
            child: const HomeScreen(),
          ),
        );

      case "/set_gender":
        return MaterialPageRoute(
          builder: (BuildContext context) => const SetGenderScreen(),
        );

      case "/settings":
        return MaterialPageRoute(
          builder: (BuildContext context) => const SettingsScreen(),
        );

      case "/info":
        //Passing the title arguement so that based on the title the
        //InfoScreen displays the specified text
        Map<String, dynamic> arguments =
            routeSettings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (BuildContext context) =>
              InfoScreen(title: arguments["title"]),
        );

      default:
        return null;
    }
  }
}
