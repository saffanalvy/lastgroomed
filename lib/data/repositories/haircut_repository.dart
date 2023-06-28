import 'package:hive/hive.dart';

//Using Hive and Hive Flutter packages to perform CRUD operations on database
//HaircutBox
class HaircutRepository {
  Box<dynamic>? _haircutBox; //_haircutBox instance

  HaircutRepository();

  //Open haircutBox and assign to _haircutBox instance
  init() async {
    _haircutBox = await Hive.openBox('haircutBox');
  }

  //Close haircutBox
  close() async {
    await _haircutBox?.close();
  }

  //Get all the hair cut events (DateTime as String) from haircutBox
  Future<List<String>?> getAllHaircutEvents() async {
    await init();
    return _haircutBox?.keys.map((e) => e as String).toList();
  }

  //Add a hair cut event in haircutBox
  void addHaircutEvent(String date) async {
    await _haircutBox?.put(date, date);
  }

  //Remove an existing hair cut event in haircutBox
  void removeHaircutEvent(String date) async {
    await _haircutBox?.delete(date);
  }
}
