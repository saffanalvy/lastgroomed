import 'package:hive/hive.dart';

//Using Hive and Hive Flutter packages to perform CRUD operations on database
//ArmpitBox
class ArmpitRepository {
  Box<dynamic>? _armpitBox; //_armpitBox instance

  ArmpitRepository();

  //Open armpitBox and assign to _armpitBox instance
  init() async {
    _armpitBox = await Hive.openBox('armpitBox');
  }

  //Close armpitBox
  close() async {
    await _armpitBox?.close();
  }

  //Get all the hair cut events (DateTime as String) from armpitBox
  Future<List<String>?> getAllArmpitEvents() async {
    await init();
    return _armpitBox?.keys.map((e) => e as String).toList();
  }

  //Add a hair cut event in armpitBox
  void addArmpitEvent(String date) async {
    await _armpitBox?.put(date, date);
  }

  //Remove an existing hair cut event in armpitBox
  void removeArmpitEvent(String date) async {
    await _armpitBox?.delete(date);
  }
}
