import 'package:hive/hive.dart';

//Using Hive and Hive Flutter packages to perform CRUD operations on database
//PubesBox
class PubesRepository {
  Box<dynamic>? _pubesBox; //_pubesBox instance

  PubesRepository();

  //Open pubesBox and assign to _pubesBox instance
  init() async {
    _pubesBox = await Hive.openBox('pubesBox');
  }

  //Close pubesBox
  close() async {
    await _pubesBox?.close();
  }

  //Get all the hair cut events (DateTime as String) from pubesBox
  Future<List<String>?> getAllPubesEvents() async {
    await init();
    return _pubesBox?.keys.map((e) => e as String).toList();
  }

  //Add a hair cut event in pubesBox
  void addPubesEvent(String date) async {
    await _pubesBox?.put(date, date);
  }

  //Remove an existing hair cut event in pubesBox
  void removePubesEvent(String date) async {
    await _pubesBox?.delete(date);
  }
}
