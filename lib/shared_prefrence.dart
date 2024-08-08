import 'package:shared_preferences/shared_preferences.dart';

class SharePrefrenceClass {
  //save  value
  Future<void> saveValuebool({required bool value, required String key}) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(key, value);
  }
 Future<void> saveValueString({required String value, required String key}) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(key, value);
  }
   Future<void> saveValueint({required int value, required String key}) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt(key, value);
  }
  //get  value
  Future<dynamic> getVlue({required String key,required dynamic defaultValue}) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    dynamic value = pref.get(key) ?? defaultValue;
    return value;
  }



}

   
