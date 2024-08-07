import 'package:shared_preferences/shared_preferences.dart';

class SharePrefrenceClass {
  //save  value
  Future<void> saveValuebool({required dynamic value, required String key}) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(key, value);
  }

  //get  value
  Future<dynamic> getVlue({required String key}) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    dynamic value = pref.get(key) ?? false;
    return value;
  }



}

   
