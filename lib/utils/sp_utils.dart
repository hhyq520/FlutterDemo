import 'package:shared_preferences/shared_preferences.dart';
class SPUtils{
  static saveString(String key,String value) async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    sharedPreferences.setString(key, value);
  }
  static saveList(String key, List<String> value) async {
    SharedPreferences spf = await SharedPreferences.getInstance();
    spf.setStringList(key, value);
  }
  static save(String key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static get(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }
  static remove(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}