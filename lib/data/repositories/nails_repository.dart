import 'package:hive/hive.dart';

//Using Hive and Hive Flutter packages to perform CRUD operations on database
//NailsBox
class NailsRepository {
  Box<dynamic>? _nailsBox; //_nailsBox instance

  NailsRepository();

  //Open nailsBox and assign to _nailsBox instance
  init() async {
    _nailsBox = await Hive.openBox('nailsBox');
  }

  //Close nailsBox
  close() async {
    await _nailsBox?.close();
  }

  //Get all the hair cut events (DateTime as String) from nailsBox
  Future<List<String>?> getAllNailsEvents() async {
    await init();
    return _nailsBox?.keys.map((e) => e as String).toList();
  }

  //Add a hair cut event in nailsBox
  void addNailsEvent(String date) async {
    await _nailsBox?.put(date, date);
  }

  //Remove an existing hair cut event in nailsBox
  void removeNailsEvent(String date) async {
    await _nailsBox?.delete(date);
  }
}
