import 'package:hive/hive.dart';

//Using Hive and Hive Flutter packages to perform CRUD operations on database
//ShaveBox
class ShaveRepository {
  Box<dynamic>? _shaveBox; //_shaveBox instance

  ShaveRepository();

  //Open shaveBox and assign to _shaveBox instance
  init() async {
    _shaveBox = await Hive.openBox('shaveBox');
  }

  //Close shaveBox
  close() async {
    await _shaveBox?.close();
  }

  //Get all the hair cut events (DateTime as String) from shaveBox
  Future<List<String>?> getAllShaveEvents() async {
    await init();
    return _shaveBox?.keys.map((e) => e as String).toList();
  }

  //Add a hair cut event in shaveBox
  void addShaveEvent(String date) async {
    await _shaveBox?.put(date, date);
  }

  //Remove an existing hair cut event in shaveBox
  void removeShaveEvent(String date) async {
    await _shaveBox?.delete(date);
  }
}
