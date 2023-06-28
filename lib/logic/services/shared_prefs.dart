import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  //SharedPreferences instance
  static SharedPreferences? _prefs;

  //Init method called at the beginning of the app
  static Future init() async => _prefs = await SharedPreferences.getInstance();

  //Getter: gender
  static String get getGender => _prefs?.getString("gender") ?? "";
  //Getter: isDark
  static bool get getIsDark => _prefs?.getBool("isDark") ?? false;

  //Setter: gender
  static Future setGender(String gender) async =>
      _prefs?.setString("gender", gender);
  //Setter: isDark
  static Future setIsDark(bool isDark) async =>
      _prefs?.setBool("isDark", isDark);
}
