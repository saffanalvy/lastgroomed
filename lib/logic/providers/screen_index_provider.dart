import 'package:flutter/material.dart';

//ChangeNotifierProvider to get and set the currentScreenIndex of
//the Curved Bottom Navigation Bar at HomeScreen
class ScreenIndexProvider extends ChangeNotifier {
  //Default initial Curved bottom navbar index (Nails screen)
  int currentScreenIndex = 2;

  //Getter: currentScreenIndex
  int get getScreenIndex => currentScreenIndex;

  //Setter: currentScreenIndex
  void setScreenIndex(int index) {
    currentScreenIndex = index;
    notifyListeners();
  }
}
